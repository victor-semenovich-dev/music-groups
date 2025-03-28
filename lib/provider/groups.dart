import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:music_groups/data/group.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui/route/participation.dart';

class GroupsProvider extends ChangeNotifier {
  Map<int, Group>? groups;
  List<MapEntry<int, Group>>? get sortedGroups {
    if (groups == null) return null;
    return groups!.entries.toList()
      ..sort((g1, g2) => g1.value.name.compareTo(g2.value.name));
  }

  bool _isGroupsLoaded = false;

  bool get isDataLoaded => _isGroupsLoaded;

  BuildContext context;
  SharedPreferences? prefs;

  GroupsProvider({required this.context}) {
    _initPrefs();
    _fetchGroups();
  }

  void _initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final savedGroupId = prefs?.getInt("groupId");
    if (savedGroupId != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ParticipationRoute(groupId: savedGroupId),
        ),
      );
    }
  }

  void selectGroup(int id) async {
    await prefs?.setInt("groupId", id);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ParticipationRoute(groupId: id),
      ),
    );
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
}
