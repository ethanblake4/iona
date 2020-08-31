// ignore_for_file: public_member_api_docs
import 'package:collection/collection.dart';
import 'package:iona_flutter/plugin/dart/flutter/ui_editor/eval.dart';
import 'package:iona_flutter/plugin/dart/flutter/ui_editor/known_paths.dart';

/// Represents a node in Dart source code
abstract class DartSourceNode {
  final int offset;
  final int length;

  const DartSourceNode(this.offset, this.length);
}

abstract class DartExecutableNode implements DartSourceNode {
  DartEvalType eval(DartScope scope);
}

abstract class DartUnitMember implements DartSourceNode {}

abstract class DartDeclaration extends DartSourceNode {
  const DartDeclaration(int offset, int length, {this.name}) : super(offset, length);

  final String name;

  void declare(DeclarationContext ctx);
}

class DartClass extends DartSourceNode implements DartUnitMember {
  const DartClass(int offset, int length, {this.classElements, this.clsExtends, this.clsImplements, this.clsWith})
      : super(offset, length);

  final List<DartDeclaration> classElements;
  final String clsExtends;
  final List<String> clsImplements;
  final List<String> clsWith;
}

class DartMethodDeclaration extends DartDeclaration {
  /// Construct a DartFunction
  const DartMethodDeclaration(int offset, int length, {String name, this.params, this.body})
      : super(offset, length, name: name);

  final List<DartParameter> params;
  final DartFunctionBody body;

  @override
  String toString() {
    return 'Fn{name: $name, params: $params, body: $body}';
  }

  void declare(DeclarationContext ctx) {
    final positional = <DartParameter>[];
    final named = <String, DartParameter>{};
    for (var i = 0; i < params.length; i++) {
      final param = params[i];
      if (param.isNamed) {
        named[param.paramName] = param;
      } else {
        positional.add(param);
      }
    }
    final callable = DartEvalCallableImpl(null, body.child, params: positional, namedParams: named);
    ctx.resolved[name] = callable;
    return null;
  }
}

class DartConstructorDeclaration extends DartDeclaration {
  const DartConstructorDeclaration(int offset, int length, {String name, this.params, this.initializers})
      : super(offset, length, name: name);

  final List<DartParameter> params;
  final List<DartConstructorInitializer> initializers;

  @override
  void declare(DeclarationContext ctx) {
    ctx.resolved[name] = DartInternalCallable(null, (n, p) {
      final fields = <String, DartEvalType>{};
      final methods = <String, DartEvalCallable>{};
      for (final d in ctx.resolved.keys) {
        if (ctx.resolved[d] is DartEvalCallable) {
          methods[d] = ctx.resolved[d];
        } else {
          fields[d] = ctx.resolved[d];
        }
      }

      return DartEvalTypeGeneric(null, fields: fields, methods: methods);
    });
  }
}

abstract class DartConstructorInitializer implements DartExecutableNode {}

class ConstructorSuperInvocation extends DartSourceNode implements DartConstructorInitializer {
  ConstructorSuperInvocation(int offset, int length) : super(offset, length);

  @override
  DartEvalType eval(DartScope scope) {
    // TODO: implement eval
    throw UnimplementedError();
  }
}

class DartFieldDeclaration extends DartDeclaration {
  const DartFieldDeclaration(int offset, int length, {this.isStatic, this.fieldList}) : super(offset, length);

  final bool isStatic;
  final List<DartVariableDeclaration> fieldList;

  @override
  void declare(DeclarationContext ctx) {
    // TODO: implement declare
  }


}

class DartVariableDeclaration extends DartDeclaration {
  const DartVariableDeclaration(int offset, int length,
      {String name, this.initializer, this.isConst, this.isFinal, this.isLate, this.type})
      : super(offset, length, name: name);

  final bool isConst;
  final bool isFinal;
  final bool isLate;
  final DartLnType type;
  final DartExpression initializer;

  @override
  DartVariableDeclaration declare(DeclarationContext ctx) {
    //scope.set(name, initializer.eval(scope));
  }
}

class DartFunctionBody extends DartSourceNode {
  /// Create function body
  const DartFunctionBody(int offset, int length, {this.child}) : super(offset, length);

  final DartExecutableNode child;

  @override
  String toString() {
    return 'fb>$child';
  }
}

class DartBlock extends DartSourceNode implements DartExecutableNode {
  const DartBlock(int offset, int length, {this.statements}) : super(offset, length);

  final List<DartExecutableNode> statements;

  @override
  String toString() {
    return 'Block{$statements}';
  }

  @override
  DartEvalType eval(DartScope scope) {
    final blockScope = DartScope(scope);
    for (final statement in statements) {
      final result = statement.eval(blockScope);
      if (result is DartEvalReturn) {
        return result.value;
      }
    }
  }
}

class DartReturn extends DartSourceNode implements DartExecutableNode {
  const DartReturn(int offset, int length, {this.expression}) : super(offset, length);

  final DartExpression expression;

  @override
  String toString() {
    return 'Return{$expression}';
  }

  @override
  DartEvalType eval(DartScope scope) {
    return DartEvalReturn(expression.eval(scope));
  }
}

abstract class DartExpression extends DartSourceNode implements DartExecutableNode {
  const DartExpression(int offset, int length) : super(offset, length);
}

class DartInjectedExpression extends DartExpression {
  const DartInjectedExpression(int offset, int length, {this.inject}) : super(offset, length);

  final DartEvalType Function(DartScope scope) inject;

  @override
  DartEvalType eval(DartScope scope) {
    return inject(scope);
  }
}

class DartInstanceCreationExpression extends DartExpression {
  const DartInstanceCreationExpression(int offset, int length,
      {this.constructorLocation,
      this.positionalParameters,
      this.namedParameters,
      this.possiblePositional,
      this.possibleNamed})
      : super(offset, length);

  final String constructorLocation;
  final List<DartPossibleParameter> possiblePositional;
  final Map<String, DartPossibleParameter> possibleNamed;
  final List<DartExpression> positionalParameters;
  final Map<String, DartNamedExpression> namedParameters;

  //final >

  @override
  String toString() {
    return 'InstanceCreation{constructor: $constructorLocation, ps: $positionalParameters, nm: $namedParameters}';
  }

  @override
  DartEvalType eval(DartScope scope) {
    final resolvedNamedParams = <String, dynamic>{};
    namedParameters.forEach((key, value) {
      resolvedNamedParams[key] = value.eval(scope).value;
      //print(key);
      //print(value);
      //print('key: ${resolvedNamedParams[key]}');
    });
    //print(this);
    print(this);
    return scope.lookupResolved(constructorLocation)(
        this, positionalParameters.map((e) => e.eval(scope).value).toList(), resolvedNamedParams);
  }

  bool equalIdentifiers(DartInstanceCreationExpression other) {
    var i = 0;
    if (offset != other.offset) return false;
    for (final key in namedParameters.keys) {
      if (!other.namedParameters.containsKey(key)) {
        return false;
      }
      final ok = other.namedParameters[key].expression;
      final k = namedParameters[key].expression;
      // Enums
      if (ok is DartPrefixedIdentifier && ok != k) {
        return false;
      }

      // Colors
      if (ok is DartInstanceCreationExpression && k is DartInstanceCreationExpression) {
        if (ok.constructorLocation.startsWith(fluiColor) && k.constructorLocation.startsWith(fluiColor)) {
          print('colors ${k.positionalParameters} ${ok.positionalParameters}');
          if (k.positionalParameters.isNotEmpty && ok.positionalParameters.isNotEmpty) {
            if (!ListEquality().equals(ok.positionalParameters, k.positionalParameters)) {
              print('both dice neq');
              return false;
            }
          }
        }
      }
    }

    for (final key in other.namedParameters.keys) {
      if (!namedParameters.containsKey(key)) {
        return false;
      }
      if (namedParameters[key] is DartPrefixedIdentifier && namedParameters[key] != other.namedParameters[key]) {
        return false;
      }
    }
    return true;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DartInstanceCreationExpression &&
          runtimeType == other.runtimeType &&
          constructorLocation == other.constructorLocation &&
          (ListEquality().equals(positionalParameters, other.positionalParameters));

  @override
  int get hashCode => constructorLocation.hashCode ^ positionalParameters.hashCode ^ namedParameters.hashCode;
}

class DartFunctionExpression extends DartExpression {
  DartFunctionExpression(int offset, int length) : super(offset, length);

  @override
  DartEvalType eval(DartScope scope) {
    return DartEvalTypeGeneric(() {});
  }

  @override
  String toString() {
    return 'FnEx{}';
  }
}

class DartNamedExpression extends DartExpression {
  DartNamedExpression(int offset, int length, {this.name, this.expression}) : super(offset, length);

  String name;
  DartExpression expression;

  @override
  DartEvalType eval(DartScope scope) {
    return expression.eval(scope);
  }

  @override
  String toString() {
    return 'nex{name: $name, expression: $expression}';
  }
}

class DartIndexExpression extends DartExpression {
  DartIndexExpression(int offset, int length, {this.target, this.indexer}) : super(offset, length);

  DartExpression target;
  DartExpression indexer;

  @override
  DartEvalType eval(DartScope scope) {
    return DartEvalTypeGeneric(target.eval(scope).value[indexer.eval(scope).value]);
  }

  @override
  String toString() {
    return 'idx ($target)[indexer: $indexer]';
  }
}

class DartPropertyAccessExpression extends DartExpression {
  DartPropertyAccessExpression(int offset, int length, {this.target, this.name}) : super(offset, length);

  DartExpression target;
  String name;

  @override
  DartEvalType eval(DartScope scope) {
    return target.eval(scope).getField(name);
  }

  @override
  String toString() {
    return '(pa $target.$name)';
  }
}

class DartMethodInvocation extends DartExpression {
  DartMethodInvocation(int offset, int length, {this.target, this.name, this.arguments}) : super(offset, length);

  DartExpression target;
  String name;
  List<DartExpression> arguments;

  @override
  DartEvalType eval(DartScope scope) {
    return target.eval(scope).getMethod(name).call(scope, arguments);
  }

  @override
  String toString() {
    return '(pa $target.$name)';
  }
}

abstract class DartIdentifier extends DartSourceNode implements DartExpression {
  const DartIdentifier(int offset, int length, {this.name}) : super(offset, length);

  final String name;
}

class DartSimpleIdentifier extends DartIdentifier {
  const DartSimpleIdentifier(int offset, int length, {String name, this.location}) : super(offset, length, name: name);

  final String location;

  @override
  DartEvalType eval(DartScope scope) {
    try {
      return scope.lookup(name) ?? scope.lookupResolvedStatic(location);
    } catch (e) {
      print('could not find static $name or $location');
      rethrow;
    }
  }

  @override
  String toString() {
    return 'SimpleID{$location}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DartSimpleIdentifier && runtimeType == other.runtimeType && location == other.location;

  @override
  int get hashCode => location.hashCode;
}

class DartPrefixedIdentifier extends DartIdentifier {
  const DartPrefixedIdentifier(int offset, int length, {this.prefix, this.location, String name})
      : super(offset, length, name: name);

  final DartSimpleIdentifier prefix;
  final String location;

  @override
  DartEvalType eval(DartScope scope) {
    return prefix.eval(scope).getField(name);
  }

  @override
  String toString() {
    return 'Pfx{$prefix.$name}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DartPrefixedIdentifier &&
          runtimeType == other.runtimeType &&
          prefix == other.prefix &&
          location == other.location;

  @override
  int get hashCode => prefix.hashCode ^ location.hashCode;
}

class DartEnumValue {
  const DartEnumValue(this.value, this.docComment);

  final String value;
  final String docComment;
}

class DartPossibleParameter {
  const DartPossibleParameter({this.path, this.enumValues});

  final String path;
  final List<DartEnumValue> enumValues;
}

abstract class DartLiteral extends DartSourceNode implements DartExpression {
  const DartLiteral(int offset, int length) : super(offset, length);
}

class DartSimpleStringLiteral extends DartLiteral {
  DartSimpleStringLiteral(int offset, int length, {this.value}) : super(offset, length);

  final String value;

  @override
  DartEvalType eval(DartScope scope) {
    return DartEvalTypeString(value);
  }
}

class DartStringInterpolation extends DartLiteral {
  const DartStringInterpolation(int offset, int length, {this.elements}) : super(offset, length);

  final List<DartExpression> elements;

  @override
  DartEvalType eval(DartScope scope) {
    StringBuffer sb = StringBuffer();
    for (final el in elements) {
      sb.write(el.eval(scope).value);
    }
    return DartEvalTypeString(sb.toString());
  }
}

class DartListLiteral extends DartLiteral {
  DartListLiteral(int offset, int length, {this.value}) : super(offset, length);

  final List<DartExpression> value;

  @override
  DartEvalType eval(DartScope scope) {
    return DartEvalTypeList(value.map<DartEvalType>((e) => e.eval(scope)).toList());
  }

  @override
  String toString() {
    return 'll$value';
  }
}

class DartIntegerLiteral extends DartLiteral {
  DartIntegerLiteral(int offset, int length, {this.value}) : super(offset, length);

  final int value;

  @override
  DartEvalType eval(DartScope scope) {
    return DartEvalTypeInt(value);
  }

  @override
  String toString() {
    return 'i$value';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is DartIntegerLiteral && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class DartDoubleLiteral extends DartLiteral {
  DartDoubleLiteral(int offset, int length, {this.value}) : super(offset, length);

  final double value;

  @override
  DartEvalType eval(DartScope scope) {
    return DartEvalTypeDouble(value);
  }

  @override
  String toString() {
    return 'd$value';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is DartDoubleLiteral && runtimeType == other.runtimeType && value == other.value;

  @override
  int get hashCode => value.hashCode;
}

class DartParameter extends DartSourceNode {
  const DartParameter(int offset, int length, {this.paramName, this.type, this.isOptional, this.isNamed})
      : super(offset, length);

  factory DartParameter.forEval(String name, {bool isOptional = false}) =>
      DartParameter(0, 0, paramName: name, isOptional: isOptional);

  final DartLnType type;
  final String paramName;
  final bool isNamed;
  final bool isOptional;

  @override
  String toString() {
    return '($type $paramName)';
  }
}

class DartLnType extends DartSourceNode {
  /// Create a DartType
  const DartLnType(int offset, int length, {this.typeName, this.library}) : super(offset, length);

  final String typeName;
  final String library;

  @override
  String toString() {
    return '[$library > $typeName]';
  }
}
