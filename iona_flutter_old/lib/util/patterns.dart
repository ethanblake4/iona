/// Capture variables
final variableCapture = RegExp(r'(?<!\\){{(\w+)}}');

final indentRegex = RegExp(r'^(?:( )+|\t+)');

final newlineChars = RegExp(r'\r|\n');
