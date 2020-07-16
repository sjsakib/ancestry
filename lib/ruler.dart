import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

int log(double x) {
  var ret = 0;
  while (x > 1) {
    ret += 1;
    x = (x ~/ 2).toDouble();
  }
  return ret;
}

String formatTime(double time) {
  if (time < 0) time *= -1;
  if (time > 2e5) {
    return '${(time / 1e6).toStringAsFixed(1)}M';
  } else if (time > 1e3) {
    return '${(time / 1e3).toStringAsFixed(1)}K';
  }
  return '${time.toInt()}';
}

class Ruler extends StatelessWidget {
  final double scale;
  final double offset;
  final double maxTime;

  Ruler({this.scale, this.offset, this.maxTime});

  Widget build(context) {
    var width = MediaQuery.of(context).size.width;
    return CustomPaint(
      painter: RulerPainter(
        scale: scale,
        offset: offset,
        width: width,
        maxTime: maxTime,
      ),
    );
  }
}

class RulerPainter extends CustomPainter {
  final double scale;
  final double offset;
  final double maxTime;
  final double width;

  RulerPainter({this.scale, this.offset, this.width, this.maxTime});

  void paint(canvas, size) {
    canvas.translate(0, 75);
    var paint = Paint()..color = Colors.blueGrey;

    var shadowPath = Path()
      ..lineTo(0, -75)
      ..lineTo(width, -75)
      ..lineTo(width, 0)
      ..lineTo(0, 0);
    canvas.drawShadow(shadowPath, Colors.black, 4, true);
    canvas.drawRect(Offset(0, 0) & Size(width, -100), paint);

    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white;

    var timeInterval = ((1 << log(scale)) * 20).toDouble();
    var interval = timeInterval / scale;

    var i = (maxTime / scale + offset) ~/ interval + 2;
    var pos = (maxTime / scale) - i * interval + offset;
    var time = i * timeInterval;

    for (;
        pos < width && time >= 0;
        pos += interval, i -= 1, time = i * timeInterval) {
      var height = 10.0;

      if (i % 4 == 0) {
        height = 20;

        paint.strokeWidth = 2;
        var _textPainter = TextPainter(
          text: TextSpan(
            text: formatTime(time),
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          textAlign: TextAlign.center,
          textDirection: TextDirection.ltr,
        );
        _textPainter.layout(minWidth: interval * 4);
        _textPainter.paint(canvas, Offset(pos - interval * 2, -height * 2));
      } else {
        paint.strokeWidth = 1;
      }

      canvas.drawLine(
        Offset(pos, 0),
        Offset(pos, -height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
