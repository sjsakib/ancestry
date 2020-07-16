class Event {
  final double time;
  final String title;

  Event.fromJosn(Map<String, dynamic> json)
      : time = json['time'],
        title = json['title'];
}
