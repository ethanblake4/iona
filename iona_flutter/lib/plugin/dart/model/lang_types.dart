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
    });
    return scope.lookupResolved(constructorLocation)(
        positionalParameters.map((e) => e.eval(scope).value).toList(), resolvedNamedParams);
  }
}

class DartSimpleStringLiteral extends DartExpression {
  final String value;

  DartSimpleStringLiteral(int offset, {this.value}) : super(offset);

  @override
  DartEvalType eval(DartScope scope) {
    return DartEvalTypeString(value);
  }
}

class DartListLiteral extends DartExpression {
  final List<DartExpression> value;

  DartListLiteral(int offset, {this.value}) : super(offset);

  @override
  DartEvalType eval(DartScope scope) {
    return DartEvalTypeList(value.map((e) => e.eval(scope).value).toList());
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
