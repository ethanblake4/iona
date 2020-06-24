import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/src/dart/analysis/library_context.dart';
import 'package:analyzer/src/summary2/linking_bundle_context.dart';
import 'package:iona_flutter/plugin/dart/compute/ast_binary_write.dart';

void writeAst(LibraryContext context, CompilationUnit unit) {
  final linkingBundleContext = LinkingBundleContext(
    context.elementFactory.dynamicRef,
  );
  print(AstBinaryWriter(linkingBundleContext).writeUnit(unit).toString());
}
