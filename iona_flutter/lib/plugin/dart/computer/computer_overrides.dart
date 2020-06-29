import 'package:analyzer/dart/element/element.dart';

/// Return the elements that the given [element] overrides.
OverriddenElements findOverriddenElements(Element element) {
  if (element?.enclosingElement is ClassElement) {
    return _OverriddenElementsFinder(element).find();
  }
  return OverriddenElements(element, <Element>[], <Element>[]);
}

/// The container with elements that a class member overrides.
class OverriddenElements {
  /// The element that overrides other class members.
  final Element element;

  /// The elements that [element] overrides and which is defined in a class that
  /// is a superclass of the class that defines [element].
  final List<Element> superElements;

  /// The elements that [element] overrides and which is defined in a class that
  /// which is implemented by the class that defines [element].
  final List<Element> interfaceElements;

  OverriddenElements(this.element, this.superElements, this.interfaceElements);
}

class _OverriddenElementsFinder {
  static const List<ElementKind> FIELD_KINDS = <ElementKind>[ElementKind.FIELD, ElementKind.GETTER, ElementKind.SETTER];

  static const List<ElementKind> GETTER_KINDS = <ElementKind>[ElementKind.FIELD, ElementKind.GETTER];

  static const List<ElementKind> METHOD_KINDS = <ElementKind>[ElementKind.METHOD];

  static const List<ElementKind> SETTER_KINDS = <ElementKind>[ElementKind.FIELD, ElementKind.SETTER];

  Element _seed;
  LibraryElement _library;
  ClassElement _class;
  String _name;
  List<ElementKind> _kinds;

  final List<Element> _superElements = <Element>[];
  final List<Element> _interfaceElements = <Element>[];
  final Set<ClassElement> _visited = <ClassElement>{};

  _OverriddenElementsFinder(Element seed) {
    _seed = seed;
    _class = seed.enclosingElement;
    _library = _class.library;
    _name = seed.displayName;
    if (seed is MethodElement) {
      _kinds = METHOD_KINDS;
    } else if (seed is PropertyAccessorElement) {
      _kinds = seed.isGetter ? GETTER_KINDS : SETTER_KINDS;
    } else {
      _kinds = FIELD_KINDS;
    }
  }

  /// Add the [OverriddenElements] for this element.
  OverriddenElements find() {
    _visited.clear();
    _addSuperOverrides(_class, withThisType: false);
    _visited.clear();
    _addInterfaceOverrides(_class, false);
    _superElements.forEach(_interfaceElements.remove);
    return OverriddenElements(_seed, _superElements, _interfaceElements);
  }

  void _addInterfaceOverrides(ClassElement class_, bool checkType) {
    if (class_ == null) {
      return;
    }
    if (!_visited.add(class_)) {
      return;
    }
    // this type
    if (checkType) {
      var element = _lookupMember(class_);
      if (element != null && !_interfaceElements.contains(element)) {
        _interfaceElements.add(element);
      }
    }
    // interfaces
    for (var interfaceType in class_.interfaces) {
      _addInterfaceOverrides(interfaceType.element, true);
    }
    // super
    _addInterfaceOverrides(class_.supertype?.element, checkType);
  }

  void _addSuperOverrides(ClassElement class_, {bool withThisType = true}) {
    if (class_ == null) {
      return;
    }
    if (!_visited.add(class_)) {
      return;
    }

    if (withThisType) {
      var element = _lookupMember(class_);
      if (element != null && !_superElements.contains(element)) {
        _superElements.add(element);
      }
    }

    _addSuperOverrides(class_.supertype?.element);
    for (var mixin_ in class_.mixins) {
      _addSuperOverrides(mixin_.element);
    }
    for (var constraint in class_.superclassConstraints) {
      _addSuperOverrides(constraint.element);
    }
  }

  Element _lookupMember(ClassElement classElement) {
    if (classElement == null) {
      return null;
    }
    Element member;
    // method
    if (_kinds.contains(ElementKind.METHOD)) {
      member = classElement.lookUpMethod(_name, _library);
      if (member != null) {
        return member;
      }
    }
    // getter
    if (_kinds.contains(ElementKind.GETTER)) {
      member = classElement.lookUpGetter(_name, _library);
      if (member != null) {
        return member;
      }
    }
    // setter
    if (_kinds.contains(ElementKind.SETTER)) {
      member = classElement.lookUpSetter(_name + '=', _library);
      if (member != null) {
        return member;
      }
    }
    // not found
    return null;
  }
}
