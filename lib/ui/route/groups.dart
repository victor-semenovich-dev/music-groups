import 'package:flutter/material.dart';
import 'package:music_groups/provider/groups.dart';
import 'package:music_groups/ui/route/participation.dart';
import 'package:provider/provider.dart';

class GroupsRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupsProvider>(
      create: (context) => GroupsProvider(),
      child: Consumer<GroupsProvider>(builder: (context, provider, child) {
        debugPrint("${provider.sortedGroups?.length} groups");
        return Scaffold(
          appBar: AppBar(
            title: Text('Выбери группу'),
          ),
          body: SafeArea(
            child: ListView(
              children: (provider.sortedGroups ?? []).map((entry) {
                return ListTile(
                  title: Text(entry.value.name),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              ParticipationRoute(groupId: entry.key)),
                    );
                  },
                );
              }).toList(),
            ),
          ),
        );
      }),
    );
  }
}
