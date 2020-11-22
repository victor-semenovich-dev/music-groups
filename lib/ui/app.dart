import 'package:flutter/material.dart';
import 'package:music_groups/ui/route/participation.dart';

class MusicGroupsApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Участие музыкальных групп',
      home: ParticipationRoute(),
    );
  }
}
