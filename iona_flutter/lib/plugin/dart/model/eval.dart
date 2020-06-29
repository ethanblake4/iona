import 'package:iona_flutter/plugin/dart/model/known_types.dart';

typedef DartEvalType KnownFunction(List<dynamic> resolvedPositionalArgs, Map<String, dynamic> resolvedNamedArgs);

class DartScope {
  final DartScope parent;
  final Map<String, DartEvalType> scopeDefines = {};

  DartScope(this.parent) {
    if (knownTypeMap == null) {
      buildTypeMap();
    }
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

abstract class DartEvalType {
  dynamic get value;
}

class DartEvalKnownMap implements DartEvalType {
  final Map value;

  DartEvalKnownMap(this.value);
}

class DartEvalTypeGeneric implements DartEvalType {
  final dynamic value;

  DartEvalTypeGeneric(this.value);
}

class DartEvalTypeString implements DartEvalType {
  final String value;

  DartEvalTypeString(this.value);
}

class DartEvalTypeInt implements DartEvalType {
  final int value;

  DartEvalTypeInt(this.value);
}

class DartEvalTypeDouble implements DartEvalType {
  final double value;

  DartEvalTypeDouble(this.value);
}

class DartEvalTypeList implements DartEvalType {
  final List value;

  DartEvalTypeList(this.value);
}

class DartEvalReturn implements DartEvalType {
  final DartEvalType returnValue;
  dynamic get value => returnValue;

  DartEvalReturn(this.returnValue);
}
