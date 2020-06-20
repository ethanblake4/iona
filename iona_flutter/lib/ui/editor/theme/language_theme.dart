import 'package:flutter/widgets.dart';

/// A theme for a specific language
class LanguageTheme {
  /// Create a [LanguageTheme] with the specified parent and syntax highlighting
  LanguageTheme(this.syntaxHighlighting, [this.parentLanguageTheme]);

  final LanguageTheme parentLanguageTheme;

  Map<String, Color> syntaxHighlighting;

  Color getHighlightFor(String key) {
    if (syntaxHighlighting.containsKey(key)) return syntaxHighlighting[key];

    Color c;
    syntaxHighlighting.forEach((k, v) {
      if (key.startsWith(k)) {
        c = v;
        return;
      }
    });
    if (c != null) return c;

    return parentLanguageTheme?.getHighlightFor(key);
  }
}
