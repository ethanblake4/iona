// Copyright (c) 2020, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Utility methods to compute the value of the features used for code
/// completion.
import 'dart:math' as math;

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/dart/element/element.dart'
    show
        ClassElement,
        ConstructorElement,
        Element,
        ElementKind,
        FieldElement,
        LibraryElement,
        PropertyAccessorElement,
        TopLevelVariableElement;
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/type_provider.dart';
import 'package:analyzer/dart/element/type_system.dart';
import 'package:analyzer/src/dart/resolver/body_inference_context.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart' as protocol;
import 'package:analyzer_plugin/src/protocol/protocol_internal.dart' as protocol;
import 'package:analyzer_plugin/utilities/range_factory.dart';
import 'package:iona_flutter/plugin/dart/utils/extensions/element.dart';

import 'relevance_tables.g.dart';

const List<String> intNames = ['i', 'j', 'index', 'length'];
const List<String> listNames = ['list', 'items'];
const List<String> numNames = ['height', 'width'];
const List<String> stringNames = ['key', 'text', 'url', 'uri', 'name', 'str', 'string'];

DartType impliedDartTypeWithName(TypeProvider typeProvider, String name) {
  if (typeProvider == null || name == null || name.isEmpty) {
    return null;
  }
  if (intNames.contains(name)) {
    return typeProvider.intType;
  } else if (numNames.contains(name)) {
    return typeProvider.numType;
  } else if (listNames.contains(name)) {
    return typeProvider.listType2(typeProvider.dynamicType);
  } else if (stringNames.contains(name)) {
    return typeProvider.stringType;
  } else if (name == 'iterator') {
    return typeProvider.iterableDynamicType;
  } else if (name == 'map') {
    return typeProvider.mapType2(typeProvider.dynamicType, typeProvider.dynamicType);
  }
  return null;
}

/// Convert a relevance score (assumed to be between `0.0` and `1.0` inclusive)
/// to a relevance value between `0` and `1000`. If the score is outside that
/// range, return the [defaultValue].
int toRelevance(double score, int defaultValue) {
  if (score < 0.0 || score > 1.0) {
    return defaultValue;
  }
  return (score * 1000).truncate();
}

/// Return the weighted average of the given [values], applying the given
/// [weights]. The number of weights must be equal to the number of values.
/// Values less than `0.0` are ignored. If there are no non-negative values then
/// a negative value will be returned.
double weightedAverage(List<double> values, List<double> weights) {
  assert(values.length == weights.length);
  var totalValue = 0.0;
  var totalWeight = 0.0;
  for (var i = 0; i < values.length; i++) {
    var value = values[i];
    if (value >= 0.0) {
      var weight = weights[i];
      totalValue += value * weight;
      totalWeight += weight;
    }
  }
  if (totalWeight == 0.0) {
    return -1.0;
  }
  return totalValue / totalWeight;
}

/// An object that computes the values of features.
class FeatureComputer {
  /// The type system used to perform operations on types.
  final TypeSystem typeSystem;

  /// The type provider used to access types defined by the spec.
  final TypeProvider typeProvider;

  /// Initialize a newly created feature computer.
  FeatureComputer(this.typeSystem, this.typeProvider);

  /// Return the type imposed when completing at the given [offset], where the
  /// offset is within the given [node], or `null` if the context does not
  /// impose any type.
  DartType computeContextType(AstNode node, int offset) {
    var type = node.accept(_ContextTypeVisitor(typeProvider, offset));
    if (type == null || type.isDynamic) {
      return null;
    }
    return type;
  }

  /// Return the element kind used to compute relevance for the given [element].
  /// This differs from the kind returned to the client in that getters and
  /// setters are always mapped into a different kind: FIELD for getters and
  /// setters declared in a class or extension, and TOP_LEVEL_VARIABLE for
  /// top-level getters and setters.
  protocol.ElementKind computeElementKind(Element element) {
    if (element is LibraryElement) {
      return protocol.ElementKind.PREFIX;
    } else if (element is ClassElement) {
      if (element.isEnum) {
        return protocol.ElementKind.ENUM;
      } else if (element.isMixin) {
        return protocol.ElementKind.MIXIN;
      }
      return protocol.ElementKind.CLASS;
    } else if (element is FieldElement && element.isEnumConstant) {
      return protocol.ElementKind.ENUM_CONSTANT;
    } else if (element is PropertyAccessorElement) {
      element = (element as PropertyAccessorElement).variable;
    }
    var kind = element.kind;
    if (kind == ElementKind.CONSTRUCTOR) {
      return protocol.ElementKind.CONSTRUCTOR;
    } else if (kind == ElementKind.EXTENSION) {
      return protocol.ElementKind.EXTENSION;
    } else if (kind == ElementKind.FIELD) {
      return protocol.ElementKind.FIELD;
    } else if (kind == ElementKind.FUNCTION) {
      return protocol.ElementKind.FUNCTION;
    } else if (kind == ElementKind.FUNCTION_TYPE_ALIAS) {
      return protocol.ElementKind.FUNCTION_TYPE_ALIAS;
    } else if (kind == ElementKind.GENERIC_FUNCTION_TYPE) {
      return protocol.ElementKind.FUNCTION_TYPE_ALIAS;
    } else if (kind == ElementKind.LABEL) {
      return protocol.ElementKind.LABEL;
    } else if (kind == ElementKind.LOCAL_VARIABLE) {
      return protocol.ElementKind.LOCAL_VARIABLE;
    } else if (kind == ElementKind.METHOD) {
      return protocol.ElementKind.METHOD;
    } else if (kind == ElementKind.PARAMETER) {
      return protocol.ElementKind.PARAMETER;
    } else if (kind == ElementKind.PREFIX) {
      return protocol.ElementKind.PREFIX;
    } else if (kind == ElementKind.TOP_LEVEL_VARIABLE) {
      return protocol.ElementKind.TOP_LEVEL_VARIABLE;
    } else if (kind == ElementKind.TYPE_PARAMETER) {
      return protocol.ElementKind.TYPE_PARAMETER;
    }
    return protocol.ElementKind.UNKNOWN;
  }

  /// Return the value of the _context type_ feature for an element with the
  /// given [elementType] when completing in a location with the given
  /// [contextType].
  double contextTypeFeature(DartType contextType, DartType elementType) {
    if (contextType == null || elementType == null) {
      // Disable the feature if we don't have both types.
      return -1.0;
    }
    if (elementType == contextType) {
      // Exact match.
      return 1.0;
    } else if (typeSystem.isSubtypeOf(elementType, contextType)) {
      // Subtype.
      return 0.40;
    } else if (typeSystem.isSubtypeOf(contextType, elementType)) {
      // Supertype.
      return 0.02;
    } else {
      // Unrelated.
      return 0.13;
    }
  }

  /// Return the value of the _element kind_ feature for the [element] when
  /// completing at the given [completionLocation]. If a [distance] is given it
  /// will be used to provide finer-grained relevance scores.
  double elementKindFeature(Element element, String completionLocation, {int distance}) {
    if (completionLocation == null) {
      return -1.0;
    }
    var locationTable = elementKindRelevance[completionLocation];
    if (locationTable == null) {
      return -1.0;
    }
    var range = locationTable[computeElementKind(element)];
    if (range == null) {
      return 0.0;
    }
    if (distance == null) {
      return range.upper;
    }
    return range.conditionalProbability(_distanceToPercent(distance));
  }

  /// Return the value of the _has deprecated_ feature for the given [element].
  double hasDeprecatedFeature(Element element) {
    return element.hasOrInheritsDeprecated ? 0.0 : 1.0;
  }

  /// Return the inheritance distance between the [subclass] and the
  /// [superclass]. We define the inheritance distance between two types to be
  /// zero if the two types are the same and the minimum number of edges that
  /// must be traversed in the type graph to get from the subtype to the
  /// supertype if the two types are not the same. Return `-1` if the [subclass]
  /// is not a subclass of the [superclass].
  int inheritanceDistance(ClassElement subclass, ClassElement superclass) {
    // This method is only visible for the metrics computation and might be made
    // private at some future date.
    return _inheritanceDistance(subclass, superclass, {});
  }

  /// Return the value of the _inheritance distance_ feature for a member
  /// defined in the [superclass] that is being accessed through an expression
  /// whose static type is the [subclass].
  double inheritanceDistanceFeature(ClassElement subclass, ClassElement superclass) {
    var distance = _inheritanceDistance(subclass, superclass, {});
    if (distance < 0) {
      return 0.0;
    }
    return _distanceToPercent(distance);
  }

  /// Return the value of the _is constant_ feature for the given [element].
  double isConstantFeature(Element element) {
    if (element is ConstructorElement && element.isConst) {
      return 1.0;
    } else if (element is FieldElement && element.isStatic && element.isConst) {
      return 1.0;
    } else if (element is TopLevelVariableElement && element.isConst) {
      return 1.0;
    } else if (element is PropertyAccessorElement &&
        element.isSynthetic &&
        element.variable.isStatic &&
        element.variable.isConst) {
      return 1.0;
    }
    return 0.0;
  }

  /// Return the value of the _keyword_ feature for the [keyword] when
  /// completing at the given [completionLocation].
  double keywordFeature(String keyword, String completionLocation) {
    if (completionLocation == null) {
      return -1.0;
    }
    var locationTable = keywordRelevance[completionLocation];
    if (locationTable == null) {
      return -1.0;
    }
    var range = locationTable[keyword];
    if (range == null) {
      // We sometimes suggest multiple tokens where a keyword is allowed, such
      // as 'async*'. In those cases a valid keyword is always first followed by
      // a non-alphabetic character. Try stripping off everything after the
      // keyword and indexing into the table again.
      var index = keyword.indexOf(RegExp('[^a-z]'));
      if (index > 0) {
        range = locationTable[keyword.substring(0, index)];
      }
    }
    if (range == null) {
      return 0.0;
    }
    return range.upper;
  }

  /// Return the value of the _starts with dollar_ feature.
  double startsWithDollarFeature(String name) => name.startsWith('\$') ? 0.0 : 1.0;

  /// Return the value of the _super matches_ feature.
  double superMatchesFeature(String containingMethodName, String proposedMemberName) =>
      containingMethodName == null ? -1.0 : (proposedMemberName == containingMethodName ? 1.0 : 0.0);

  /// Convert a [distance] to a percentage value and return the percentage.
  double _distanceToPercent(int distance) => math.pow(0.95, distance);

  /// Return the inheritance distance between the [subclass] and the
  /// [superclass]. The set of [visited] elements is used to guard against
  /// cycles in the type graph.
  ///
  /// This is the implementation of [inheritanceDistance].
  int _inheritanceDistance(ClassElement subclass, ClassElement superclass, Set<ClassElement> visited) {
    if (subclass == null) {
      return -1;
    } else if (subclass == superclass) {
      return 0;
    } else if (!visited.add(subclass)) {
      return -1;
    }
    var minDepth = _inheritanceDistance(subclass.supertype?.element, superclass, visited);

    void visitTypes(List<InterfaceType> types) {
      for (var type in types) {
        var depth = _inheritanceDistance(type.element, superclass, visited);
        if (minDepth < 0 || (depth >= 0 && depth < minDepth)) {
          minDepth = depth;
        }
      }
    }

    visitTypes(subclass.superclassConstraints);
    visitTypes(subclass.mixins);
    visitTypes(subclass.interfaces);

    visited.remove(subclass);
    if (minDepth < 0) {
      return minDepth;
    }
    return minDepth + 1;
  }
}

/// An visitor used to compute the required type of an expression or identifier
/// based on its context. The visitor should be initialized with the node whose
/// context type is to be computed and the parent of that node should be
/// visited.
class _ContextTypeVisitor extends SimpleAstVisitor<DartType> {
  final TypeProvider typeProvider;

  int offset;

  _ContextTypeVisitor(this.typeProvider, this.offset);

  @override
  DartType visitAdjacentStrings(AdjacentStrings node) {
    if (offset == node.offset) {
      return _visitParent(node);
    }
    return typeProvider.stringType;
  }

  @override
  DartType visitArgumentList(ArgumentList node) {
    if (range.endStart(node.leftParenthesis, node.rightParenthesis).contains(offset)) {
      final paramElts = node.functionType?.parameters;
      if (paramElts == null || paramElts.isEmpty) {
        return null;
      }

      // Required parameters
      final positionalParamElts = paramElts.where((param) => !param.isNamed)?.toList(growable: false);
      var i = 0;
      if (positionalParamElts.isNotEmpty) {
        for (; i < node.arguments.length && i < positionalParamElts.length; i++) {
          // We don't need to compare offsets between commas, tests show that
          // such tests aren't needed, also the commas and their respective
          // offsets aren't accessible with existing getters and setters.
          if (node.arguments[i].contains(offset)) {
            return positionalParamElts[i].type;
          }
        }
        // The case where the user is filling out the required parameters
        if (i < positionalParamElts.length) {
          return positionalParamElts[i].type;
        }
      }
      // Named and positional parameters
      if (positionalParamElts.length < paramElts.length) {
        for (; i < node.arguments.length && i < paramElts.length; i++) {
          if (node.arguments[i].contains(offset)) {
            if (node.arguments[i] is NamedExpression) {
              var namedExpression = node.arguments[i] as NamedExpression;
              var needle = paramElts
                  .where((paramElt) => paramElt.isNamed && paramElt.name == namedExpression.name.label.name)
                  ?.first;
              return needle?.type;
            }
          }
        }
      }
    }
    return null;
  }

  @override
  DartType visitAsExpression(AsExpression node) {
    if (node.asOperator.end < offset) {
      return node.expression.staticType;
    }
    return null;
  }

  @override
  DartType visitAssertInitializer(AssertInitializer node) {
    if (range
        .endStart(node.leftParenthesis, node.message?.beginToken?.previous ?? node.rightParenthesis)
        .contains(offset)) {
      return typeProvider.boolType;
    }
    return null;
  }

  @override
  DartType visitAssertStatement(AssertStatement node) {
    if (range
        .endStart(node.leftParenthesis, node.message?.beginToken?.previous ?? node.rightParenthesis)
        .contains(offset)) {
      return typeProvider.boolType;
    }
    return null;
  }

  @override
  DartType visitAssignmentExpression(AssignmentExpression node) {
    if (node.operator.end <= offset) {
      // RHS
      if (node.operator.type == TokenType.EQ) {
        return node.leftHandSide.staticType;
      }
      var method = node.staticElement;
      if (method != null) {
        var parameters = method.parameters;
        if (parameters != null && parameters.isNotEmpty) {
          return parameters[0].type;
        }
      }
    }
    return null;
  }

  @override
  DartType visitAwaitExpression(AwaitExpression node) {
    return _visitParent(node);
  }

  @override
  DartType visitBinaryExpression(BinaryExpression node) {
    if (node.operator.end <= offset) {
      return node.rightOperand.staticParameterElement?.type;
    }
    return _visitParent(node);
  }

  @override
  DartType visitCascadeExpression(CascadeExpression node) {
    if (node.target != null && offset == node.target.offset) {
      return _visitParent(node);
    }
    return null;
  }

  @override
  DartType visitConditionalExpression(ConditionalExpression node) {
    if (offset <= node.question.offset) {
      return typeProvider.boolType;
    } else {
      return _visitParent(node);
    }
  }

  @override
  DartType visitConstructorFieldInitializer(ConstructorFieldInitializer node) {
    if (node.equals != null && node.equals.end <= offset) {
      var element = node.fieldName.staticElement;
      if (element is FieldElement) {
        return element.type;
      }
    }
    return null;
  }

  @override
  DartType visitDefaultFormalParameter(DefaultFormalParameter node) {
    if (node.separator != null && node.separator.end <= offset) {
      return node.parameter.declaredElement.type;
    }
    return null;
  }

  @override
  DartType visitDoStatement(DoStatement node) {
    if (range.endStart(node.leftParenthesis, node.rightParenthesis).contains(offset)) {
      return typeProvider.boolType;
    }
    return null;
  }

  @override
  DartType visitExpressionFunctionBody(ExpressionFunctionBody node) {
    if (range.endEnd(node.functionDefinition, node).contains(offset)) {
      var parent = node.parent;
      if (parent is MethodDeclaration) {
        return BodyInferenceContext.of(parent.body).contextType;
      } else if (parent is FunctionExpression) {
        var grandparent = parent.parent;
        if (grandparent is FunctionDeclaration) {
          return BodyInferenceContext.of(parent.body).contextType;
        }
        return _visitParent(parent);
      }
    }
    return null;
  }

  @override
  DartType visitFieldDeclaration(FieldDeclaration node) {
    if (node.fields != null && node.fields.contains(offset)) {
      return node.fields.accept(this);
    }
    return null;
  }

  @override
  DartType visitForEachPartsWithDeclaration(ForEachPartsWithDeclaration node) {
    if (range.startOffsetEndOffset(node.inKeyword.end, node.end).contains(offset)) {
      var parent = node.parent;
      if ((parent is ForStatement && parent.awaitKeyword != null) ||
          (parent is ForElement && parent.awaitKeyword != null)) {
        return typeProvider.streamDynamicType;
      }
      return typeProvider.iterableDynamicType;
    }
    return null;
  }

  @override
  DartType visitForEachPartsWithIdentifier(ForEachPartsWithIdentifier node) {
    if (range.endEnd(node.inKeyword, node).contains(offset)) {
      var parent = node.parent;
      if ((parent is ForStatement && parent.awaitKeyword != null) ||
          (parent is ForElement && parent.awaitKeyword != null)) {
        return typeProvider.streamDynamicType;
      }
      return typeProvider.iterableDynamicType;
    }
    return null;
  }

  @override
  DartType visitForPartsWithDeclarations(ForPartsWithDeclarations node) {
    if (node.leftSeparator != null &&
        node.rightSeparator != null &&
        range.endStart(node.leftSeparator, node.rightSeparator).contains(offset)) {
      return typeProvider.boolType;
    }
    return null;
  }

  @override
  DartType visitForPartsWithExpression(ForPartsWithExpression node) {
    if (node.leftSeparator != null &&
        node.rightSeparator != null &&
        range.endStart(node.leftSeparator, node.rightSeparator).contains(offset)) {
      return typeProvider.boolType;
    }
    return null;
  }

  @override
  DartType visitFunctionExpressionInvocation(FunctionExpressionInvocation node) {
    if (node.function.contains(offset)) {
      return _visitParent(node);
    }
    return null;
  }

  @override
  DartType visitIfElement(IfElement node) {
    if (range.endStart(node.leftParenthesis, node.rightParenthesis).contains(offset)) {
      return typeProvider.boolType;
    }
    return null;
  }

  @override
  DartType visitIfStatement(IfStatement node) {
    if (range.endStart(node.leftParenthesis, node.rightParenthesis).contains(offset)) {
      return typeProvider.boolType;
    }
    return null;
  }

  @override
  DartType visitIndexExpression(IndexExpression node) {
    if (range.endStart(node.leftBracket, node.rightBracket).contains(offset)) {
      var parameters = node.staticElement?.parameters;
      if (parameters != null && parameters.isNotEmpty) {
        return parameters[0].type;
      }
    }
    return null;
  }

  @override
  DartType visitIsExpression(IsExpression node) {
    if (node.isOperator.end < offset) {
      return node.expression.staticType;
    }
    return null;
  }

  @override
  DartType visitLabel(Label node) {
    if (node.colon.end <= offset) {
      return _visitParent(node);
    }
    return null;
  }

  @override
  DartType visitListLiteral(ListLiteral node) {
    if (range.endStart(node.leftBracket, node.rightBracket).contains(offset)) {
      return (node.staticType as InterfaceType).typeArguments[0];
    }
    return null;
  }

  @override
  DartType visitMapLiteralEntry(MapLiteralEntry node) {
    var literal = node.thisOrAncestorOfType<SetOrMapLiteral>();
    if (literal != null && literal.staticType.isDartCoreMap) {
      var typeArguments = (literal.staticType as InterfaceType).typeArguments;
      if (offset <= node.separator.offset) {
        return typeArguments[0];
      } else {
        return typeArguments[1];
      }
    }
    return null;
  }

  @override
  DartType visitMethodInvocation(MethodInvocation node) {
    if (offset == node.offset) {
      return _visitParent(node);
    }
    return null;
  }

  @override
  DartType visitNamedExpression(NamedExpression node) {
    if (node.name.end <= offset) {
      return _visitParent(node);
    }
    return null;
  }

  @override
  DartType visitParenthesizedExpression(ParenthesizedExpression node) {
    return _visitParent(node);
  }

  @override
  DartType visitPostfixExpression(PostfixExpression node) {
    return node.operand.staticParameterElement?.type;
  }

  @override
  DartType visitPrefixedIdentifier(PrefixedIdentifier node) {
    return _visitParent(node);
  }

  @override
  DartType visitPrefixExpression(PrefixExpression node) {
    return node.operand.staticParameterElement?.type;
  }

  @override
  DartType visitPropertyAccess(PropertyAccess node) {
    return _visitParent(node);
  }

  @override
  DartType visitReturnStatement(ReturnStatement node) {
    if (node.returnKeyword.end < offset) {
      var functionBody = node.thisOrAncestorOfType<FunctionBody>();
      if (functionBody != null) {
        return BodyInferenceContext.of(functionBody).contextType;
      }
    }
    return null;
  }

  @override
  DartType visitSetOrMapLiteral(SetOrMapLiteral node) {
    var type = node.staticType;
    if (range.endStart(node.leftBracket, node.rightBracket).contains(offset) &&
        (type.isDartCoreMap || type.isDartCoreSet)) {
      return (type as InterfaceType).typeArguments[0];
    }
    return null;
  }

  @override
  DartType visitSimpleIdentifier(SimpleIdentifier node) {
    return _visitParent(node);
  }

  @override
  DartType visitSimpleStringLiteral(SimpleStringLiteral node) {
    // The only completion inside of a String literal would be a directive,
    // where the context type would not be of value.
    return null;
  }

  @override
  DartType visitSpreadElement(SpreadElement node) {
    if (node.spreadOperator.end <= offset) {
      var currentNode = node.parent;
      while (currentNode != null) {
        if (currentNode is ListLiteral) {
          return typeProvider.iterableDynamicType;
        } else if (currentNode is SetOrMapLiteral) {
          if (currentNode.isSet) {
            return typeProvider.iterableDynamicType;
          }
          return typeProvider.mapType2(typeProvider.dynamicType, typeProvider.dynamicType);
        }
        currentNode = currentNode.parent;
      }
    }
    return null;
  }

  @override
  DartType visitSwitchCase(SwitchCase node) {
    if (range.endStart(node.keyword, node.colon).contains(offset)) {
      var parent = node.parent;
      if (parent is SwitchStatement) {
        return parent.expression?.staticType;
      }
    }
    return super.visitSwitchCase(node);
  }

  @override
  DartType visitTopLevelVariableDeclaration(TopLevelVariableDeclaration node) {
    if (node.variables != null && node.variables.contains(offset)) {
      return node.variables.accept(this);
    }
    return null;
  }

  @override
  DartType visitVariableDeclaration(VariableDeclaration node) {
    if (node.equals != null && node.equals.end <= offset) {
      var parent = node.parent;
      if (parent is VariableDeclarationList) {
        return parent.type?.type ?? impliedDartTypeWithName(typeProvider, node.name?.name);
      }
    }
    return null;
  }

  @override
  DartType visitVariableDeclarationList(VariableDeclarationList node) {
    for (var varDecl in node.variables) {
      if (varDecl != null && varDecl.contains(offset)) {
        var equals = varDecl.equals;
        if (equals != null && equals.end <= offset) {
          return node.type?.type ?? impliedDartTypeWithName(typeProvider, varDecl.name?.name);
        }
      }
    }
    return null;
  }

  @override
  DartType visitWhileStatement(WhileStatement node) {
    if (range.endStart(node.leftParenthesis, node.rightParenthesis).contains(offset)) {
      return typeProvider.boolType;
    }
    return null;
  }

  @override
  DartType visitYieldStatement(YieldStatement node) {
    if (range.endStart(node.yieldKeyword, node.semicolon).contains(offset)) {
      var functionBody = node.thisOrAncestorOfType<FunctionBody>();
      if (functionBody != null) {
        return BodyInferenceContext.of(functionBody).contextType;
      }
    }
    return null;
  }

  /// Return the result of visiting the parent of the [node] after setting the
  /// [childNode] to the [node]. Note that this method is destructive in that it
  /// does not reset the [childNode] before returning.
  DartType _visitParent(AstNode node) {
    var parent = node.parent;
    if (parent == null) {
      return null;
    }
    return parent.accept(this);
  }
}

/// Some useful extensions on [AstNode] for this computer.
extension AstNodeFeatureComputerExtension on AstNode {
  bool contains(int o) => offset <= o && o <= end;

  /// Return the [FunctionType], if there is one, for this [AstNode].
  FunctionType get functionType {
    if (parent is MethodInvocation) {
      var type = (parent as MethodInvocation).staticInvokeType;
      if (type is FunctionType) {
        return type;
      }
    } else if (parent is FunctionExpressionInvocation) {
      var type = (parent as FunctionExpressionInvocation).staticInvokeType;
      if (type is FunctionType) {
        return type;
      }
    }
    return null;
  }
}