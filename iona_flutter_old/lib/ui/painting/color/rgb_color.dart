import 'fl_color.dart';
import 'hex_color.dart';

class RgbColor extends FlColor {
  final num r;
  final num g;
  final num b;
  static const int rMin = 0;
  static const int gMin = 0;
  static const int bMin = 0;
  static const int rMax = 255;
  static const int gMax = 255;
  static const int bMax = 255;

  /// Creates a [FlColor] using a vector describing its red, green, and blue
  /// values.
  ///
  /// The value for [r], [g], and [b] should be in the range between 0 and
  /// 255 (inclusive).  Values above this range will be assumed to be a value
  /// of 255, and values below this range will be assumed to be a value of 0.
  const RgbColor(this.r, this.g, this.b);

  RgbColor toRgbColor() => this;

  HexColor toHexColor() => HexColor.fromRgb(r, g, b);

  String toString() => "r: $r, g: $g, b: $b";

  String toCssString() => 'rgb(${r.toInt()}, ${g.toInt()}, ${b.toInt()})';

  Map<String, num> toMap() => {'r': r, 'g': g, 'b': b};

  double darkness() => 1 - (0.299 * r + 0.587 * g + 0.114 * b) / 255;

  RgbColor mixWith(RgbColor o, double fac) {
    double af = 1 - fac;
    return FlColor.rgb((r * fac) + (o.r * af), (g * fac) + (o.g * af), (b * fac) + (o.b * af));
  }
}
