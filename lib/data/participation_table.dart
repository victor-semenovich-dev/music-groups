class ParticipationTable {
  final String title;
  final bool isActive;
  final List<Event> events;

  ParticipationTable({this.title, this.isActive, this.events});

  ParticipationTable.fromMap(Map map)
      : title = map['title'],
        isActive = map['isActive'],
        events =
            (map['events'] as List)?.map((e) => Event.fromMap(e))?.toList();

  @override
  String toString() {
    return '{title: $title, isActive: $isActive, events: $events}';
  }
}

class Event {
  final String title;
  final Map<int, GroupStatus> groups;

  Event({this.title, this.groups});

  factory Event.fromMap(Map map) {
    final title = map['title'];
    Map<int, GroupStatus> groups;
    if (map['groups'] is List) {
      groups = {};
      for (int i = 0; i < map['groups'].length; i++) {
        if (map['groups'][i] != null) {
          groups[i] = GroupStatus.fromMap(map['groups'][i]);
        }
      }
    }
    if (map['groups'] is Map) {
      groups = (map['groups'] as Map)?.map((key, value) =>
          MapEntry(int.parse(key.toString()), GroupStatus.fromMap(value)));
    }
    return Event(title: title, groups: groups);
  }

  @override
  String toString() {
    return '{title: $title, groups: $groups}';
  }
}

class GroupStatus {
  static const int STATUS_CANNOT_PARTICIPATE = 0;
  static const int STATUS_CAN_PARTICIPATE = 1;
  static const int STATUS_APPOINTED = 2;

  final int status;

  GroupStatus({this.status});

  GroupStatus.fromMap(Map map) : status = map['status'];

  @override
  String toString() {
    return '{status: $status}';
  }
}
