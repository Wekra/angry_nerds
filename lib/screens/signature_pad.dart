import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

class SignaturePadPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignaturePadPageState();
  }
}

class SignaturePadPageState extends State<SignaturePadPage> {
  GlobalKey<SignatureState> signatureKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Signature(key: signatureKey),
      persistentFooterButtons: <Widget>[
        FlatButton(
          child: Text("Clear"),
          onPressed: () => signatureKey.currentState.clearPoints(),
        ),
        FlatButton(
          child: Text("Save"),
          onPressed: _finishWithCurrentSignature,
        )
      ],
    );
  }

  void _finishWithCurrentSignature() {
    ui.Image renderedImage = signatureKey.currentState.renderImage();
    renderedImage.toByteData(format: ui.ImageByteFormat.rawRgba).then((ByteData fullImageData) {
      Uint8List fullImageBytes = fullImageData.buffer.asUint8List();
      img.Image fullImage =
          img.Image.fromBytes(renderedImage.width, renderedImage.height, fullImageBytes, img.Image.RGBA);
      img.Image resizedImage = img.copyResize(fullImage, 300);
      List<int> compressedImageBytes = img.encodePng(resizedImage, level: 9);
      String compressedImageBase64 = base64.encode(compressedImageBytes);
      Navigator.pop(context, compressedImageBase64);
    });
  }
}

/// Based on main.dart taken from here:
/// https://github.com/vemarav/signature/blob/e86183866d3f90af3ef8ead21e8160c35137f07f/lib/main.dart
class Signature extends StatefulWidget {
  Signature({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SignatureState();
  }
}

/// [SignatureState] responsible for receives drag/touch events by draw/user
/// @_points stores the path drawn which is passed to
/// [SignaturePainter]#contructor to draw canvas
class SignatureState extends State<Signature> {
  List<Offset> _points = <Offset>[];

  /// [CustomPainter] has its own @canvas to pass our
  /// [ui.PictureRecorder] object must be passed to [Canvas]#constructor
  /// to capture the Image. This way we can pass @recorder to [Canvas]#contructor
  /// using @painter[SignaturePainter] we can call [SignaturePainter]#paint
  /// with the our newly created @canvas
  ui.Image renderImage() {
    ui.PictureRecorder recorder = ui.PictureRecorder();
    Canvas canvas = Canvas(recorder);
    SignaturePainter painter = SignaturePainter(points: _points);
    Size size = context.size;
    painter.paint(canvas, size);
    return recorder.endRecording().toImage(size.width.floor(), size.height.floor());
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          RenderBox _object = context.findRenderObject();
          Offset _locationPoints = _object.localToGlobal(details.globalPosition);
          _points = List.from(_points)..add(_locationPoints);
        });
      },
      onPanEnd: (DragEndDetails details) {
        setState(() {
          _points.add(null);
        });
      },
      child: CustomPaint(
        painter: SignaturePainter(points: _points),
        size: Size.infinite,
      ),
    );
  }

  void clearPoints() {
    setState(() {
      _points.clear();
    });
  }
}

/// [SignaturePainter] receives points through constructor
/// @points holds the drawn path in the form (x,y) offset;
/// This class responsible for drawing only
/// It won't receive any drag/touch events by draw/user.
class SignaturePainter extends CustomPainter {
  List<Offset> points = [];

  SignaturePainter({this.points});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Color(0xFF000000)
      ..strokeCap = StrokeCap.square
      ..strokeWidth = 5.0;

    for (int pointIndex = 0; pointIndex < points.length - 1; pointIndex++) {
      if (points[pointIndex] != null && points[pointIndex + 1] != null) {
        canvas.drawLine(points[pointIndex], points[pointIndex + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(SignaturePainter oldDelegate) {
    return oldDelegate.points != points;
  }
}
