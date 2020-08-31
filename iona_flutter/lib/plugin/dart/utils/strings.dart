final commentRegex = RegExp(r'^(?:\s+)?\/\/+(?:\s+)?');

class ConstructorPath {
  const ConstructorPath({this.path1, this.path2, this.type, this.constructor});

  factory ConstructorPath.fromString(String path) {
    final pathParts = path.split(';');
    return ConstructorPath(
        path1: pathParts[0],
        path2: pathParts[1],
        type: pathParts[2],
        constructor: pathParts.length > 3 ? pathParts[3] : null);
  }

  final String path1;
  final String path2;
  final String type;
  final String constructor;

  @override
  String toString() {
    return 'ConstructorPath{path1: $path1, path2: $path2, type: $type, constructor: $constructor}';
  }
}

String docCommentPlaintext(String docComment) {
  return docComment
      .split('\n')
      .map((line) => line.replaceFirst(commentRegex, ''))
      .reduce((value, element) => '$value\n$element');
}
