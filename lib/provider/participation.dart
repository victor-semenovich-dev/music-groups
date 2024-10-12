import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:music_groups/data/group.dart';
import 'package:music_groups/data/participation_table.dart';

class ParticipationProvider extends ChangeNotifier {
  Map<int, Group>? groups;
  List<MapEntry<int, Group>>? get sortedGroups {
    if (groups == null) return null;
    return groups!.entries.toList()
      ..sort((g1, g2) => g1.value.name.compareTo(g2.value.name));
  }

  ParticipationTable? participationTable;
  List<MapEntry<int, TableEvent>>? get sortedEvents {
    if (participationTable == null) return null;
    return participationTable!.sortedEvents;
  }

  int? _tableId;

  bool _isGroupsLoaded = false;
  bool _isParticipationTableLoaded = false;

  bool get isDataLoaded => _isGroupsLoaded && _isParticipationTableLoaded;

  StreamSubscription? _dataStreamSubscription;

  ParticipationProvider() {
    _fetchGroups();
    _listenParticipationTable();
  }

  @override
  void dispose() {
    super.dispose();
    _dataStreamSubscription?.cancel();
  }

  DatabaseReference _getDbRefStatus(int eventId, int groupId) {
    return FirebaseDatabase.instance
        .ref('v2/tables/$_tableId/events/$eventId/groups/$groupId/status');
  }

  void toggleParticipation(int eventId, int groupId) async {
    switch (await getStatus(eventId, groupId)) {
      case GroupStatus.STATUS_CAN_PARTICIPATE:
        removeParticipation(eventId, groupId);
        break;
      case GroupStatus.STATUS_CANNOT_PARTICIPATE:
        setStatus(eventId, groupId, GroupStatus.STATUS_CAN_PARTICIPATE);
        break;
      case null:
        setStatus(eventId, groupId, GroupStatus.STATUS_CAN_PARTICIPATE);
        break;
    }
  }

  void removeParticipation(int eventId, int groupId) {
    _getDbRefStatus(eventId, groupId).remove();
  }

  Future<int?> getStatus(int eventId, int groupId) async {
    final ref = _getDbRefStatus(eventId, groupId);
    final status = (await ref.get()).value;
    if (status is int) {
      return status;
    }
    return null;
  }

  void setStatus(int eventId, int groupId, int status) {
    _getDbRefStatus(eventId, groupId).set(status);
  }

  void _fetchGroups() async {
    final event = await FirebaseDatabase.instance.ref('v2/groups').get();
    final data = event.value;
    groups = {};
    if (data is List) {
      for (int i = 0; i < data.length; i++) {
        if (data[i] != null) {
          groups?[i] = Group.fromMap(data[i]);
        }
      }
    } else if (data is Map) {
      data.forEach((key, value) {
        final id = int.parse(key as String);
        groups?[id] = Group.fromMap(data[key]);
      });
    }
    _isGroupsLoaded = true;
    notifyListeners();
  }

  void _listenParticipationTable() async {
    final event = await FirebaseDatabase.instance.ref('v2/tables').get();
    final data = event.value;
    Map? map;
    if (data is List) {
      for (int i = 0; i < data.length; i++) {
        if (data[i] != null && data[i]['isActive']) {
          _tableId = i;
          map = data[i];
          break;
        }
      }
    } else if (data is Map) {
      for (MapEntry entry in data.entries) {
        if (entry.value['isActive']) {
          _tableId = int.parse(entry.key as String);
          map = entry.value;
        }
      }
    }
    if (_tableId != null && map != null) {
      participationTable = ParticipationTable.fromMap(map);
      _dataStreamSubscription = FirebaseDatabase.instance
          .ref('v2/tables/$_tableId')
          .onValue
          .listen((event) {
        final value = event.snapshot.value;
        if (value is Map) {
          participationTable = ParticipationTable.fromMap(value);
          notifyListeners();
        }
      });
    }
    _isParticipationTableLoaded = true;
    notifyListeners();
  }
}
