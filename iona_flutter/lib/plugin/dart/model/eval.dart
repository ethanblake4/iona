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

  KnownFunction lookupResolved(String resolved) {
    return knownTypeMap[resolved];
  }
}

abstract class DartEvalType {
  dynamic get value;
}

class DartEvalTypeGeneric implements DartEvalType {
  final dynamic value;

  DartEvalTypeGeneric(this.value);
}

class DartEvalTypeString implements DartEvalType {
  final String value;

  DartEvalTypeString(this.value);
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
