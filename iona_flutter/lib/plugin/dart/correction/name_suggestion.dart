import 'package:analyzer_plugin/src/utilities/string_utilities.dart';

/// Returns all variants of names by removing leading words one by one.
List<String> getCamelWordCombinations(String name) {
  var result = <String>[];
  var parts = getCamelWords(name);
  for (var i = 0; i < parts.length; i++) {
    var s1 = parts[i].toLowerCase();
    var s2 = parts.skip(i + 1).join();
    var suggestion = '$s1$s2';
    result.add(suggestion);
  }
  return result;
}
