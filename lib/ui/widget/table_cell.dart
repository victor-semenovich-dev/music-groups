import 'package:flutter/material.dart';
import 'package:table_sticky_headers/table_sticky_headers.dart';

class MyTableCell extends StatelessWidget {
  MyTableCell.content({
    required this.child,
    this.cellDimensions = CellDimensions.base,
    this.colorBg = Colors.white,
    this.onTap,
  })  : cellWidth = cellDimensions.contentCellWidth!,
        cellHeight = cellDimensions.contentCellHeight!,
        _colorHorizontalBorder = Colors.black38,
        _colorVerticalBorder = Colors.black38,
        _padding = EdgeInsets.zero;

  MyTableCell.legend({
    this.child,
    this.cellDimensions = CellDimensions.base,
    this.colorBg = const Color(0xFFE0E0E0),
    this.onTap,
  })  : cellWidth = cellDimensions.stickyLegendWidth,
        cellHeight = cellDimensions.stickyLegendHeight,
        _colorHorizontalBorder = Colors.black38,
        _colorVerticalBorder = Colors.black38,
        _padding = EdgeInsets.zero;

  MyTableCell.stickyRow({
    required this.child,
    this.cellDimensions = CellDimensions.base,
    this.colorBg = const Color(0xFFE0E0E0),
    this.onTap,
  })  : cellWidth = cellDimensions.contentCellWidth!,
        cellHeight = cellDimensions.stickyLegendHeight,
        _colorHorizontalBorder = Colors.black38,
        _colorVerticalBorder = Colors.black38,
        _padding = EdgeInsets.zero;

  MyTableCell.stickyColumn({
    required this.child,
    this.cellDimensions = CellDimensions.base,
    this.colorBg = const Color(0xFFE0E0E0),
    this.onTap,
  })  : cellWidth = cellDimensions.stickyLegendWidth,
        cellHeight = cellDimensions.contentCellHeight!,
        _colorHorizontalBorder = Colors.black38,
        _colorVerticalBorder = Colors.black38,
        _padding = EdgeInsets.zero;

  final CellDimensions cellDimensions;

  final Widget? child;
  final Function? onTap;

  final double cellWidth;
  final double cellHeight;

  final Color colorBg;
  final Color _colorHorizontalBorder;
  final Color _colorVerticalBorder;

  final EdgeInsets _padding;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) onTap!();
      },
      child: Container(
        width: cellWidth,
        height: cellHeight,
        padding: _padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.center,
                // padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: child,
              ),
            ),
            Container(
              width: double.infinity,
              height: 1.1,
              color: _colorVerticalBorder,
            ),
          ],
        ),
        decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: _colorHorizontalBorder),
            ),
            color: colorBg),
      ),
    );
  }
}
