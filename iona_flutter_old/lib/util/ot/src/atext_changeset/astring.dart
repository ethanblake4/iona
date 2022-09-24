part of otdartlib.atext_changeset;

class AString {
  final String atts;
  final String text;
  final int dLen;
  final List pool;

  AString({this.atts: '', this.text: '', this.dLen: 0, this.pool});

  AString.unpack(Map<String, dynamic> obj, [List pool]) : this(atts: obj['a'], text: obj['s'], dLen: null, pool: pool);

  bool operator ==(other) => other is AString && atts == other.atts && text == other.text;

  bool get isEmpty => text.isEmpty;
  bool get isNotEmpty => !isEmpty;

  Map<String, dynamic> pack() => {'a': atts, 's': text};

  static int packedLength(Map<String, dynamic> line) => line['s'].length;
}
