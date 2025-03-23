import 'package:flutter/material.dart';
import 'package:music_groups/ui/route/groups.dart';

class MusicGroupsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Участие музыкальных групп',
      theme: ThemeData(useMaterial3: false),
      home: GroupsRoute(),
    );
  }
}
