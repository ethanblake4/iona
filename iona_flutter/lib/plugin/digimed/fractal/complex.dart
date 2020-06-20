import 'dart:math' as math;
import 'dart:typed_data';

/// Represents 4 complex numbers
class ComplexX4 {
  static final _mmask = Float32x4(-1, 1, -1, 1);
  static final ComplexX4 zero = ComplexX4(Float32x4(0, 0, 0, 0), Float32x4(0, 0, 0, 0));
  static final Float32x4 two = Float32x4(2, 2, 2, 2);
  static final Float32x4 three = Float32x4(3, 3, 3, 3);

  /// Real component
  Float32x4 re;

  /// Imaginary component
  Float32x4 im;

  /// Create a [ComplexX4] with specified real and imaginary values
  ComplexX4(this.re, this.im);

  /// Modulus of the complex numbers
  Float32x4 mod() => ((re * re) + (im * im)).sqrt();

  /// Argument of the complex numbers
  Float32x4 arg() =>
      Float32x4(math.atan2(im.x, re.x), math.atan2(im.y, re.y), math.atan2(im.z, re.z), math.atan2(im.w, re.w));

  /// Add complex numbers
  ComplexX4 operator +(ComplexX4 addend) => ComplexX4(re + addend.re, im + addend.im);

  /// Add a set of real numbers to this [ComplexX4]
  ComplexX4 addReal(double a) => ComplexX4(re + Float32x4(a, a, a, a), im);

  /// Subtract complex numbers
  ComplexX4 operator -(ComplexX4 subtrahend) => ComplexX4(re - subtrahend.re, im - subtrahend.im);

  /// Multiply a [ComplexX4] by another [ComplexX4]
  ComplexX4 operator *(ComplexX4 other) {
    final _zero = re.shuffleMix(im, Float32x4.xyxy).shuffle(Float32x4.xzyw);
    final _one = other.im.shuffle(Float32x4.xxyy);
    final _two = other.re.shuffle(Float32x4.xxyy);
    final _three = _zero.shuffle(Float32x4.yxwz);

    final first = (_zero * _two) + ((_three * _one) * _mmask);

    final _zero1 = re.shuffleMix(im, Float32x4.zwzw).shuffle(Float32x4.xzyw);
    final _one1 = other.im.shuffle(Float32x4.zzww);
    final _two1 = other.re.shuffle(Float32x4.zzww);
    final _three1 = _zero.shuffle(Float32x4.yxwz);

    final second = (_zero1 * _two1) + ((_three1 * _one1) * _mmask);
    return ComplexX4(first.shuffleMix(second, Float32x4.xzxz), first.shuffleMix(second, Float32x4.ywyw));
  }

  /// Multiply a [ComplexX4] by a [Float32x4] set of real numbers
  ComplexX4 multiply(Float32x4 val) {
    return ComplexX4(re * val, im * val);
  }

  /// Raise a [ComplexX4] to an integer power
  ComplexX4 powi(int other) {
    var m = mod();
    for (var i = 0; i < other; i++) {
      m *= m;
    }
    final o = other.toDouble();
    final r = arg() * Float32x4(o, o, o, o);
    final rcos = Float32x4(math.cos(r.x), math.cos(r.y), math.cos(r.z), math.cos(r.w));
    final rsin = Float32x4(math.sin(r.x), math.sin(r.y), math.sin(r.z), math.sin(r.w));
    return ComplexX4(rcos * m, rsin * m);
  }

  /// Square
  /// Equivalent to powi(2)
  ComplexX4 pow2() {
    var m = mod();
    m = m * m;
    final r = arg() * two;
    final rcos = Float32x4(math.cos(r.x), math.cos(r.y), math.cos(r.z), math.cos(r.w));
    final rsin = Float32x4(math.sin(r.x), math.sin(r.y), math.sin(r.z), math.sin(r.w));
    return ComplexX4(rcos * m, rsin * m);
  }

  /// Cube
  /// Equivalent to powi(3)
  ComplexX4 pow3() {
    var m = mod();
    m = m * m * m;
    final r = arg() * three;
    final rcos = Float32x4(math.cos(r.x), math.cos(r.y), math.cos(r.z), math.cos(r.w));
    final rsin = Float32x4(math.sin(r.x), math.sin(r.y), math.sin(r.z), math.sin(r.w));
    return ComplexX4(rcos * m, rsin * m);
  }

  @override
  String toString() {
    return 'ComplexX4{re: $re, im: $im}';
  }

  /// Divide a [ComplexX4] by another [ComplexX4]
  ComplexX4 operator /(ComplexX4 other) {
    final pow = (other.re * other.re) + (other.im * other.im);
    return ComplexX4(
      ((re * other.re) + (im * other.im)) / pow,
      ((im * other.re) - (re * other.im)) / pow,
    );
  }

  /// The standard Distance Formula, applied to complex numbers
  Float32x4 euclidDistance(ComplexX4 other) {
    final rei = re - other.re;
    final imi = im - other.im;
    return ((rei * rei) + (imi * imi)).sqrt();
  }
}
