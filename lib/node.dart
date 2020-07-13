class Node {
  final String name;
  final String img;
  final double emergence;
  final double extinction;

  List<Node> children;
  final Node parent;

  Node.fromJosn(Map<String, dynamic> json, Node parent)
      : name = json['name'],
        img = json['img'],
        emergence = json['em'],
        extinction = json['ex'],
        parent = parent {
    children = json['children'].map<Node>(
      (child) => Node.fromJosn(child, this),
    ).toList();
  }
}
