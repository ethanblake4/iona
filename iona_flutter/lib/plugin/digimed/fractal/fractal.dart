import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:pedantic/pedantic.dart';

import 'complex.dart';
import 'complex_poly.dart';

class Fractal {
  /// Construct a Fractal
  Fractal(this.poly) {
    deriv = poly.derivative();
  }

  final ComplexPoly poly;
  ComplexPoly deriv;

  final size = 200;
  static const max = 0.0001;
  static const iter = 50;

  Future<List<Uint8List>> genImage(double xmin, double ymin, double xmax, double ymax) async {
    final res = Completer<List<Uint8List>>();
    final lis = <Uint8List>[null, null, null, null];
    var dl = 0;
    void cc(Uint8List v, int index) {
      lis[index] = v;
      if (dl++ == 3) {
        res.complete(lis);
      }
    }

    unawaited(
        compute(_genInternal, _FractalIsolateParams(xmin, (xmin + xmax) / 2, ymin, (ymin + ymax) / 2, poly).toList())
            .then((l) => cc(l, 0)));
    unawaited(
        compute(_genInternal, _FractalIsolateParams((xmin + xmax) / 2, xmax, ymin, (ymin + ymax) / 2, poly).toList())
            .then((l) => cc(l, 1)));
    unawaited(
        compute(_genInternal, _FractalIsolateParams(xmin, (xmin + xmax) / 2, (ymin + ymax) / 2, ymax, poly).toList())
            .then((l) => cc(l, 2)));
    unawaited(
        compute(_genInternal, _FractalIsolateParams((xmin + xmax) / 2, xmax, (ymin + ymax) / 2, ymax, poly).toList())
            .then((l) => cc(l, 3)));
    return await res.future;
  }

  static Uint8List _genInternal(List<num> paramList) {
    final params = _FractalIsolateParams.fromList(paramList),
        xmin = params.xmin,
        ymin = params.ymin,
        xmax = params.xmax,
        ymax = params.ymax,
        poly = params.poly,
        deriv = poly.derivative();

    print('ym $ymin, xm $xmin, ymx $ymax, xmax $xmax');

    final bmp = Uint8List(54 + (400 * 400 * 3));

    final bmp_header = Uint8List.fromList(<int>[
      0x42, 0x4d, // BM
      70, 0x00, 0x00, 0x00, // Total data size
      0x00, 0x00, 0x00, 0x00, // Unused
      0x36, 0x00, 0x00, 0x00, // Pixel array offset
      0x28, 0x00, 0x00, 0x00,
      0x90, 0x01, 0x00, 0x00, // Image width
      0x90, 0x01, 0x00, 0x00, // Image height
      0x01, 0x00,
      0x18, 0x00, // Bits per pixel (24)
      0x00, 0x00, 0x00, 0x00,
      0x10, 0x00, 0x00, 0x00, // BMP data size
      0x13, 0x0b, 0x00, 0x00,
      0x13, 0x0b, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      0x00, 0x00, 0x00, 0x00,
      ///////////////////////
    ]);
    for (var i_ = 0; i_ < bmp_header.length; i_++) {
      bmp[i_] = bmp_header[i_];
    }
    var dx = Float32x4(100.0, 100.0, 100.0, 100.0);

    var t = DateTime.now().millisecondsSinceEpoch;
    var tac = 0;
    final deltaY = (ymax - ymin);
    final deltaX = (xmax - xmin);
    final stepX = deltaX / 400;

    for (var y = 0; y < 400; y++) {
      final yv2 = deltaY / 400 * y + ymin;
      for (var x = 0; x < 400; x += 4) {
        final xv2 = deltaX / 400 * x + xmin;
        var guess =
            ComplexX4(Float32x4(xv2, xv2 + stepX, xv2 + stepX * 2, xv2 + stepX * 3), Float32x4(yv2, yv2, yv2, yv2));
        dx = Float32x4(100.0, 100.0, 100.0, 100.0);
        var i = 0;

        final mask = [true, true, true, true];
        final tries = [250, 250, 250, 250];
        final col = [0, 0, 0, 0];
        final c2 = [0, 0, 0, 0];
        final ts = (255.0 / iter);

        while (i < iter) {
          var mc = 0;
          var abs = (num x) => x > 0 ? x : -x;
          if (!mask[0] && dx.x < max) {
            mask[0] = true;
            tries[0] = (i * ts).floor();
            col[0] = (guess.re.x * 20).toInt() + (guess.im.x * 10).toInt();
            c2[0] = abs((guess.arg().x * 30).toInt());
            mc++;
          }
          if (!mask[1] && dx.y < max) {
            mask[1] = true;
            tries[1] = (i * ts).floor();
            col[1] = (guess.re.y * 20).toInt() + (guess.im.y * 10).toInt();
            c2[1] = abs((guess.arg().y * 30).toInt());
            mc++;
          }
          if (!mask[2] && dx.z < max) {
            mask[2] = true;
            tries[2] = (i * ts).floor();
            col[2] = (guess.re.z * 20).toInt() + (guess.im.z * 10).toInt();
            c2[2] = abs((guess.arg().z * 30).toInt());
            mc++;
          }
          if (!mask[3] && dx.w < max) {
            mask[3] = true;
            tries[3] = (i * ts).floor();
            col[3] = (guess.re.w * 20).toInt() + (guess.im.w * 10).toInt();
            c2[3] = abs((guess.arg().w * 30).toInt());
            mc++;
          }
          if (mc == 4) break;
          final newGuess = guess - (poly.getValues(guess) / (deriv.getValues(guess)));
          dx = guess.euclidDistance(newGuess);
          guess = newGuess;
          i++;
        }

        final yi = 54 + (y * 400 * 3).floor();
        var xi = (3 * x).floor();
        if (yi + xi + 17 < bmp.length) {
          bmp[yi + xi] = tries[0];
          bmp[yi + xi + 1] = c2[0] * tries[0];
          bmp[yi + xi + 2] = col[0];
          bmp[yi + xi + 3] = tries[1];
          bmp[yi + xi + 4] = c2[1] * tries[1];
          bmp[yi + xi + 5] = col[1];
          bmp[yi + xi + 6] = tries[2];
          bmp[yi + xi + 7] = c2[2] * tries[2];
          bmp[yi + xi + 8] = col[2];
          bmp[yi + xi + 9] = tries[3];
          bmp[yi + xi + 10] = c2[3] * tries[3];
          bmp[yi + xi + 11] = col[3];
        }
      }
    }
    //print(mp);

    // Insert total data size into BMP header metadata
    bmp[3] = bmp.length % 255;
    bmp[4] = (bmp.length / 256.0).floor() % 255;
    bmp[5] = (bmp.length / 65536.0).floor() % 255;

    // Insert BMP data size into BMP header metadata
    bmp[34] = (bmp.length - 52) % 255;
    bmp[35] = ((bmp.length - 52) / 256.0).floor() % 255;
    bmp[36] = ((bmp.length - 52) / 65536.0).floor() % 255;

    print('time ${DateTime.now().millisecondsSinceEpoch - t}, $tac');

    print(bmp.length);

    return bmp;
  }
}

class _FractalIsolateParams {
  _FractalIsolateParams(this.xmin, this.xmax, this.ymin, this.ymax, this.poly);

  _FractalIsolateParams.fromList(List<num> list) {
    xmin = list[0];
    xmax = list[1];
    ymin = list[2];
    ymax = list[3];
    const offset = 4;
    if (list.length - offset == 2)
      poly = ComplexPoly2(list.skip(offset).take(2).toList().cast<double>());
    else if (list.length - offset == 3)
      poly = ComplexPoly3(list.skip(offset).take(3).toList().cast<double>());
    else if (list.length - offset == 4) poly = ComplexPoly4(list.skip(offset).take(4).toList().cast<double>());
  }

  double xmin;
  double xmax;
  double ymin;
  double ymax;
  ComplexPoly poly;

  List<num> toList() => [xmin, xmax, ymin, ymax, ...poly.terms];
}
