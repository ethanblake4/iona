import 'dart:ui';

import 'hex_color.dart';
import 'rgb_color.dart';

/// An object representing a color.
///
/// A [FlColor] can be constructed be specifying its value as either an RGB vector, a 6 digit hex string, an HSL vector, an XYZ vector, or a LAB vector using the appropriate named constructor. Alternatively, the appropriate subclass can be instantiated directly.
///
/// [FlColor]s can be directly compared using the `==` operator, which will return true if the two [FlColor] objects represent the same RGB color.
abstract class FlColor {
  const FlColor();
  const factory FlColor.rgb(num r, num g, num b) = RgbColor;
  factory FlColor.hex(String hexCode) = HexColor;

  RgbColor toRgbColor();
  HexColor toHexColor() => toRgbColor().toHexColor();

  String toString();
  Map<String, num> toMap();

  Color get col {
    final _rgb = toRgbColor();
    return Color.fromARGB(255, _rgb.r, _rgb.g, _rgb.b);
  }

  get hashCode {
    var rgb = toRgbColor();
    return 256 * 256 * rgb.r.toInt() + 256 * rgb.g.toInt() + rgb.b.toInt();
  }

  @override
  bool operator ==(Object other) => other is FlColor && this.hashCode == other.hashCode;

  num operator [](String key) => toMap()[key];
}
