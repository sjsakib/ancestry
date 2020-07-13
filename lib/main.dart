import 'dart:convert';

import 'package:ancestry/node.dart';
import 'package:ancestry/node_widget.dart';
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
  List<Widget> nodes = <Widget>[];

  void initState() {
    super.initState();

    _loadData();
  }

  void _loadData() async {
    var dataStr = await rootBundle.loadString('data/data.json');

    setState(() {
      rootNode = Node.fromJosn(json.decode(dataStr), null);
    });
  }

  void addNode(Node node, double posY, double dy) {
    var posX = ((rootNode.emergence - node.emergence) / 1e4) + 20;
    var len = (node.emergence - node.extinction) / 1e4;
    nodes.add(
      Positioned(
        left: posX,
        top: posY,
        child: NodeWidget(
          name: node.name,
          len: len,
          dy: dy,
          img: node.img,
        ),
      ),
    );
    var newPosY = posY - (node.children.length * 50);
    print('node: ${node.name}, posX: $posX, posY $newPosY, len: $len');
    node.children.forEach(
      (child) {
        addNode(child, newPosY, posY - newPosY);
        newPosY += 200;
      },
    );
  }

  Widget build(context) {
    var size = MediaQuery.of(context).size;
    nodes = [];
    if (rootNode != null) addNode(rootNode, size.height / 2, 0);

    return Scaffold(
      body: GestureDetector(
        child: Stack(
          children: nodes,
        ),
      ),
    );
  }
}
