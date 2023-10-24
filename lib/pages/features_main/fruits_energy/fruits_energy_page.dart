import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_dev/dev_two_direction_table/dev_two_direction_table_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/images_private/fruit_image.dart';

const _cellWidth = 60.0;
const _cellHeight = 50.0;

// 凍結視窗
class FruitsEnergyPage extends StatefulWidget {
  const FruitsEnergyPage._();

  static const MyPageRoute route = ('/FruitsEnergyPage', _builder);
  static Widget _builder(dynamic args) {
    return const FruitsEnergyPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<FruitsEnergyPage> createState() => _FruitsEnergyPageState();
}

// 雙向滑動的 Table，各有優缺
// 1. InteractiveViewer (constrained 設為 false) (scroll both horizontally and vertically at the same time)
// 2. 包兩個 SingleChildScrollView (一個橫向一個縱向)

class _FruitsEnergyPageState extends State<FruitsEnergyPage> {

  // Page
  var _isInitialized = false;

  // Data
  final _fruitToLevels = <_FruitData>[];

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      for (final fruit in Fruit.values) {
        _fruitToLevels.add(
          _FruitData(
            fruit: fruit,
            levels: fruit.getLevels(),
          ),
        );
      }

      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return LoadingView();
    }

    final colCount = Fruit.values.length + 1;

    return Scaffold(
      appBar: buildAppBar(
        titleText: '樹果能量一覽'.xTr,
      ),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false), // 在 Desktop 下隱藏 Scrollbar (因為凍結視窗的實作原理是多個 ListView，預設會導致畫面有多個 Scrollbar)
        child: Column(
          children: [
            Expanded(
              child: MultiplicationTable(
                rowCount: 61,
                colCount: colCount,
                builder: (context, rowIndex, colIndex) {
                  if (colIndex == 0 && rowIndex >= 1) {
                    return Center(
                      child: Text('Lv. $rowIndex'),
                    );
                  }

                  if (colIndex == 0 && rowIndex == 0) {
                    return SizedBox();
                  }

                  if (rowIndex == 0 && colIndex >= 1) {
                    if (MyEnv.USE_DEBUG_IMAGE) {
                      return Center(
                        child: FruitImage(
                          fruit: _fruitToLevels[colIndex - 1].fruit,
                          width: 30,
                        ),
                      );
                    }
                  }

                  if (rowIndex >= 1 && colIndex >= 1) {
                    final level = _fruitToLevels[colIndex - 1].levels[rowIndex - 1];
                    return Center(
                      child: Text(
                        '${level.energy}',
                      ),
                    );
                  }

                  return Text(
                    '$rowIndex, $colIndex',
                  );
                },
                cellHeight: _cellHeight,
                cellWidths: [
                  100,
                  ...List.generate(colCount - 1, (index) => _cellWidth),
                ],
              ),
            ),
            if (kDebugMode) ...Hp.list(
              children: [
                const MySubHeader(titleText: '測試',),
                TextButton(
                  onPressed: () {
                    DevTwoDirectionTablePage.go(context);
                  },
                  child: const Text('Click'),
                ),
                const SizedBox(height: 12,),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FruitData {
  const _FruitData({
    required this.fruit,
    required this.levels,
  });

  final Fruit fruit;
  final List<FruitLevelInfo> levels;
}


