import 'package:flutter/widgets.dart';
import 'package:iona_flutter/ui/painting/color/color.dart';
import 'package:scoped_model/scoped_model.dart';

import 'theme_preset.dart';

/// A [Model] representing the current workspace
class IdeTheme extends Model {
  /// Constructs a default IdeTheme
  IdeTheme() {
    fromPreset(ThemePreset.DEFAULT);
  }

  /// Returns the nearest [IdeTheme] in the widget hierarchy
  static IdeTheme of(BuildContext context) => ScopedModel.of<IdeTheme>(context);

  FlColor projectBrowserBackground;
  FlColor termBackground;
  FlColor windowHeader;
  FlColor windowHeaderActive;
  FlColor fileTreeSelectedFile;
  FlColor text;
  FlColor textActive;

  /// Update from a [ThemePreset]
  void fromPreset(ThemePreset preset) {
    projectBrowserBackground = FlColor.hex(preset.projectBrowserBackground);
    termBackground = FlColor.hex(preset.termBackground);
    windowHeader = FlColor.hex(preset.windowHeader);
    windowHeaderActive = FlColor.hex(preset.windowHeaderActive);
    fileTreeSelectedFile = FlColor.hex(preset.fileTreeSelectedFile);
    text = FlColor.hex(preset.text);
    textActive = FlColor.hex(preset.textActive);
    notifyListeners();
  }

  @override
  String toString() {
    return 'IdeTheme{projectBrowserBackground: $projectBrowserBackground, text: $text, textActive: $textActive}';
  }
}

// ignore_for_file: public_member_api_docs
