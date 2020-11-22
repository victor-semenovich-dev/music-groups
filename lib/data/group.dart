class Group {
  final int id;
  final String name;
  final String leader;
  final bool isActive;

  Group({this.id, this.name, this.leader, this.isActive});

  Group.fromMap(Map map)
      : id = map['id'],
        name = map['name'],
        leader = map['leader'],
        isActive = map['isActive'];

  @override
  String toString() {
    return '{id: $id, name: $name, leader: $leader, isActive: $isActive}';
  }
}
