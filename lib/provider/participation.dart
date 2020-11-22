import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:music_groups/data/group.dart';
import 'package:music_groups/data/participation_table.dart';

class ParticipationProvider extends ChangeNotifier {
  List<Group> groups;
  ParticipationTable participationTable;
  int _participationIndex;

  bool _isGroupsLoaded = false;
  bool _isParticipationTableLoaded = false;

  bool get isDataLoaded => _isGroupsLoaded && _isParticipationTableLoaded;

  ParticipationProvider() {
    _fetchGroups();
    _listenParticipationTable();
  }

  void toggleParticipation(int eventIndex, int groupId) async {
    final dbRef = database().ref(
        'participations/$_participationIndex/events/$eventIndex/groups/$groupId/status');
    int status = (await dbRef.once('value')).snapshot.val() ??
        GroupStatus.STATUS_CANNOT_PARTICIPATE;
    switch (status) {
      case GroupStatus.STATUS_CANNOT_PARTICIPATE:
        status = GroupStatus.STATUS_CAN_PARTICIPATE;
        break;
      case GroupStatus.STATUS_CAN_PARTICIPATE:
        status = GroupStatus.STATUS_CANNOT_PARTICIPATE;
        break;
    }
    await dbRef.set(status);
  }

  void removeParticipation(int eventIndex, int groupId) {
    final dbRef = database().ref(
        'participations/$_participationIndex/events/$eventIndex/groups/$groupId/status');
    dbRef.remove();
  }

  void _fetchGroups() async {
    final event = await database().ref('groups').once('value');
    final data = event.snapshot.val() as List;
    groups = data.map((e) => Group.fromMap(e)).toList();
    groups.sort((g1, g2) => g1.name.compareTo(g2.name));
    _isGroupsLoaded = true;
    notifyListeners();
  }

  void _listenParticipationTable() async {
    final event = await database().ref('participations').once('value');
    final data = event.snapshot.val() as List;
    Map map;
    for (int i = 0; i < data.length; i++) {
      if (data[i]['isActive']) {
        _participationIndex = i;
        map = data[i];
        break;
      }
    }
    if (_participationIndex != null && map != null) {
      participationTable = ParticipationTable.fromMap(map);
      database()
          .ref('participations/$_participationIndex')
          .onValue
          .listen((event) {
        participationTable = ParticipationTable.fromMap(event.snapshot.val());
        notifyListeners();
      });
    }
    _isParticipationTableLoaded = true;
    notifyListeners();
  }
}
