import 'package:flutter/material.dart';
import 'package:music_groups/data/participation_table.dart';
import 'package:music_groups/provider/participation.dart';
import 'package:music_groups/ui/widget/table_cell.dart';
import 'package:provider/provider.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class ParticipationRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const CellDimensions cellDimensions = CellDimensions.fixed(
      contentCellWidth: 100.0,
      contentCellHeight: 55.0,
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
                                  Text('(${groups[i].value.leader})',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12))
                              ],
                            ),
                          ),
                          cellDimensions: cellDimensions),
                      contentCellBuilder: (eventIndex, groupIndex) =>
                          MyTableCell.content(
                              child: _getCellWidget(
                                  provider,
                                  events![eventIndex].value,
                                  events[eventIndex].key,
                                  groups![groupIndex].key),
                              cellDimensions: cellDimensions),
                      legendCell:
                          MyTableCell.legend(cellDimensions: cellDimensions),
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
      ParticipationProvider provider, Event event, int eventId, int groupId) {
    final groupStatus = (event.groups ?? {})[groupId];
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
      onTap: () => provider.toggleParticipation(eventId, groupId),
      onLongPress: () => provider.removeParticipation(eventId, groupId),
      child: Container(
          width: double.infinity, height: double.infinity, color: color),
    );
  }
}
