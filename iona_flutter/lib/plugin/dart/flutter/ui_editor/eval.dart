import 'package:iona_flutter/plugin/dart/flutter/ui_editor/known_types.dart';
import 'package:iona_flutter/plugin/dart/model/lang_types.dart';
import 'package:iona_flutter/plugin/dart/model/lang_types/errors.dart';

typedef KnownFunction = DartEvalType Function(
    DartSourceNode node, List<dynamic> resolvedPositionalArgs, Map<String, dynamic> resolvedNamedArgs);

typedef FnWrapper<T> = DartEvalType<T> Function(T);

class DartScope {
  final DartScope parent;
  final Map<String, DartEvalType> scopeDefines = {};

  DartScope(this.parent) {
    if (knownTypeMap == null) {
      buildTypeMap();
    }
  }

  void set(String name, DartEvalType value) {
    scopeDefines[name] = value;
  }

  DartEvalType lookup(String name) {
    return scopeDefines[name] ?? parent?.lookup(name);
  }

  DartEvalType lookupResolvedStatic(String resolved) {
    return knownStaticTypeMap[resolved];
  }

  KnownFunction lookupResolved(String resolved) {
    return knownTypeMap[resolved];
  }
}

class DeclarationContext {
  const DeclarationContext(this.cls, this.unresolved, this.resolved);

  final DartClass cls;
  final Map<String, DartDeclaration> unresolved;
  final Map<String, DartEvalType> resolved;
}

abstract class DartEvalType<T> {
  T get value;

  DartEvalType getField(String name);

  void setField(String name, DartEvalType value);

  DartEvalCallable getMethod(String name);
}

class DartEvalTypeGeneric<T> implements DartEvalType<T> {
  const DartEvalTypeGeneric(this.value, {this.fields, this.methods});

  @override
  final T value;

  @override
  final Map<String, DartEvalType> fields;

  @override
  final Map<String, DartEvalCallable> methods;

  @override
  DartEvalType getField(String name) {
    if (fields == null) return null;
    return fields[name];
  }

  @override
  void setField(String name, DartEvalType value) {
    fields[name] = value;
  }

  @override
  DartEvalCallable getMethod(String name) {
    if (methods == null) return null;
    return methods[name];
  }
}

class DartEvalTypeStaticMap<T1> extends DartEvalTypeType {
  DartEvalTypeStaticMap(Type value, {this.fields, this.wrapper}) : super(value);

  Map<String, T1> fields;
  FnWrapper<T1> wrapper;

  @override
  DartEvalType<T1> getField(String name) {
    return wrapper(fields[name]);
  }
}

class DartEvalTypeEnum<T1> extends DartEvalTypeType {
  const DartEvalTypeEnum(Type value, {this.fields, this.wrapper}) : super(value);

  final Map<String, T1> fields;
  final FnWrapper<T1> wrapper;

  @override
  DartEvalType getField(String name) {
    if (name == 'values') return DartEvalTypeList<T1>(fields.values.map((v) => wrapper(v)).toList());
    return wrapper(fields[name]);
  }
}

abstract class DartEvalCallable<T> extends DartEvalTypeGeneric<T> {
  const DartEvalCallable(T value, {this.params, this.namedParams, Map<String, DartEvalType> fields})
      : super(value, fields: fields);

  final List<DartParameter> params;
  final Map<String, DartParameter> namedParams;

  DartEvalType call(DartScope scope, List<DartExpression> expressions);
}

class DartEvalCallableImpl<T> extends DartEvalTypeGeneric<T> implements DartEvalCallable<T> {
  const DartEvalCallableImpl(T value, this._exec, {this.params, this.namedParams, Map<String, DartEvalType> fields})
      : super(value, fields: fields);

  final DartExecutableNode _exec;
  final List<DartParameter> params;
  final Map<String, DartParameter> namedParams;

  DartEvalType call(DartScope scope, List<DartExpression> expressions) {
    final callScope = DartScope(scope);
    for (var i = 0; i < expressions.length; i++) {
      final expr = expressions[i];
      if (expr is DartNamedExpression) {
        if (!namedParams.containsKey(expr.name)) {
          throw ArgumentError('Invalid argument ${expr.name}');
        }
        callScope.set(expr.name, expr.eval(scope));
      } else {
        callScope.set(params[i].paramName, expr.eval(scope));
      }
    }
    return _exec.eval(callScope);
  }

  @override
  DartEvalCallable getMethod(String name) {
    // no methods on base class
  }
}

typedef _GenericCall<T> = DartEvalType<T> Function(
    List<DartEvalType> positionalArgs, Map<String, DartEvalType> namedArgs);

class DartInternalCallable<T> extends DartEvalTypeGeneric<T> implements DartEvalCallable<T> {
  const DartInternalCallable(T value, this._exec, {this.params, this.namedParams, Map<String, DartEvalType> fields})
      : super(value, fields: fields);

  final _GenericCall _exec;
  final List<DartParameter> params;
  final Map<String, DartParameter> namedParams;

  DartEvalType call(DartScope scope, List<DartExpression> expressions) {
    final positional = <DartEvalType>[];
    final named = <String, DartEvalType>{};
    for (var i = 0; i < expressions.length; i++) {
      final expr = expressions[i];
      if (expr is DartNamedExpression) {
        if (!namedParams.containsKey(expr.name)) {
          throw ArgumentError('Invalid argument ${expr.name}');
        }
        named[expr.name] = expr.eval(scope);
      } else {
        final ev = expr.eval(scope);
        positional.add(ev);
      }
    }
    return _exec(positional, named);
  }

  @override
  DartEvalCallable getMethod(String name) {
    // no methods on base class
  }
}

class DartEvalTypeString extends DartEvalTypeObject<String> {
  const DartEvalTypeString(this.value) : super(value);

  @override
  final String value;

  @override
  DartEvalType getField(String name) {
    switch (name) {
      case 'length':
        return DartEvalTypeInt(value.length);
        break;
      case 'isEmpty':
        return DartEvalTypeBool(value.isEmpty);
        break;
      case 'isNotEmpty':
        return DartEvalTypeBool(value.isNotEmpty);
        break;
    }
  }

  @override
  DartEvalCallable getMethod(String name) {
    switch (name) {
      case 'substring':
        return DartInternalCallable(
            value.substring,
            (positionalArgs, namedArgs) => DartEvalTypeString(
                value.substring(positionalArgs[0].value, positionalArgs.length > 1 ? positionalArgs[1].value : null)),
            params: [DartParameter.forEval('startIndex'), DartParameter.forEval('endIndex', isOptional: true)]);
        break;
    }
  }
}

class DartEvalTypeObject<T extends Object> implements DartEvalType<T> {
  const DartEvalTypeObject(this.value);

  @override
  final T value;

  @override
  DartEvalType getField(String name) {
    switch (name) {
      case 'hashCode':
        return DartEvalTypeInt(value.hashCode);
        break;
      case 'runtimeType':
        return DartEvalTypeType(value.runtimeType);
        break;
    }
  }

  @override
  void setField(String name, DartEvalType value) {
    // no settable fields
  }

  @override
  DartEvalCallable getMethod(String name) {
    switch (name) {
      case 'toString':
        return DartInternalCallable(value.toString, (positionalArgs, namedArgs) => DartEvalTypeString(toString()),
            params: [], namedParams: {});
    }
    return DartInternalCallable(
        null,
        // ignore: only_throw_errors
        (positionalArgs, namedArgs) => throw DartEvalTypeNoSuchMethodError(NoSuchMethodError.withInvocation(
            value, Invocation.method(Symbol(name), positionalArgs.map((i) => i.value)))));
  }
}

class DartEvalTypeNull extends DartEvalTypeObject<Null> {
  const DartEvalTypeNull() : super(null);
}

class DartEvalTypeType<T extends Type> extends DartEvalTypeObject<T> {
  const DartEvalTypeType(this.value) : super(value);

  @override
  final T value;
}

class DartEvalTypeNum<T extends num> extends DartEvalTypeObject<T> {
  const DartEvalTypeNum(num value) : super(value);

  @override
  DartEvalType getField(String name) {
    switch (name) {
      case 'sign':
        return DartEvalTypeNum(value.sign);
        break;
      default:
        return super.getField(name);
    }
  }

  @override
  void setField(String name, DartEvalType value) {
    // no settable fields
  }
}

class DartEvalTypeBool extends DartEvalTypeObject<bool> {
  // ignore: avoid_positional_boolean_parameters
  const DartEvalTypeBool(bool value) : super(value);
}

class DartEvalTypeInt<T extends int> extends DartEvalTypeNum<T> {
  const DartEvalTypeInt(int value) : super(value);

  @override
  DartEvalType getField(String name) {
    //value.
    switch (name) {
      case 'sign':
        return DartEvalTypeInt(value.sign);
        break;
      default:
        return super.getField(name);
    }
  }
}

class DartEvalTypeDouble<T extends double> extends DartEvalTypeNum<T> {
  const DartEvalTypeDouble(double value) : super(value);

  @override
  DartEvalType getField(String name) {
    //value.
    switch (name) {
      case 'sign':
        return DartEvalTypeDouble(value.sign);
        break;
      default:
        return super.getField(name);
    }
  }

  @override
  DartEvalCallable getMethod(String name) {
    switch (name) {
      default:
        return super.getMethod(name);
    }
  }
}

class DartEvalTypeList<R> extends DartEvalTypeObject<List<DartEvalType<R>>> {
  const DartEvalTypeList(List<DartEvalType<R>> value) : super(value);

  @override
  DartEvalType getField(String name) {
    switch (name) {
      case 'length':
        return DartEvalTypeInt(value.length);
        break;
      case 'isEmpty':
        return DartEvalTypeBool(value.isEmpty);
        break;
      case 'isNotEmpty':
        return DartEvalTypeBool(value.isNotEmpty);
        break;
      default:
        return super.getField(name);
    }
  }

  @override
  DartEvalCallable getMethod(String name) {
    switch (name) {
      default:
        return super.getMethod(name);
    }
  }
}

class DartEvalReturn<T extends DartEvalType> implements DartEvalType<T> {
  const DartEvalReturn(this.value);

  @override
  final T value;

  @override
  DartEvalType getField(String name) {
    throw UnimplementedError();
  }

  @override
  DartEvalCallable getMethod(String name) {
    throw UnimplementedError();
  }

  @override
  void setField(String name, DartEvalType value) {
    throw UnimplementedError();
  }
}
