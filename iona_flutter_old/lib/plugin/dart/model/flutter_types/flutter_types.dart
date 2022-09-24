/*
class DartEvalTypeWidget<T extends Widget> extends DartEvalTypeObject<T> {
  const DartEvalTypeWidget(
    Widget value,
  ) : super(value);

  @override
  DartEvalType getField(String name) {
    switch (name) {
      case 'key':
        return DartEvalTypeKey(value.key);
      default:
        return super.getField(name);
    }
  }
}

class DartEvalTypeEditorReportingWidget<T extends EditorReportingWidget> extends DartEvalTypeWidget<T> {
  const DartEvalTypeEditorReportingWidget(Widget value, {this.proxy}) : super(value);

  final DartEvalTypeWidget proxy;

  @override
  DartEvalType getField(String name) {
    switch (name) {
      case 'key':
        return DartEvalTypeKey(value.key);
      default:
        return proxy.getField(name);
    }
  }

  @override
  void setField(String name, DartEvalType value) {
    return proxy.setField(name, value);
  }

  @override
  DartEvalCallable getMethod(String name) {
    return proxy.getMethod(name);
  }
}

class DartEvalTypeBuildContext<T extends BuildContext> extends DartEvalTypeObject<T> {
  const DartEvalTypeBuildContext(BuildContext value) : super(value);

  @override
  DartEvalType getField(String name) {
    switch (name) {
      default:
        return super.getField(name);
    }
  }
}

class DartEvalTypeStatelessWidget<T extends StatelessWidget> extends DartEvalTypeWidget<T> {
  const DartEvalTypeStatelessWidget(StatelessWidget value) : super(value);

  @override
  DartEvalCallable getMethod(String name) {
    switch (name) {
      case 'build':
        // ignore: invalid_use_of_protected_member
        return DartInternalCallable(value.build, (positionalArgs, namedArgs) => DartEvalTypeString(toString()),
            params: [], namedParams: {});
      default:
        return super.getMethod(name);
    }
  }
}

class DartEvalTypeStatefulWidget<T extends StatefulWidget> extends DartEvalTypeWidget<T> {
  const DartEvalTypeStatefulWidget(T value) : super(value);
}

class DartEvalTypeKey<T extends Key> extends DartEvalTypeObject<T> {
  const DartEvalTypeKey(Key value) : super(value);
}

class DartEvalTypeTextDirection<T extends TextDirection> extends DartEvalTypeObject<T> {
  const DartEvalTypeTextDirection(T value) : super(value);

  @override
  DartEvalType getField(String name) {
    switch (name) {
      case 'index':
        return DartEvalTypeInt(value.index);
        break;
      default:
        return super.getField(name);
    }
  }
}

class DartEvalTypeIconData<T extends IconData> extends DartEvalTypeObject<T> {
  const DartEvalTypeIconData(T value) : super(value);

  @override
  DartEvalType getField(String name) {
    switch (name) {
      case 'codePoint':
        return DartEvalTypeInt(value.codePoint);
      case 'fontFamily':
        return DartEvalTypeString(value.fontFamily);
      case 'fontPackage':
        return DartEvalTypeString(value.fontPackage);
      case 'matchTextDirection':
        return DartEvalTypeBool(value.matchTextDirection);
      default:
        return super.getField(name);
    }
  }
}

class DartEvalTypeTextStyle<T extends TextStyle> extends DartEvalTypeObject<T> {
  const DartEvalTypeTextStyle(T value) : super(value);

  @override
  DartEvalType getField(String name) {
    switch (name) {
      default:
        return super.getField(name);
    }
  }
}

class DartEvalTypeColor<T extends Color> extends DartEvalTypeObject<T> {
  const DartEvalTypeColor(T value) : super(value);

  @override
  DartEvalType getField(String name) {
    switch (name) {
      case 'value':
        return DartEvalTypeInt(value.value);
      case 'alpha':
        return DartEvalTypeInt(value.alpha);
      case 'red':
        return DartEvalTypeInt(value.red);
      case 'green':
        return DartEvalTypeInt(value.green);
      case 'blue':
        return DartEvalTypeInt(value.blue);
      default:
        return super.getField(name);
    }
  }
}*/
