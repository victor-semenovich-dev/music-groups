class ParticipationTable {
  final String title;
  final int timestamp;
  final bool isActive;
  final Map<int, TableEvent> events;

  List<MapEntry<int, TableEvent>> get sortedEvents => events.entries.toList()
    ..sort((e1, e2) => e1.value.timestamp.compareTo(e2.value.timestamp));

  ParticipationTable(
      {required this.title,
      required this.timestamp,
      required this.isActive,
      required this.events});

  factory ParticipationTable.fromMap(Map map) {
    final title = map['title'];
    final timestamp = map['timestamp'];
    final isActive = map['isActive'];
    final Map<int, TableEvent> events = {};

    final eventsData = map['events'];
    if (eventsData is List) {
      for (int i = 0; i < eventsData.length; i++) {
        if (eventsData[i] != null) {
          final event = TableEvent.fromMap(eventsData[i]);
          if (event.isActive) {
            events[i] = event;
          }
        }
      }
    } else if (eventsData is Map) {
      eventsData.forEach((key, value) {
        final id = int.parse(key as String);
        final event = TableEvent.fromMap(eventsData[id]);
        if (event.isActive) {
          events[id] = event;
        }
      });
    }

    return ParticipationTable(
        title: title, timestamp: timestamp, isActive: isActive, events: events);
  }

  @override
  String toString() {
    return '{title: $title, isActive: $isActive, events: $events}';
  }
}

class TableEvent {
  final String title;
  final int timestamp;
  final bool isActive;
  final Map<int, GroupStatus> groups;

  TableEvent(
      {required this.title,
      required this.timestamp,
      required this.isActive,
      required this.groups});

  factory TableEvent.fromMap(Map map) {
    final title = map['title'];
    final timestamp = map['timestamp'];
    final isActive = map['isActive'] ?? true;
    Map<int, GroupStatus> groups = {};
    if (map['groups'] is List) {
      for (int i = 0; i < map['groups'].length; i++) {
        if (map['groups'][i] != null) {
          groups[i] = GroupStatus.fromMap(map['groups'][i]);
        }
      }
    }
    if (map['groups'] is Map) {
      groups = (map['groups'] as Map).map((key, value) =>
          MapEntry(int.parse(key.toString()), GroupStatus.fromMap(value)));
    }
    return TableEvent(
        title: title, timestamp: timestamp, isActive: isActive, groups: groups);
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

  GroupStatus({required this.status});

  GroupStatus.fromMap(Map map) : status = map['status'];

  @override
  String toString() {
    return '{status: $status}';
  }
}
