import 'package:flutter/material.dart';
import 'package:music_groups/data/participation_table.dart';
import 'package:music_groups/provider/participation.dart';
import 'package:music_groups/ui/widget/table_cell.dart';
import 'package:provider/provider.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class ParticipationRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const CellDimensions cellDimensions = CellDimensions(
      contentCellWidth: 100.0,
      contentCellHeight: 55.0,
      stickyLegendWidth: 150.0,
      stickyLegendHeight: 55.0,
    );
    return ChangeNotifierProvider<ParticipationProvider>(
      create: (context) => ParticipationProvider(),
      child: Consumer<ParticipationProvider>(
        builder: (context, provider, child) => Scaffold(
          appBar: AppBar(
            title: Text(provider.participationTable?.title ?? 'Участие групп'),
          ),
          body: SafeArea(
            child: provider.isDataLoaded
                ? StickyHeadersTable(
                    columnsLength:
                        provider.participationTable?.events?.length ?? 0,
                    rowsLength: provider.groups?.length ?? 0,
                    columnsTitleBuilder: (i) => MyTableCell.stickyRow(
                      child: Text(provider.participationTable.events[i].title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      cellDimensions: cellDimensions,
                    ),
                    rowsTitleBuilder: (i) => MyTableCell.stickyColumn(
                        // '${provider.groups[i].name}\n${provider.groups[i].leader}',
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(provider.groups[i].name,
                                  maxLines: provider.groups[i].leader.isNotEmpty
                                      ? 1
                                      : 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                              if (provider.groups[i].leader.isNotEmpty)
                                Text('(${provider.groups[i].leader})',
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
                                provider, eventIndex, groupIndex),
                            cellDimensions: cellDimensions),
                    legendCell:
                        MyTableCell.legend(cellDimensions: cellDimensions),
                    cellDimensions: cellDimensions,
                  )
                : Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }

  Widget _getCellWidget(
      ParticipationProvider provider, int eventIndex, int groupIndex) {
    final groupId = provider.groups[groupIndex].id;
    final event = provider.participationTable.events[eventIndex];
    final groupStatus = (event.groups ?? {})[groupId];
    Color color;
    if (groupStatus == null) {
      color = Colors.white;
    } else {
      switch (groupStatus.status) {
        case GroupStatus.STATUS_CAN_PARTICIPATE:
          color = Colors.green;
          break;
        case GroupStatus.STATUS_CANNOT_PARTICIPATE:
          color = Colors.red[400];
          break;
        case GroupStatus.STATUS_APPOINTED:
          color = Colors.blue[300];
          break;
      }
    }
    return GestureDetector(
      onTap: () => provider.toggleParticipation(eventIndex, groupId),
      onLongPress: () => provider.removeParticipation(eventIndex, groupId),
      child: Container(
          width: double.infinity, height: double.infinity, color: color),
    );
  }
}
