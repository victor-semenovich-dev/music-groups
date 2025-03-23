import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:music_groups/provider/groups.dart';
import 'package:music_groups/ui/route/participation.dart';
import 'package:provider/provider.dart';

class GroupsRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GroupsProvider>(
      create: (context) => GroupsProvider(context: context),
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
                  onTap: () => provider.selectGroup(entry.key),
                );
              }).toList(),
            ),
          ),
        );
      }),
    );
  }
}
