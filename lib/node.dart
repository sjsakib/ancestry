class Node {
  final String name;
  final String img;
  final double emergence;
  final double extinction;
  final double dy;
  final double minScale;

  List<Node> children;
  final Node parent;

  Node.fromJosn(Map<String, dynamic> json, Node parent)
      : name = json['name'],
        img = json['img'],
        emergence = json['em'],
        extinction = json['ex'],
        dy = json['dy'],
        minScale = json['minScale'],
        parent = parent {
    children = json['children'].map<Node>(
      (child) => Node.fromJosn(child, this),
    ).toList();
  }
}
