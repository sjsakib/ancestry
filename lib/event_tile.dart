import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EventTile extends StatelessWidget {
  final String title;

  EventTile(this.title);

  Widget build(context) {
    var clipper = EventClipper();
    return CustomPaint(
      painter: EventPainter(clipper),
      child: ClipPath(
        clipper: clipper,
        child: Container(
          padding: EdgeInsets.only(top: 18, left: 8, right: 8, bottom: 8),
          decoration: BoxDecoration(
            color: Colors.blueGrey,
          ),
          child: Text(title,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Colors.white)),
        ),
      ),
    );
  }
}

class EventClipper extends CustomClipper<Path> {
  Path getClip(size) {
    var h = 10.0;
    var s = 8.0;
    return Path()
      ..addRRect(
        RRect.fromLTRBR(0, h, size.width, size.height, Radius.circular(8.0)),
      )
      ..moveTo(s, h)
      ..cubicTo(s, h / 2, h / 2 + s, 0, h*.8 + s, 0)
      ..cubicTo(s, h, h + s, h, h * 2 + s, h);
      // ..lineTo(s + h / 2, 0)
      // ..lineTo(s + h, h);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class EventPainter extends CustomPainter {
  final EventClipper clipper;
  EventPainter(this.clipper);
  void paint(canvas, size) {
    var path = clipper.getClip(size);
    canvas.drawShadow(path, Colors.black, 4, false);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
