import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:pokemon_sleep_tools/widgets/common/tables/multiplication_table/src/data.dart';
import 'package:pokemon_sleep_tools/widgets/common/tables/multiplication_table/src/table_body.dart';
import 'package:pokemon_sleep_tools/widgets/common/tables/multiplication_table/src/table_cell.dart';
import 'package:pokemon_sleep_tools/widgets/common/tables/multiplication_table/src/table_head.dart';

class MultiplicationTable extends StatefulWidget {
  const MultiplicationTable({
    super.key,
    required this.rowCount,
    required this.colCount,
    required this.builder,
    required this.cellHeight,
    required this.cellWidths,
  });

  final int rowCount;
  final int colCount;
  final CellBuilder builder;
  final double cellHeight;
  final List<double> cellWidths;

  @override
  State<MultiplicationTable> createState() => _MultiplicationTableState();
}

class _MultiplicationTableState extends State<MultiplicationTable> {
  late LinkedScrollControllerGroup _controllers;
  late ScrollController _headController;
  late ScrollController _bodyController;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _headController = _controllers.addAndGet();
    _bodyController = _controllers.addAndGet();
  }

  @override
  void dispose() {
    _headController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableHead(
          scrollController: _headController,
          count: widget.colCount,
          builder: (context, rowIndex, colIndex) {
            return MultiplicationTableCell(
              height: widget.cellHeight,
              width: widget.cellWidths[colIndex],
              color: Colors.yellow.withOpacity(0.3),
              child: widget.builder(context, rowIndex, colIndex),
            );
          },
        ),
        Expanded(
          child: TableBody(
            scrollController: _bodyController,
            rowCount: widget.rowCount - 1,
            colCount: widget.colCount,
            cellHeight: widget.cellHeight,
            cellWidths: widget.cellWidths,
            builder: (context, rowIndex, colIndex) {
              return MultiplicationTableCell(
                height: widget.cellHeight,
                width: widget.cellWidths[colIndex],
                color: colIndex == 0 ? Colors.yellow.withOpacity(0.3) : null,
                child: widget.builder(context, rowIndex + 1, colIndex),
              );
            },
          ),
        ),
      ],
    );
  }
}