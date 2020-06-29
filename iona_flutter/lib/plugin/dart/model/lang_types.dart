// ignore_for_file: public_member_api_docs
import 'package:iona_flutter/plugin/dart/model/eval.dart';

/// Represents a node in Dart source code
abstract class DartSourceNode {
  final int offset;

  const DartSourceNode(this.offset);
}

abstract class DartExecutableNode implements DartSourceNode {
  DartEvalType eval(DartScope scope);
}

class DartFunction extends DartSourceNode {
  /// Construct a DartFunction
  const DartFunction(int offset, {this.name, this.params, this.body}) : super(offset);

  final String name;
  final List<DartParameter> params;
  final DartFunctionBody body;

  @override
  String toString() {
    return 'Fn{name: $name, params: $params, body: $body}';
  }
}

class DartFunctionBody extends DartSourceNode {
  /// Create function body
  const DartFunctionBody(int offset, {this.child}) : super(offset);

  final DartExecutableNode child;

  @override
  String toString() {
    return 'fb>$child';
  }
}

class DartBlock extends DartSourceNode implements DartExecutableNode {
  const DartBlock(int offset, {this.statements}) : super(offset);

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
        return result.returnValue;
      }
    }
  }
}

class DartReturn extends DartSourceNode implements DartExecutableNode {
  const DartReturn(int offset, {this.expression}) : super(offset);

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
  const DartExpression(int offset) : super(offset);
}

class DartInstanceCreationExpression extends DartExpression {
  const DartInstanceCreationExpression(int offset,
      {this.constructorLocation, this.positionalParameters, this.namedParameters})
      : super(offset);

  final String constructorLocation;
  final List<DartExpression> positionalParameters;
  final Map<String, DartExpression> namedParameters;

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
    return scope.lookupResolved(constructorLocation)(
        positionalParameters.map((e) => e.eval(scope).value).toList(), resolvedNamedParams);
  }
}

class DartFunctionExpression extends DartExpression {
  DartFunctionExpression(int offset) : super(offset);

  @override
  DartEvalType eval(DartScope scope) {
    return DartEvalTypeGeneric(() {});
  }

  @override
  String toString() {
    return 'FnEx{}';
  }
}

class DartIndexExpression extends DartExpression {
  DartIndexExpression(int offset, {this.target, this.indexer}) : super(offset);

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

abstract class DartIdentifier extends DartSourceNode implements DartExpression {
  const DartIdentifier(int offset, {this.name}) : super(offset);

  final String name;
}

class DartSimpleIdentifier extends DartIdentifier {
  const DartSimpleIdentifier(int offset, {String name, this.location}) : super(offset, name: name);

  final String location;

  @override
  DartEvalType eval(DartScope scope) {
    return scope.lookup(name) ?? scope.lookupResolvedStatic(location);
  }

  @override
  String toString() {
    return 'SimpleID{$location}';
  }
}

class DartPrefixedIdentifier extends DartIdentifier {
  const DartPrefixedIdentifier(int offset, {this.prefix, this.location, String name}) : super(offset, name: name);

  final DartSimpleIdentifier prefix;
  final String location;

  @override
  DartEvalType eval(DartScope scope) {
    final prefixRes = prefix.eval(scope);
    if (prefixRes is DartEvalKnownMap) {
      return DartEvalTypeGeneric(prefixRes.value[name]);
    } else {
      return null;
    }
  }

  @override
  String toString() {
    return 'Pfx{$prefix."$name"}';
  }
}

abstract class DartLiteral extends DartSourceNode implements DartExpression {
  const DartLiteral(int offset) : super(offset);
}

class DartSimpleStringLiteral extends DartLiteral {
  final String value;

  DartSimpleStringLiteral(int offset, {this.value}) : super(offset);

  @override
  DartEvalType eval(DartScope scope) {
    return DartEvalTypeString(value);
  }
}

class DartListLiteral extends DartLiteral {
  final List<DartExpression> value;

  DartListLiteral(int offset, {this.value}) : super(offset);

  @override
  DartEvalType eval(DartScope scope) {
    return DartEvalTypeList(value.map((e) => e.eval(scope).value).toList());
  }

  @override
  String toString() {
    return 'll$value';
  }
}

class DartIntegerLiteral extends DartLiteral {
  DartIntegerLiteral(int offset, {this.value}) : super(offset);

  final int value;

  DartEvalType eval(DartScope scope) {
    return DartEvalTypeInt(value);
  }

  @override
  String toString() {
    return 'i$value';
  }
}

class DartDoubleLiteral extends DartLiteral {
  DartDoubleLiteral(int offset, {this.value}) : super(offset);

  final double value;

  DartEvalType eval(DartScope scope) {
    return DartEvalTypeDouble(value);
  }

  @override
  String toString() {
    return 'd$value';
  }
}

class DartParameter extends DartSourceNode {
  const DartParameter(int offset, {this.paramName, this.type}) : super(offset);

  final DartLnType type;
  final String paramName;

  @override
  String toString() {
    return '($type $paramName)';
  }
}

class DartLnType extends DartSourceNode {
  /// Create a DartType
  const DartLnType(int offset, {this.typeName, this.library}) : super(offset);

  final String typeName;
  final String library;

  @override
  String toString() {
    return '[$library > $typeName]';
  }
}
