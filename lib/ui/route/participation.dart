import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:music_groups/data/participation_table.dart';
import 'package:music_groups/provider/participation.dart';
import 'package:music_groups/ui/widget/table_cell.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class ParticipationRoute extends StatelessWidget {
  final int groupId;

  const ParticipationRoute({Key? key, required this.groupId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const CellDimensions cellDimensions = CellDimensions.fixed(
      contentCellWidth: 100.0,
      contentCellHeight: 65.0,
      stickyLegendWidth: 150.0,
      stickyLegendHeight: 55.0,
    );
    return ChangeNotifierProvider<ParticipationProvider>(
      create: (context) => ParticipationProvider(),
      child: Consumer<ParticipationProvider>(
        builder: (context, provider, child) {
          final groups = provider.sortedGroups;
          final events = provider.sortedEvents;
          return Scaffold(
            appBar: AppBar(
              title:
                  Text(provider.participationTable?.title ?? 'Участие групп'),
            ),
            body: SafeArea(
              child: provider.isDataLoaded
                  ? StickyHeadersTable(
                      columnsLength: events?.length ?? 0,
                      rowsLength: groups?.length ?? 0,
                      columnsTitleBuilder: (i) => MyTableCell.stickyRow(
                        child: Text(events![i].value.title,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        cellDimensions: cellDimensions,
                      ),
                      rowsTitleBuilder: (i) => MyTableCell.stickyColumn(
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(groups![i].value.name,
                                    maxLines: groups[i].value.leader.isNotEmpty
                                        ? 1
                                        : 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                                if (groups[i].value.leader.isNotEmpty)
                                  AutoSizeText(
                                    '(${groups[i].value.leader})',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    minFontSize: 10,
                                    maxFontSize: 12,
                                  )
                              ],
                            ),
                          ),
                          cellDimensions: cellDimensions),
                      contentCellBuilder: (eventIndex, groupIndex) =>
                          MyTableCell.content(
                              child: _getCellWidget(
                                  context,
                                  provider,
                                  events![eventIndex].value,
                                  events[eventIndex].key,
                                  groups![groupIndex].key),
                              cellDimensions: cellDimensions),
                      legendCell: MyTableCell.legend(
                        cellDimensions: cellDimensions,
                        child: FutureBuilder<PackageInfo>(
                            future: PackageInfo.fromPlatform(),
                            builder: (context, info) {
                              final data = info.data;
                              if (data != null) {
                                return Text(
                                    "v${data.version} (${data.buildNumber})");
                              } else {
                                return Container();
                              }
                            }),
                      ),
                      cellDimensions: cellDimensions,
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
          );
        },
      ),
    );
  }

  Widget _getCellWidget(
    BuildContext context,
    ParticipationProvider provider,
    TableEvent event,
    int eventId,
    int groupId,
  ) {
    final groupStatus = (event.groups)[groupId];
    Color color = Colors.white;
    if (groupStatus == null) {
      color = Colors.white;
    } else {
      switch (groupStatus.status) {
        case GroupStatus.STATUS_CAN_PARTICIPATE:
          color = Colors.green;
          break;
        case GroupStatus.STATUS_CANNOT_PARTICIPATE:
          color = Colors.red[400]!;
          break;
        case GroupStatus.STATUS_APPOINTED:
          color = Colors.blue[300]!;
          break;
      }
    }
    return GestureDetector(
      onTap: () {
        if (groupId == this.groupId) {
          provider.toggleParticipation(eventId, groupId);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Можно отмечаться только в своих ячейках',
            ),
          ));
        }
      },
      onLongPress: () => provider.setStatus(
          eventId, groupId, GroupStatus.STATUS_CANNOT_PARTICIPATE),
      child: Container(
          width: double.infinity, height: double.infinity, color: color),
    );
  }
}
