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

  if (time > 2e8) {
    return '${(time / 1e9).toStringAsFixed(1)}B';
  }
  if (time > 2e5) {
    return '${(time / 1e6).toStringAsFixed(1)}M';
  }
  if (time > 5e3) {
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
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              color: Colors.black.withOpacity(0),
            ),
          ),
        ),
        CustomPaint(
          painter: RulerPainter(
            scale: scale,
            offset: offset,
            maxTime: maxTime,
          ),
        ),
      ],
    );
  }
}

class RulerPainter extends CustomPainter {
  final double scale;
  final double offset;
  final double maxTime;

  RulerPainter({this.scale, this.offset, this.maxTime});

  void paint(canvas, size) {
    var paint = Paint()..color = Colors.blueGrey.withOpacity(.8);

    var shadowPath = Path()..addRect(Offset(0, 0) & size);
    canvas.drawShadow(shadowPath, Colors.black, 2, true);
    canvas.drawRect(Offset(0, 0) & size, paint);

    canvas.translate(0, 75);

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
        pos < size.width && time >= 0;
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
    return true;
  }
}
