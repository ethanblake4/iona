//import 'package:path/path.dart';

String findRootContainingSync(String pathToSearchFrom, String file) {
  return null;
  /*var current = pathToSearchFrom;

  final root = rootPrefix(current);

  // traverse up the directory to find if we are in a traditional directory.
  while (current != root) {
    if (exists(join(current, file))) {
      return current;
    }
    current = dirname(current);
  }

  return pathToSearchFrom;*/
}

/// Validates that there are no non-null arguments following a null one and
/// throws an appropriate [ArgumentError] on failure.
void _validateArgList(String method, List<String> args) {
  for (var i = 1; i < args.length; i++) {
    // Ignore nulls hanging off the end.
    if (args[i] == null || args[i - 1] != null) continue;

    int numArgs;
    for (numArgs = args.length; numArgs >= 1; numArgs--) {
      if (args[numArgs - 1] != null) break;
    }

    // Show the arguments.
    final message = StringBuffer();
    message.write('$method(');
    message.write(args.take(numArgs).map((arg) => arg == null ? 'null' : '"$arg"').join(', '));
    message.write('): part ${i - 1} was null, but part $i was not.');
    throw ArgumentError(message.toString());
  }
}
