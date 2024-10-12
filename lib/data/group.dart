class Group {
  final String name;
  final String leader;
  final bool isActive;

  Group({required this.name, required this.leader, required this.isActive});

  Group.fromMap(Map map)
      : name = map['name'],
        leader = map['leader'],
        isActive = map['isActive'];

  @override
  String toString() {
    return '{name: $name, leader: $leader, isActive: $isActive}';
  }
}
