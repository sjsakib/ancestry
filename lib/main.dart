import 'dart:convert';

import 'package:ancestry/event.dart';
import 'package:ancestry/event_tile.dart';
import 'package:ancestry/node.dart';
import 'package:ancestry/node_widget.dart';
import 'package:ancestry/ruler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(Ancestry());
}

class Ancestry extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Node rootNode;
  List<Event> events = [];
  Offset delta = Offset(10, -200);
  double scale = 4e4;

  // gesture state
  Offset initFocalPoint = Offset(0, 0);
  Offset initDelta = Offset(0, 0);
  double initScale = 1.0;

  List<Widget> nodes = <Widget>[];

  void initState() {
    super.initState();

    _loadData();
  }

  void _loadData() async {
    var dataStr = await rootBundle.loadString('data/data.json');
    var eventsStr = await rootBundle.loadString('data/events.json');

    setState(() {
      rootNode = Node.fromJosn(json.decode(dataStr), null);
      events = json
          .decode(eventsStr)
          .map<Event>((event) => Event.fromJosn(event))
          .toList();
    });
  }

  void addNode(Node node, double posY, double dy, bool highlight) {
    var posX = ((rootNode.emergence - node.emergence) / scale) + delta.dx;
    var len = (node.emergence - node.extinction) / scale;
    nodes.add(
      Positioned(
        left: posX,
        top: posY,
        child: NodeWidget(
          name: node.name,
          len: len,
          dy: dy,
          img: node.img,
          highlight: highlight,
        ),
      ),
    );
    var newPosY = posY + (node.children.length * 50);
    for (var i = node.children.length - 1; i >= 0; i--) {
      var child = node.children[i];

      if (child.minScale != null && child.minScale < scale) return;

      if (child.dy == null) {
        addNode(child, newPosY, posY - newPosY, i == node.children.length-1);
      } else {
        addNode(child, posY + child.dy, -child.dy, i == node.children.length-1);
      }
      newPosY -= 200;
    }
  }

  Widget build(context) {
    var size = MediaQuery.of(context).size;
    nodes = [];

    if (rootNode != null && events != null) {
      events.forEach((event) {
        var posX = ((rootNode.emergence - event.time) / scale) + delta.dx;
        nodes.add(Positioned(
          left: posX - 13,
          top: 80,
          child: EventTile(event.title),
        ));
      });
      nodes.add(
        Positioned(
          left: 0,
          width: size.width,
          height: 75,
          child: Ruler(
            offset: delta.dx,
            scale: scale,
            maxTime: rootNode.emergence,
          ),
        ),
      );
      addNode(rootNode, size.height / 2 + delta.dy, 0, true);
    }

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onScaleStart: (data) {
          initDelta = delta;
          initFocalPoint = data.focalPoint;
          initScale = scale;
        },
        onScaleUpdate: (data) {
          setState(() {
            scale = initScale * (1 / data.scale);
            delta = initDelta + (data.focalPoint - initFocalPoint);
            delta = (delta - data.focalPoint).scale(data.scale, 1) +
                data.focalPoint;
          });
        },
        child: Center(
          child: Stack(
            children: nodes.reversed.toList(),
          ),
        ),
      ),
    );
  }
}
