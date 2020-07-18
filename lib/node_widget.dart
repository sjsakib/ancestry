import 'dart:math';
import 'dart:ui';

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
    var clipper = NodeClipper();
    return CustomPaint(
      painter: NodePainter(len, dy, clipper, highlight),
      child: ClipPath(
        clipper: clipper,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.blueGrey.withOpacity(.6),
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
              )),
        ),
      ),
    );
  }
}

class NodePainter extends CustomPainter {
  final double len;
  final double dy;

  final NodeClipper clipper;
  final bool highlight;

  final double _curveSize = 50;
  final double r = 28;

  NodePainter(this.len, this.dy, this.clipper, this.highlight);

  void paint(canvas, size) {
    canvas.drawShadow(clipper.getClip(size),
        highlight == true ? Colors.greenAccent : Colors.black, 1, false);
    var dx = min(len, _curveSize);
    canvas.translate(0, r);
    var paint = Paint()
      ..color = Colors.blueGrey.shade300
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

class NodeClipper extends CustomClipper<Path> {
  Path getClip(size) {
    return Path()
      ..addRRect(
        RRect.fromLTRBR(
          size.height - 8,
          12,
          size.width,
          size.height - 12,
          Radius.circular(8.0),
        ),
      )
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.height / 2, size.height / 2),
          radius: size.height / 2 - 4,
        ),
      );
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
