import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_two_direction_table/dev_two_direction_table_page.dart';
import 'package:pokemon_sleep_tools/widgets/common/tables/multiplication_table/multiplication_table.dart';

class TableHead extends StatelessWidget {
  const TableHead({super.key,
    required this.scrollController,
    required this.builder,
    required this.count,
  });

  final ScrollController scrollController;
  final CellBuilder builder;
  final int count;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: cellWidth,
      child: Row(
        children: [
          Expanded(
            child: ListView(
              controller: scrollController,
              physics: const ClampingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: List.generate(count, (index) {
                return builder(context, 0, index);
              }),
            ),
          ),
        ],
      ),
    );
  }
}
