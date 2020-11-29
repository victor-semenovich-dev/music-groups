class Group {
  final String name;
  final String leader;
  final bool isActive;

  Group({this.name, this.leader, this.isActive});

  Group.fromMap(Map map)
      : name = map['name'],
        leader = map['leader'],
        isActive = map['isActive'];

  @override
  String toString() {
    return '{name: $name, leader: $leader, isActive: $isActive}';
  }
}
