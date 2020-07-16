import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NodeWidget extends StatelessWidget {
  final double dy;
  final String name;
  final String img;
  final double len;
  final bool highlight;

  NodeWidget({this.name, this.img, this.len, this.dy, this.highlight});

  Widget build(context) {
    return CustomPaint(
      painter: NodePainter(len, dy),
      child: InkWell(
        onTap: () {
          print(name);
        },
        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.blueGrey.withAlpha(200),
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: highlight == true
                ? [
                    BoxShadow(
                      color: Colors.green.withOpacity(.5),
                      blurRadius: 5,
                      spreadRadius: 1,
                      offset: Offset(1, 1),
                    )
                  ]
                : kElevationToShadow[1],
          ),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: AssetImage(img),
                backgroundColor: Colors.blueGrey,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  name,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NodePainter extends CustomPainter {
  final double len;
  final double dy;

  final double _curveSize = 50;
  final double r = 28;

  NodePainter(this.len, this.dy);

  void paint(canvas, size) {
    var dx = min(len, _curveSize);
    canvas.translate(0, r);
    var paint = Paint()
      ..color = Colors.blueGrey
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
