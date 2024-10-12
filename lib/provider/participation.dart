import 'dart:async';

import 'package:firebase/firebase.dart';
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
  List<MapEntry<int, Event>>? get sortedEvents {
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
    return database()
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
    return (await _getDbRefStatus(eventId, groupId).once('value'))
        .snapshot
        .val();
  }

  void setStatus(int eventId, int groupId, int status) {
    _getDbRefStatus(eventId, groupId).set(status);
  }

  void _fetchGroups() async {
    final event = await database().ref('v2/groups').once('value');
    final data = event.snapshot.val();
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
    _dataStreamSubscription =
        database().ref('v2').onValue.listen((event) async {
      final data = (event.snapshot.val() as Map)['tables'];
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
      }
      _isParticipationTableLoaded = true;
      notifyListeners();
    });
  }
}
