class ParticipationTable {
  final String title;
  final int timestamp;
  final bool isActive;
  final Map<int, Event> events;

  List<MapEntry<int, Event>> get sortedEvents => events.entries.toList()
    ..sort((e1, e2) => e1.value.timestamp.compareTo(e2.value.timestamp));

  ParticipationTable({this.title, this.timestamp, this.isActive, this.events});

  factory ParticipationTable.fromMap(Map map) {
    final title = map['title'];
    final timestamp = map['timestamp'];
    final isActive = map['isActive'];
    final Map<int, Event> events = {};

    final eventsData = map['events'];
    if (eventsData is List) {
      for (int i = 0; i < eventsData.length; i++) {
        if (eventsData[i] != null) {
          events[i] = Event.fromMap(eventsData[i]);
        }
      }
    } else if (eventsData is Map) {
      eventsData.forEach((key, value) {
        final id = int.parse(key as String);
        events[id] = Event.fromMap(eventsData[id]);
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

class Event {
  final String title;
  final int timestamp;
  final Map<int, GroupStatus> groups;

  Event({this.title, this.timestamp, this.groups});

  factory Event.fromMap(Map map) {
    final title = map['title'];
    final timestamp = map['timestamp'];
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
    return Event(title: title, timestamp: timestamp, groups: groups);
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
