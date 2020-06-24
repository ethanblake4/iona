/*
Outline _nodeOutline(AstNode node, Element element, [List<Outline> children]) {
  var offset = node.offset;
  var end = node.end;
  if (node is VariableDeclaration) {
    var parent = node.parent;
    if (parent is VariableDeclarationList && parent.variables.isNotEmpty) {
      if (parent.variables[0] == node) {
        offset = parent.parent.offset;
      }
      if (parent.variables.last == node) {
        end = parent.parent.end;
      }
    }
  }

  var codeOffset = node.offset;
  if (node is AnnotatedNode) {
    codeOffset = node.firstTokenAfterCommentAndMetadata.offset;
  }

  var length = end - offset;
  var codeLength = node.end - codeOffset;
  return Outline(element, offset, length, codeOffset, codeLength, children: nullIfEmpty(children));
}

List<E> nullIfEmpty<E>(List<E> list) {
  if (list == null) {
    return null;
  }
  if (list.isEmpty) {
    return null;
  }
  return list;
}
*/
