import 'package:flutter/services.dart';

class SingleMatchTextFormatter extends TextInputFormatter {
  /// Creates a formatter that prevents the insertion of characters
  /// based on a filter pattern.
  ///
  /// If [allow] is true, then the filter pattern is an allow list,
  /// and characters must match the pattern to be accepted. See also
  /// the `FilteringTextInputFormatter.allow` constructor.
  // TODO(goderbauer): Cannot link to the constructor because of https://github.com/dart-lang/dartdoc/issues/2276.
  ///
  /// If [allow] is false, then the filter pattern is a deny list,
  /// and characters that match the pattern are rejected. See also
  /// the [FilteringTextInputFormatter.deny] constructor.
  ///
  /// The [filterPattern], [allow], and [replacementString] arguments
  /// must not be null.
  SingleMatchTextFormatter(
    this.filterPattern, {
    this.allow,
    this.replacementString = '',
  })  : assert(filterPattern != null),
        assert(allow != null),
        assert(replacementString != null);

  /// Creates a formatter that only allows characters matching a pattern.
  ///
  /// The [filterPattern] and [replacementString] arguments
  /// must not be null.
  SingleMatchTextFormatter.allow(
    this.filterPattern, {
    this.replacementString = '',
  })  : assert(filterPattern != null),
        assert(replacementString != null),
        allow = true;

  /// Creates a formatter that blocks characters matching a pattern.
  ///
  /// The [filterPattern] and [replacementString] arguments
  /// must not be null.
  SingleMatchTextFormatter.deny(
    this.filterPattern, {
    this.replacementString = '',
  })  : assert(filterPattern != null),
        assert(replacementString != null),
        allow = false;

  /// A [Pattern] to match and replace in incoming [TextEditingValue]s.
  ///
  /// The behaviour of the pattern depends on the [allow] property. If
  /// it is true, then this is an allow list, specifying a pattern that
  /// characters must match to be accepted. Otherwise, it is a deny list,
  /// specifying a pattern that characters must not match to be accepted.
  ///
  /// In general, the pattern should only match one character at a
  /// time. See the discussion at [replacementString].
  ///
  /// {@tool snippet}
  /// Typically the pattern is a regular expression, as in:
  ///
  /// ```dart
  /// var onlyDigits = FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
  /// ```
  /// {@end-tool}
  ///
  /// {@tool snippet}
  /// If the pattern is a single character, a pattern consisting of a
  /// [String] can be used:
  ///
  /// ```dart
  /// var noTabs = FilteringTextInputFormatter.deny('\t');
  /// ```
  /// {@end-tool}
  final Pattern filterPattern;

  /// Whether the pattern is an allow list or not.
  ///
  /// When true, [filterPattern] denotes an allow list: characters
  /// must match the filter to be allowed.
  ///
  /// When false, [filterPattern] denotes a deny list: characters
  /// that match the filter are disallowed.
  final bool allow;

  /// String used to replace banned patterns.
  ///
  /// For deny lists ([allow] is false), each match of the
  /// [filterPattern] is replaced with this string. If [filterPattern]
  /// can match more than one character at a time, then this can
  /// result in multiple characters being replaced by a single
  /// instance of this [replacementString].
  ///
  /// For allow lists ([allow] is true), sequences between matches of
  /// [filterPattern] are replaced as one, regardless of the number of
  /// characters.
  ///
  /// For example, consider a [filterPattern] consisting of just the
  /// letter "o", applied to text field whose initial value is the
  /// string "Into The Woods", with the [replacementString] set to
  /// `*`.
  ///
  /// If [allow] is true, then the result will be "*o*oo*". Each
  /// sequence of characters not matching the pattern is replaced by
  /// its own single copy of the replacement string, regardless of how
  /// many characters are in that sequence.
  ///
  /// If [allow] is false, then the result will be "Int* the W**ds".
  /// Every matching sequence is replaced, and each "o" matches the
  /// pattern separately.
  ///
  /// If the pattern was the [RegExp] `o+`, the result would be the
  /// same in the case where [allow] is true, but in the case where
  /// [allow] is false, the result would be "Int* the W*ds" (with the
  /// two "o"s replaced by a single occurrence of the replacement
  /// string) because both of the "o"s would be matched simultaneously
  /// by the pattern.
  ///
  /// Additionally, each segment of the string before, during, and
  /// after the current selection in the [TextEditingValue] is handled
  /// separately. This means that, in the case of the "Into the Woods"
  /// example above, if the selection ended between the two "o"s in
  /// "Woods", even if the pattern was `RegExp('o+')`, the result
  /// would be "Int* the W**ds", since the two "o"s would be handled
  /// in separate passes.
  ///
  /// See also [String.splitMapJoin], which is used to implement this
  /// behavior in both cases.
  final String replacementString;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    if (newValue.text == '') return newValue;
    final am = filterPattern.allMatches(newValue.text);
    print(am.first.group(0));
    return newValue.copyWith(text: am.first.group(0));
  }
}

TextEditingValue _selectionAwareTextManipulation(
  TextEditingValue value,
  String substringManipulation(String substring),
) {
  final int selectionStartIndex = value.selection.start;
  final int selectionEndIndex = value.selection.end;
  String manipulatedText;
  TextSelection manipulatedSelection;
  if (selectionStartIndex < 0 || selectionEndIndex < 0) {
    manipulatedText = substringManipulation(value.text);
  } else {
    final String beforeSelection = substringManipulation(value.text.substring(0, selectionStartIndex));
    final String inSelection = substringManipulation(value.text.substring(selectionStartIndex, selectionEndIndex));
    final String afterSelection = substringManipulation(value.text.substring(selectionEndIndex));
    manipulatedText = beforeSelection + inSelection + afterSelection;
    if (value.selection.baseOffset > value.selection.extentOffset) {
      manipulatedSelection = value.selection.copyWith(
        baseOffset: beforeSelection.length + inSelection.length,
        extentOffset: beforeSelection.length,
      );
    } else {
      manipulatedSelection = value.selection.copyWith(
        baseOffset: beforeSelection.length,
        extentOffset: beforeSelection.length + inSelection.length,
      );
    }
  }
  return TextEditingValue(
    text: manipulatedText,
    selection: manipulatedSelection ?? const TextSelection.collapsed(offset: -1),
    composing: manipulatedText == value.text ? value.composing : TextRange.empty,
  );
}
