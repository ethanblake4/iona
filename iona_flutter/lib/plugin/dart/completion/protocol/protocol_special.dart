import 'dart:async';

import 'package:iona_flutter/plugin/dart/completion/protocol/protocol_generated.dart';
import 'package:iona_flutter/plugin/dart/utils/utilities_general.dart';

/// Returns an objects hash code, recursively combining hashes for items in
/// Maps/Lists.
int lspHashCode(dynamic obj) {
  var hash = 0;
  if (obj is List) {
    for (var element in obj) {
      hash = JenkinsSmiHash.combine(hash, lspHashCode(element));
    }
  } else if (obj is Map) {
    for (var key in obj.keys) {
      hash = JenkinsSmiHash.combine(hash, lspHashCode(key));
      hash = JenkinsSmiHash.combine(hash, lspHashCode(obj[key]));
    }
  } else {
    hash = obj.hashCode;
  }
  return JenkinsSmiHash.finish(hash);
}

class Either2<T1, T2> {
  final int _which;
  final T1 _t1;
  final T2 _t2;

  Either2.t1(this._t1)
      : _t2 = null,
        _which = 1;
  Either2.t2(this._t2)
      : _t1 = null,
        _which = 2;

  @override
  int get hashCode => map(lspHashCode, lspHashCode);

  @override
  bool operator ==(o) => o is Either2<T1, T2> && lspEquals(o._t1, _t1) && lspEquals(o._t2, _t2);

  T map<T>(T Function(T1) f1, T Function(T2) f2) {
    return _which == 1 ? f1(_t1) : f2(_t2);
  }

  @override
  String toString() => map((t) => t.toString(), (t) => t.toString());

  /// Checks whether the value of the union equals the supplied value.
  bool valueEquals(o) => map((t) => t == o, (t) => t == o);
}

/// Returns if two objects are equal, recursively checking items in
/// Maps/Lists.
bool lspEquals(dynamic obj1, dynamic obj2) {
  if (obj1 is List && obj2 is List) {
    return listEqual(obj1, obj2, lspEquals);
  } else if (obj1 is Map && obj2 is Map) {
    return mapEqual(obj1, obj2, lspEquals);
  } else {
    return obj1.runtimeType == obj2.runtimeType && obj1 == obj2;
  }
}

/// Compare the lists [listA] and [listB], using [itemEqual] to compare
/// list elements.
bool listEqual<T1, T2>(List<T1> listA, List<T2> listB, bool Function(T1 a, T2 b) itemEqual) {
  if (listA == null) {
    return listB == null;
  }
  if (listB == null) {
    return false;
  }
  if (listA.length != listB.length) {
    return false;
  }
  for (var i = 0; i < listA.length; i++) {
    if (!itemEqual(listA[i], listB[i])) {
      return false;
    }
  }
  return true;
}

/// Compare the maps [mapA] and [mapB], using [valueEqual] to compare map
/// values.
bool mapEqual<K, V>(Map<K, V> mapA, Map<K, V> mapB, bool Function(V a, V b) valueEqual) {
  if (mapA == null) {
    return mapB == null;
  }
  if (mapB == null) {
    return false;
  }
  if (mapA.length != mapB.length) {
    return false;
  }
  for (var key in mapA.keys) {
    if (!mapB.containsKey(key)) {
      return false;
    }
    if (!valueEqual(mapA[key], mapB[key])) {
      return false;
    }
  }
  return true;
}

class ErrorOr<T> extends Either2<ResponseError, T> {
  ErrorOr.error(ResponseError error) : super.t1(error);
  ErrorOr.success([T result]) : super.t2(result);

  /// Returns the error or throws if object is not an error. Check [isError]
  /// before accessing [error].
  ResponseError get error {
    return _which == 1 ? _t1 : (throw 'Value is not an error');
  }

  /// Returns true if this object is an error, false if it is a result. Prefer
  /// [mapResult] instead of checking this flag if [errors] will simply be
  /// propagated as-is.
  bool get isError => _which == 1;

  /// Returns the result or throws if this object is an error. Check [isError]
  /// before accessing [result]. It is valid for this to return null is the
  /// object does not represent an error but the resulting value was null.
  T get result {
    return _which == 2 ? _t2 : (throw 'Value is not a result');
  }

  /// If this object is a result, maps [result] through [f], otherwise returns
  /// a new error object representing [error].
  FutureOr<ErrorOr<N>> mapResult<N>(FutureOr<ErrorOr<N>> Function(T) f) {
    return isError
        // Re-wrap the error using our new type arg
        ? ErrorOr<N>.error(error)
        // Otherwise call the map function
        : f(result);
  }
}

ErrorOr<R> error<R>(ErrorCodes code, String message, [String data]) =>
    ErrorOr<R>.error(ResponseError(code, message, data));

ErrorOr<R> success<R>([R t]) => ErrorOr<R>.success(t);

ErrorOr<R> cancelled<R>([R t]) => error(ErrorCodes.RequestCancelled, 'Request was cancelled', null);
