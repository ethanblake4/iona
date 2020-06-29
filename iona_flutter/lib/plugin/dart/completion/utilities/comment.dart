/// Return the DartDoc summary, i.e. the portion before the first empty line.
String getDartDocSummary(String completeText) {
  if (completeText == null) return null;

  var result = StringBuffer();
  var lines = completeText.split('\n');
  for (var line in lines) {
    if (result.isNotEmpty) {
      if (line.isEmpty) {
        return result.toString();
      }
      result.write('\n');
    }
    result.write(line);
  }
  return result.toString();
}
