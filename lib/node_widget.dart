import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NodeWidget extends StatelessWidget {
  final double dy;
  final String name;
  final String img;
  final double len;

  NodeWidget({this.name, this.img, this.len, this.dy});

  Widget build(context) {
    return CustomPaint(
      painter: NodePainter(len, dy),
      child: Container(
        margin: EdgeInsets.only(bottom: 50),
        child: Column(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage(img),
            ),
            Text(name),
          ],
        ),
      ),
    );
  }
}

class NodePainter extends CustomPainter {
  final double len;
  final double dy;

  final double _curveSize = 50;
  final double r = 20;

  NodePainter(this.len, this.dy);

  void paint(canvas, size) {
    canvas.translate(-r, r);
    var paint = Paint()
      ..color = Colors.teal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    var path = Path();
    if (dy != null && dy != 0) {
      path
        ..moveTo(0, dy)
        ..cubicTo(_curveSize * .5, dy, _curveSize * 0, 0, _curveSize, 0);
    }
    path
      ..moveTo(_curveSize, 0)
      ..lineTo(max(_curveSize, len), 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
