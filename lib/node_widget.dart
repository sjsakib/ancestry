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
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: AssetImage(img),
          ),
          Text(name),
        ],
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
    var dx = min(len, _curveSize);
    canvas.translate(0, r);
    var paint = Paint()
      ..color = Colors.teal
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    var path = Path();
    if (dy != null) {
      path
        ..moveTo(0, dy)
        ..cubicTo(dx * .5, dy, dx * 0, 0, dx, 0);
    }
    path
      ..moveTo(dx, 0)
      ..lineTo(len, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
