import 'package:analyzer/dart/element/element.dart' as engine;
import 'package:analyzer/exception/exception.dart';
import 'package:analyzer/source/line_info.dart';
import 'package:analyzer/source/source_range.dart' as engine;
import 'package:analyzer_plugin/protocol/protocol_common.dart';

export 'package:analyzer_plugin/protocol/protocol_common.dart';

export 'protocol_dart.dart';

String getReturnTypeString(engine.Element element) {
  if (element is engine.ExecutableElement) {
    if (element.kind == engine.ElementKind.SETTER) {
      return null;
    } else {
      return element.returnType?.getDisplayString(withNullability: false);
    }
  } else if (element is engine.VariableElement) {
    var type = element.type;
    return type != null ? type.getDisplayString(withNullability: false) : 'dynamic';
  } else if (element is engine.FunctionTypeAliasElement) {
    var returnType = element.function.returnType;
    return returnType.getDisplayString(withNullability: false);
  } else {
    return null;
  }
}

/// Create a Location based on an [engine.Element].
Location newLocation_fromElement(engine.Element element) {
  if (element == null || element.source == null) {
    return null;
  }
  var offset = element.nameOffset;
  var length = element.nameLength;
  if (element is engine.CompilationUnitElement || (element is engine.LibraryElement && offset < 0)) {
    offset = 0;
    length = 0;
  }
  var unitElement = _getUnitElement(element);
  var range = engine.SourceRange(offset, length);
  return _locationForArgs(unitElement, range);
}

engine.CompilationUnitElement _getUnitElement(engine.Element element) {
  if (element is engine.CompilationUnitElement) {
    return element;
  }
  if (element?.enclosingElement is engine.LibraryElement) {
    element = element.enclosingElement;
  }
  if (element is engine.LibraryElement) {
    return element.definingCompilationUnit;
  }
  for (; element != null; element = element.enclosingElement) {
    if (element is engine.CompilationUnitElement) {
      return element;
    }
  }
  return null;
}

/// Creates a new [Location].
Location _locationForArgs(engine.CompilationUnitElement unitElement, engine.SourceRange range) {
  var startLine = 0;
  var startColumn = 0;
  try {
    var lineInfo = unitElement.lineInfo;
    if (lineInfo != null) {
      CharacterLocation offsetLocation = lineInfo.getLocation(range.offset);
      startLine = offsetLocation.lineNumber;
      startColumn = offsetLocation.columnNumber;
    }
  } on AnalysisException {
    // TODO(brianwilkerson) It doesn't look like the code in the try block
    //  should be able to throw an exception. Try removing the try statement.
  }
  return Location(unitElement.source.fullName, range.offset, range.length, startLine, startColumn);
}

/// The kind of a completion entry.
class CompletionItemKind {
  const CompletionItemKind(this._value);
  const CompletionItemKind.fromJson(this._value);

  final num _value;

  static bool canParse(Object obj) {
    return obj is num;
  }

  static const Text = CompletionItemKind(1);
  static const Method = CompletionItemKind(2);
  static const Function = CompletionItemKind(3);
  static const Constructor = CompletionItemKind(4);
  static const Field = CompletionItemKind(5);
  static const Variable = CompletionItemKind(6);
  static const Class = CompletionItemKind(7);
  static const Interface = CompletionItemKind(8);
  static const Module = CompletionItemKind(9);
  static const Property = CompletionItemKind(10);
  static const Unit = CompletionItemKind(11);
  static const Value = CompletionItemKind(12);
  static const Enum = CompletionItemKind(13);
  static const Keyword = CompletionItemKind(14);
  static const Snippet = CompletionItemKind(15);
  static const Color = CompletionItemKind(16);
  static const File = CompletionItemKind(17);
  static const Reference = CompletionItemKind(18);
  static const Folder = CompletionItemKind(19);
  static const EnumMember = CompletionItemKind(20);
  static const Constant = CompletionItemKind(21);
  static const Struct = CompletionItemKind(22);
  static const Event = CompletionItemKind(23);
  static const Operator = CompletionItemKind(24);
  static const TypeParameter = CompletionItemKind(25);

  Object toJson() => _value;

  @override
  String toString() => _value.toString();

  @override
  int get hashCode => _value.hashCode;

  bool operator ==(Object o) => o is CompletionItemKind && o._value == _value;
}
