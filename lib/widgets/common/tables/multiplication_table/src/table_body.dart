import 'package:flutter/material.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';
import 'package:pokemon_sleep_tools/widgets/common/tables/multiplication_table/src/data.dart';

class TableBody extends StatefulWidget {
  const TableBody({
    super.key,
    required this.scrollController,
    required this.builder,
    required this.rowCount,
    required this.colCount,
    required this.cellWidths,
    required this.cellHeight,
  });

  final ScrollController scrollController;
  final CellBuilder builder;
  final int rowCount;
  final int colCount;
  final List<double> cellWidths;
  final double cellHeight;

  @override
  State<TableBody> createState() => _TableBodyState();
}

class _TableBodyState extends State<TableBody> {
  late LinkedScrollControllerGroup _controllers;
  late ScrollController _firstColumnController;
  late ScrollController _restColumnsController;

  @override
  void initState() {
    super.initState();
    _controllers = LinkedScrollControllerGroup();
    _firstColumnController = _controllers.addAndGet();
    _restColumnsController = _controllers.addAndGet();
  }

  @override
  void dispose() {
    _firstColumnController.dispose();
    _restColumnsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: widget.cellWidths[0],
          child: ListView(
            controller: _firstColumnController,
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            children: List.generate(widget.rowCount, (rowIndex) {
              return widget.builder(context, rowIndex, 0);
            }),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: widget.scrollController,
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            child: SizedBox(
              width: widget.cellWidths.sublist(1).reduce((v, e) => v + e),
              child: ListView(
                controller: _restColumnsController,
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                children: List.generate(widget.rowCount, (rowIndex) {
                  return Row(
                    children: List.generate(widget.colCount - 1, (colIndex) {
                      return widget.builder(context, rowIndex, colIndex + 1);
                    }),
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}