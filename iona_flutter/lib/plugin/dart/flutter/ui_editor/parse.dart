import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:iona_flutter/plugin/dart/model/lang_types.dart';

DartClass parseClass(ClassDeclaration cls) {
  final declarations = <DartDeclaration>[];
  for (final member in cls.members) {
    if (member is MethodDeclaration) {
      declarations.add(parseMethodDeclaration(member));
    } else if (member is FieldDeclaration) {
      declarations.add(parseFieldDeclaration(member));
    } else if (member is ConstructorDeclaration) {
      //member.parameters.parameters
    }
  }
  return DartClass(cls.offset, cls.length,
      classElements: declarations,
      clsExtends: cls.extendsClause?.superclass?.name?.name,
      clsImplements: cls.implementsClause?.interfaces?.map((e) => e.name.name));
}

DartConstructorDeclaration parseConstructorDeclaration(ConstructorDeclaration constructor) {
  return DartConstructorDeclaration(constructor.offset, constructor.length,
      name: constructor.name.name, params: constructor.parameters.parameterElements.map(parseParameter));
}

DartMethodDeclaration parseMethodDeclaration(MethodDeclaration method) {
  return DartMethodDeclaration(method.offset, method.length,
      name: method.name.name,
      params: method.parameters.parameterElements.map(parseParameter).toList(),
      body: parseFnBody(method.body));
}

DartFieldDeclaration parseFieldDeclaration(FieldDeclaration field) {
  return DartFieldDeclaration(field.offset, field.length,
      fieldList: field.fields.variables.map(parseVariableDeclaration).toList());
}

DartVariableDeclaration parseVariableDeclaration(VariableDeclaration vari) {
  final initializer = parseExpression(vari.initializer);
  return DartVariableDeclaration(vari.offset, vari.length,
      initializer: initializer,
      name: vari.name.name,
      isConst: vari.isConst,
      isFinal: vari.isFinal,
      isLate: vari.isLate);
}

DartFunctionBody parseFnBody(FunctionBody body) {
  final realBody = body.childEntities.first;
  if (realBody is Block) return DartFunctionBody(body.offset, body.length, child: parseBlock(realBody));
  return DartFunctionBody(body.offset, body.length);
}

DartBlock parseBlock(Block block) {
  final outStatements = <DartExecutableNode>[];
  block.statements.forEach((element) {
    if (element is ExpressionStatement) {
      //print(element.expression.staticParameterElement);
      element.expression.childEntities.forEach((element) {
        //print(elemen.);
      });
      //print();
      print(element.toSource());
    } else if (element is ReturnStatement) {
      outStatements.add(parseReturn(element));
    }
  });
  return DartBlock(block.offset, block.length, statements: outStatements);
}

DartReturn parseReturn(ReturnStatement exprn) {
  //print(exprn.expression.runtimeType);
  return DartReturn(exprn.offset, exprn.length, expression: parseExpression(exprn.expression));
}

DartExpression parseExpression(Expression expression) {
  if (expression is InstanceCreationExpression) {
    final positionalParameters = <DartExpression>[];
    final namedParameters = <String, DartNamedExpression>{};
    final possiblePositional = <DartPossibleParameter>[];
    final possibleNamed = <String, DartPossibleParameter>{};
    for (final param in expression.constructorName.staticElement.parameters) {
      List<DartEnumValue> enumValues;
      if (param.type.element.kind == ElementKind.ENUM) {
        enumValues = [];
        (param.type.element as ClassElement).fields.forEach((element) {
          if (element.name != 'index' && element.name != 'values') {
            enumValues.add(DartEnumValue(element.name, element.documentationComment));
          }
        });
      }

      if (param.isNamed) {
        possibleNamed[param.name] =
            DartPossibleParameter(path: param.type.element.location.encoding, enumValues: enumValues);
      }
      possiblePositional.add(DartPossibleParameter(path: param.type.element.location.encoding, enumValues: enumValues));
    }

    for (final element in expression.argumentList.arguments) {
      if (element is NamedExpression) {
        namedParameters[element.name.label.name] = DartNamedExpression(element.offset, element.length,
            name: element.name.label.name, expression: parseExpression(element.expression));
      } else if (element is Expression) {
        positionalParameters.add(parseExpression(element));
      }
    }

    return DartInstanceCreationExpression(expression.offset, expression.length,
        constructorLocation: expression.constructorName.staticElement.location.encoding,
        possibleNamed: possibleNamed,
        possiblePositional: possiblePositional,
        positionalParameters: positionalParameters,
        namedParameters: namedParameters);
  } else if (expression is FunctionExpression) {
    return DartFunctionExpression(expression.offset, expression.length);
  } else if (expression is IndexExpression) {
    return DartIndexExpression(expression.offset, expression.length,
        target: parseExpression(expression.target), indexer: parseExpression(expression.index));
  } else if (expression is Identifier) {
    return parseIdentifier(expression);
  } else if (expression is Literal) {
    return parseLiteral(expression);
  } else if (expression is PropertyAccess) {
    return parsePropertyAccess(expression);
  } else if (expression is MethodInvocation) {
    return parseMethodInvocation(expression);
  } else {
    print("parse expression: no ${expression.runtimeType} ${expression}");
  }
  ;
  return null;
}

DartMethodInvocation parseMethodInvocation(MethodInvocation invocation) {
  final parameters = <DartExpression>[];
  for (final element in invocation.argumentList.arguments) {
    if (element is NamedExpression) {
      parameters.add(DartNamedExpression(element.offset, element.length,
          name: element.name.label.name, expression: parseExpression(element.expression)));
    } else if (element is Expression) {
      parameters.add(parseExpression(element));
    }
  }
  return DartMethodInvocation(invocation.offset, invocation.length,
      target: parseExpression(invocation.target), name: invocation.methodName.name, arguments: parameters);
}

DartPropertyAccessExpression parsePropertyAccess(PropertyAccess propertyAccess) {
  return DartPropertyAccessExpression(propertyAccess.offset, propertyAccess.length,
      target: parseExpression(propertyAccess.target), name: propertyAccess.propertyName.name);
}

DartLiteral parseLiteral(Literal literal) {
  if (literal is SimpleStringLiteral) {
    return DartSimpleStringLiteral(literal.offset, literal.length, value: literal.value);
  } else if (literal is ListLiteral) {
    return DartListLiteral(literal.offset, literal.length,
        value: literal.elements.where((element) => element is Expression).map((e) => parseExpression(e)).toList());
  } else if (literal is IntegerLiteral) {
    return DartIntegerLiteral(literal.offset, literal.length, value: literal.value);
  } else if (literal is DoubleLiteral) {
    return DartDoubleLiteral(literal.offset, literal.length, value: literal.value);
  } else if (literal is StringInterpolation) {
    return parseStringInterpolation(literal);
  }
}

DartStringInterpolation parseStringInterpolation(StringInterpolation interpolation) {
  final elements = <DartExpression>[];
  for (final el in interpolation.elements) {
    if (el is InterpolationExpression) {
      elements.add(parseExpression(el.expression));
    } else if (el is InterpolationString) {
      elements.add(DartSimpleStringLiteral(el.offset, el.length, value: el.value));
    }
  }
  return DartStringInterpolation(interpolation.offset, interpolation.length, elements: elements);
}

DartIdentifier parseIdentifier(Identifier identifier) {
  if (identifier is SimpleIdentifier) {
    return DartSimpleIdentifier(identifier.offset, identifier.length,
        name: identifier.name, location: identifier.staticElement.location.encoding);
  } else if (identifier is PrefixedIdentifier) {
    return DartPrefixedIdentifier(identifier.offset, identifier.length,
        prefix: parseIdentifier(identifier.prefix),
        location: identifier.staticElement.location.encoding,
        name: identifier.identifier.name);
  }
  return null;
}

DartParameter parseParameter(ParameterElement param) {
  final typeEl = param.type.element;
  return DartParameter(param.nameOffset, param.nameLength,
      paramName: param.name,
      isNamed: param.isNamed,
      isOptional: param.isOptional,
      type: DartLnType(typeEl.nameOffset, typeEl.nameLength,
          typeName: typeEl.name, library: typeEl.library.location.toString()));
}
