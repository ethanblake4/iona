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
  Iterable serialize(Serializers serializers, ThemePreset object,
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
  ThemePreset deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new ThemePresetBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
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
    if (projectBrowserBackground == null) {
      throw new BuiltValueNullFieldError(
          'ThemePreset', 'projectBrowserBackground');
    }
    if (termBackground == null) {
      throw new BuiltValueNullFieldError('ThemePreset', 'termBackground');
    }
    if (text == null) {
      throw new BuiltValueNullFieldError('ThemePreset', 'text');
    }
    if (textActive == null) {
      throw new BuiltValueNullFieldError('ThemePreset', 'textActive');
    }
    if (windowHeader == null) {
      throw new BuiltValueNullFieldError('ThemePreset', 'windowHeader');
    }
    if (windowHeaderActive == null) {
      throw new BuiltValueNullFieldError('ThemePreset', 'windowHeaderActive');
    }
    if (fileTreeSelectedFile == null) {
      throw new BuiltValueNullFieldError('ThemePreset', 'fileTreeSelectedFile');
    }
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
    if (_$v != null) {
      _projectBrowserBackground = _$v.projectBrowserBackground;
      _termBackground = _$v.termBackground;
      _text = _$v.text;
      _textActive = _$v.textActive;
      _windowHeader = _$v.windowHeader;
      _windowHeaderActive = _$v.windowHeaderActive;
      _fileTreeSelectedFile = _$v.fileTreeSelectedFile;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ThemePreset other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
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
            projectBrowserBackground: projectBrowserBackground,
            termBackground: termBackground,
            text: text,
            textActive: textActive,
            windowHeader: windowHeader,
            windowHeaderActive: windowHeaderActive,
            fileTreeSelectedFile: fileTreeSelectedFile);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,always_specify_types,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
