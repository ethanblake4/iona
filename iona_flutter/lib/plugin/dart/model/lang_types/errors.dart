/*class DartEvalTypeError<T extends Error> extends DartEvalTypeObject<T> {
  const DartEvalTypeError(T value) : super(value);

  @override
  DartEvalType getField(String name) {
    switch (name) {
      case 'stackTrace':
        return DartEvalTypeStackTrace(value.stackTrace);
      default:
        return super.getField(name);
    }
  }
}

class DartEvalTypeNoSuchMethodError<T extends NoSuchMethodError> extends DartEvalTypeObject<T> {
  const DartEvalTypeNoSuchMethodError(T value) : super(value);
}

class DartEvalTypeStackTrace<T extends StackTrace> extends DartEvalTypeObject<T> {
  const DartEvalTypeStackTrace(T value) : super(value);
}
*/
