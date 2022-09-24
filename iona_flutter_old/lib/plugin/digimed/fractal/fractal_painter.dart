import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/gestures/events.dart';

import 'complex_poly.dart';
import 'fractal.dart';

class FractalWidget extends StatefulWidget {
  FractalWidget(this.fractal, this.depth);

  final double depth;
  final Fractal fractal;

  @override
  State<StatefulWidget> createState() => FractalState(depth);
}

class FractalState extends State<FractalWidget> with TickerProviderStateMixin {
  double _desiredDepth;
  double _currentDepth;
  double zoomLevel = 1;
  double xoff = 0;
  double yoff = 0;
  final focus = FocusNode();

  FractalState(_desiredDepth) {
    this._desiredDepth = _desiredDepth;
    this._currentDepth = _desiredDepth - 1.0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    FocusScope.of(context).requestFocus(focus);
  }

  @override
  void didUpdateWidget(FractalWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    this._desiredDepth = this.widget.depth;
  }

  @override
  Widget build(BuildContext context) {
    return RawKeyboardListener(
      focusNode: focus,
      onKey: onKeyEvent,
      child: FutureBuilder<List<ui.FrameInfo>>(
          future: Fractal(ComplexPoly4([99, 69, 16, 9]))
              .genImage(-zoomLevel + xoff, -zoomLevel + yoff, zoomLevel + xoff, zoomLevel + yoff)
              .then(doImaging),
          builder: (context, snapshot) {
            print("redo builder $zoomLevel");
            return CustomPaint(painter: FractalPainter(snapshot.data, this._currentDepth));
          }),
    );
  }

  void onKeyEvent(RawKeyEvent event) {
    bool isKeyDown;
    switch (event.runtimeType) {
      case RawKeyDownEvent:
        isKeyDown = true;
        Future.delayed(const Duration(seconds: 1), () {});
        break;
      case RawKeyUpEvent:
        isKeyDown = false;
        break;
      default:
        throw new Exception('Unexpected runtimeType of RawKeyEvent');
    }
    int keyCode;
    if (isKeyDown)
      switch (event.data.runtimeType) {
        case RawKeyEventDataMacOs:
          final RawKeyEventDataMacOs data = event.data;
          var panic = 0.1 * zoomLevel;
          setState(() {
            if (data.characters == '.') {
              zoomLevel *= 1.1;
            } else if (data.characters == ',') {
              zoomLevel /= 1.1;
            } else if (data.characters == 'w') {
              yoff += panic;
            } else if (data.characters == 's') {
              yoff -= panic;
            } else if (data.characters == 'a') {
              xoff -= panic;
            } else if (data.characters == 'd') {
              xoff += panic;
            }
          });
      }
  }

  Future<List<ui.FrameInfo>> doImaging(List<Uint8List> bytes) async {
    final out = <ui.FrameInfo>[];

    for (final ig in bytes) {
      final codec = await ui.instantiateImageCodec(ig);
      var img = await codec.getNextFrame();
      out.add(img);
    }

    return out;
  }
}

class FractalPainter extends CustomPainter {
  List<ui.FrameInfo> img;
  double _depth;

  FractalPainter(this.img, this._depth);

  void paint(Canvas canvas, Size size) {
    //img?.toByteData()?.then((b) => print(b.buffer.asUint8List().toString()));
    //canvas.drawColor(Colors.white, BlendMode.src);
    var i = 0;
    for (final frame in img) {
      if (frame != null)
        canvas.drawImage(
            frame.image, Offset((i % 2) * 400.0, (i > 1) ? 0.0 : 400.0), Paint()..blendMode = BlendMode.src);
      i++;
    }
  }

  @override
  bool shouldRepaint(FractalPainter oldDelegate) {
    return true;
  }
}
