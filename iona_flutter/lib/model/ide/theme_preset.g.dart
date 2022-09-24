// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_preset.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<ThemePreset> _$themePresetSerializer = new _$ThemePresetSerializer();

class _$ThemePresetSerializer implements StructuredSerializer<ThemePreset> {
  @override
  final Iterable<Type> types = const [ThemePreset, _$ThemePreset];
  @override
  final String wireName = 'ThemePreset';

  @override
  Iterable<Object> serialize(Serializers serializers, ThemePreset object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'projectBrowserBackground',
      serializers.serialize(object.projectBrowserBackground,
          specifiedType: const FullType(String)),
      'termBackground',
      serializers.serialize(object.termBackground,
          specifiedType: const FullType(String)),
      'text',
      serializers.serialize(object.text, specifiedType: const FullType(String)),
      'textActive',
      serializers.serialize(object.textActive,
          specifiedType: const FullType(String)),
      'windowHeader',
      serializers.serialize(object.windowHeader,
          specifiedType: const FullType(String)),
      'windowHeaderActive',
      serializers.serialize(object.windowHeaderActive,
          specifiedType: const FullType(String)),
      'fileTreeSelectedFile',
      serializers.serialize(object.fileTreeSelectedFile,
          specifiedType: const FullType(String)),
    ];

    return result;
  }

  @override
  ThemePreset deserialize(Serializers serializers, Iterable<Object> serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ThemePresetBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final Object value = iterator.current;
      switch (key) {
        case 'projectBrowserBackground':
          result.projectBrowserBackground = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'termBackground':
          result.termBackground = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'text':
          result.text = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'textActive':
          result.textActive = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'windowHeader':
          result.windowHeader = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'windowHeaderActive':
          result.windowHeaderActive = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'fileTreeSelectedFile':
          result.fileTreeSelectedFile = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$ThemePreset extends ThemePreset {
  @override
  final String projectBrowserBackground;
  @override
  final String termBackground;
  @override
  final String text;
  @override
  final String textActive;
  @override
  final String windowHeader;
  @override
  final String windowHeaderActive;
  @override
  final String fileTreeSelectedFile;

  factory _$ThemePreset([void Function(ThemePresetBuilder) updates]) =>
      (new ThemePresetBuilder()..update(updates)).build();

  _$ThemePreset._(
      {this.projectBrowserBackground,
      this.termBackground,
      this.text,
      this.textActive,
      this.windowHeader,
      this.windowHeaderActive,
      this.fileTreeSelectedFile})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(
        projectBrowserBackground, 'ThemePreset', 'projectBrowserBackground');
    BuiltValueNullFieldError.checkNotNull(
        termBackground, 'ThemePreset', 'termBackground');
    BuiltValueNullFieldError.checkNotNull(text, 'ThemePreset', 'text');
    BuiltValueNullFieldError.checkNotNull(
        textActive, 'ThemePreset', 'textActive');
    BuiltValueNullFieldError.checkNotNull(
        windowHeader, 'ThemePreset', 'windowHeader');
    BuiltValueNullFieldError.checkNotNull(
        windowHeaderActive, 'ThemePreset', 'windowHeaderActive');
    BuiltValueNullFieldError.checkNotNull(
        fileTreeSelectedFile, 'ThemePreset', 'fileTreeSelectedFile');
  }

  @override
  ThemePreset rebuild(void Function(ThemePresetBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ThemePresetBuilder toBuilder() => new ThemePresetBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ThemePreset &&
        projectBrowserBackground == other.projectBrowserBackground &&
        termBackground == other.termBackground &&
        text == other.text &&
        textActive == other.textActive &&
        windowHeader == other.windowHeader &&
        windowHeaderActive == other.windowHeaderActive &&
        fileTreeSelectedFile == other.fileTreeSelectedFile;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc($jc(0, projectBrowserBackground.hashCode),
                            termBackground.hashCode),
                        text.hashCode),
                    textActive.hashCode),
                windowHeader.hashCode),
            windowHeaderActive.hashCode),
        fileTreeSelectedFile.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('ThemePreset')
          ..add('projectBrowserBackground', projectBrowserBackground)
          ..add('termBackground', termBackground)
          ..add('text', text)
          ..add('textActive', textActive)
          ..add('windowHeader', windowHeader)
          ..add('windowHeaderActive', windowHeaderActive)
          ..add('fileTreeSelectedFile', fileTreeSelectedFile))
        .toString();
  }
}

class ThemePresetBuilder implements Builder<ThemePreset, ThemePresetBuilder> {
  _$ThemePreset _$v;

  String _projectBrowserBackground;
  String get projectBrowserBackground => _$this._projectBrowserBackground;
  set projectBrowserBackground(String projectBrowserBackground) =>
      _$this._projectBrowserBackground = projectBrowserBackground;

  String _termBackground;
  String get termBackground => _$this._termBackground;
  set termBackground(String termBackground) =>
      _$this._termBackground = termBackground;

  String _text;
  String get text => _$this._text;
  set text(String text) => _$this._text = text;

  String _textActive;
  String get textActive => _$this._textActive;
  set textActive(String textActive) => _$this._textActive = textActive;

  String _windowHeader;
  String get windowHeader => _$this._windowHeader;
  set windowHeader(String windowHeader) => _$this._windowHeader = windowHeader;

  String _windowHeaderActive;
  String get windowHeaderActive => _$this._windowHeaderActive;
  set windowHeaderActive(String windowHeaderActive) =>
      _$this._windowHeaderActive = windowHeaderActive;

  String _fileTreeSelectedFile;
  String get fileTreeSelectedFile => _$this._fileTreeSelectedFile;
  set fileTreeSelectedFile(String fileTreeSelectedFile) =>
      _$this._fileTreeSelectedFile = fileTreeSelectedFile;

  ThemePresetBuilder();

  ThemePresetBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _projectBrowserBackground = $v.projectBrowserBackground;
      _termBackground = $v.termBackground;
      _text = $v.text;
      _textActive = $v.textActive;
      _windowHeader = $v.windowHeader;
      _windowHeaderActive = $v.windowHeaderActive;
      _fileTreeSelectedFile = $v.fileTreeSelectedFile;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ThemePreset other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$ThemePreset;
  }

  @override
  void update(void Function(ThemePresetBuilder) updates) {
    if (updates != null) updates(this);
  }

  @override
  _$ThemePreset build() {
    final _$result = _$v ??
        new _$ThemePreset._(
            projectBrowserBackground: BuiltValueNullFieldError.checkNotNull(
                projectBrowserBackground,
                'ThemePreset',
                'projectBrowserBackground'),
            termBackground: BuiltValueNullFieldError.checkNotNull(
                termBackground, 'ThemePreset', 'termBackground'),
            text: BuiltValueNullFieldError.checkNotNull(
                text, 'ThemePreset', 'text'),
            textActive: BuiltValueNullFieldError.checkNotNull(
                textActive, 'ThemePreset', 'textActive'),
            windowHeader: BuiltValueNullFieldError.checkNotNull(
                windowHeader, 'ThemePreset', 'windowHeader'),
            windowHeaderActive: BuiltValueNullFieldError.checkNotNull(
                windowHeaderActive, 'ThemePreset', 'windowHeaderActive'),
            fileTreeSelectedFile: BuiltValueNullFieldError.checkNotNull(
                fileTreeSelectedFile, 'ThemePreset', 'fileTreeSelectedFile'));
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,deprecated_member_use_from_same_package,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
