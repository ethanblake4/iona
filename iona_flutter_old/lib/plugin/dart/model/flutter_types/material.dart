/*
class DartEvalTypeMaterialApp<T extends MaterialApp> extends DartEvalTypeWidget<T> {
  const DartEvalTypeMaterialApp(T value) : super(value);

  @override
  DartEvalType getField(String name) {
    switch (name) {
      case 'color':
        return DartEvalTypeColor(value.color);
      default:
        return super.getField(name);
    }
  }
}

class DartEvalTypeTextTheme<T extends TextTheme> extends DartEvalTypeObject<T> {
  const DartEvalTypeTextTheme(T value) : super(value);

  @override
  DartEvalType getField(String name) {
    switch (name) {
      case 'headline4':
        return DartEvalTypeTextStyle(value.headline4);
        break;
      default:
        return super.getField(name);
    }
  }
}

class DartEvalTypeVisualDensity<T extends VisualDensity> extends DartEvalTypeObject<T> {
  const DartEvalTypeVisualDensity(T value) : super(value);

  @override
  DartEvalType getField(String name) {
    switch (name) {
      case 'vertical':
        return DartEvalTypeDouble(value.vertical);
      case 'horizontal':
        return DartEvalTypeDouble(value.horizontal);
      default:
        return super.getField(name);
    }
  }
}

class DartEvalTypeThemeData<T extends ThemeData> extends DartEvalTypeObject<T> {
  const DartEvalTypeThemeData(T value) : super(value);

  @override
  DartEvalType getField(String name) {
    switch (name) {
      case 'primaryColor':
        return DartEvalTypeColor(value.primaryColor);
      case 'backgroundColor':
        return DartEvalTypeColor(value.backgroundColor);
      case 'textTheme':
        return DartEvalTypeTextTheme(value.textTheme);
        break;
      default:
        return super.getField(name);
    }
  }
}
*/
