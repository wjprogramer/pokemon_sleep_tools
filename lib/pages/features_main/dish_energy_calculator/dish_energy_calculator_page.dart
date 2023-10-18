import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/features_main/dish_list/dish_list_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';

import '../../../widgets/sleep/images/images.dart';

class DishEnergyCalculatorPage extends StatefulWidget {
  const DishEnergyCalculatorPage._();

  static const MyPageRoute route = ('/DishEnergyCalculatorPage', _builder);
  static Widget _builder(dynamic args) {
    return const DishEnergyCalculatorPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<DishEnergyCalculatorPage> createState() => _DishEnergyCalculatorPageState();
}

class _DishEnergyCalculatorPageState extends State<DishEnergyCalculatorPage> {

  // Step 1. Dish
  final _dishField = TextEditingController();
  Dish? _dish;
  /// FIXME: 先固定用 30 級，因為「食譜等級加成」好像沒有固定公式可以計算，只能用表格查
  var _dishLevel = 30;

  // Step 2. 主要食材需求
  var _requiredIngredientCounts = <(Ingredient, int)>[];

  // Step 3. 副食材需求
  var _subIngredientCounts = <Ingredient, int>{};

  @override
  void initState() {
    super.initState();
    for (var ingredient in Ingredient.values) {
      _subIngredientCounts[ingredient] = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final levelBonus = _getMainIngredientsBonus();
    final ingredientResultData = <_IngredientData>[
      ..._requiredIngredientCounts.map((e) => _IngredientData(
        ingredient: e.$1,
        count: e.$2,
        isMain: true,
        levelBonus: levelBonus,
      )),
      ..._subIngredientCounts.entries.where((element) => element.value > 0).map((e) => _IngredientData(
        ingredient: e.key,
        count: e.value,
        isMain: false,
        levelBonus: levelBonus,
      )),
    ];
    final totalCount = ingredientResultData.isEmpty ? 0.0 : ingredientResultData.map((e) => e.count).reduce((value, element) => value + element);
    final totalEnergy = ingredientResultData.isEmpty ? 0.0 : ingredientResultData.map((e) => e.totalEnergy).reduce((value, element) => value + element);
    final totalEnergyWithBonus = ingredientResultData.isEmpty ? 0.0 : ingredientResultData.map((e) => e.totalEnergyWithBonus).reduce((value, element) => value + element);

    return Scaffold(
      appBar: buildAppBar(
        titleText: '料理能量計算器'.xTr,
      ),
      body: buildListView(
        children: [
          ...Hp.list(
            children: [
              MySubHeader(
                titleText: '選擇食譜與等級',
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () async {
                  final res = await DishListPage.pick(context);
                  if (res == null) {
                    return;
                  }

                  _dish = res.$1;
                  // _dishLevel = res.$2;
                  _dishField.text = '${_dish!.nameI18nKey.xTr}，等級：$_dishLevel';
                  _requiredIngredientCounts = _dish!.getIngredients();
                  setState(() { });
                },
                child: IgnorePointer(
                  child: TextField(
                    controller: _dishField,
                    decoration: InputDecoration(
                      prefixIcon: _dish == null ? null : Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: DishImage(
                          dish: _dish!,
                          width: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Gap.sm,
              Text(
                '目前先暫時固定使用 30 等級作為依據', style: TextStyle(color: greyColor3),
              ),
              if (_dish != null) ...[
                MySubHeader(
                  titleText: '主要食材',
                ),
                if (_requiredIngredientCounts.isEmpty)
                  Text('t_none'.xTr)
                else ..._requiredIngredientCounts.map((e) {
                  final ingredient = e.$1;
                  final count = e.$2;
                  return Padding(
                    padding: const EdgeInsets.only(top: 4, bottom: 2),
                    child: Row(
                      children: [
                        if (MyEnv.USE_DEBUG_IMAGE)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: IngredientImage(
                              ingredient: ingredient,
                              width: 30,
                            ),
                          ),
                        Text(
                          '${ingredient.nameI18nKey.xTr} x $count',
                        ),
                      ],
                    ),
                  );
                }),
                MySubHeader(
                  titleText: '額外食材',
                ),
                ...Ingredient.values.map((ingredient) => Row(
                  children: [
                    if (MyEnv.USE_DEBUG_IMAGE)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: IngredientImage(
                          ingredient: ingredient,
                          width: 30,
                        ),
                      ),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          text: '${ingredient.nameI18nKey.xTr}',
                          children: [
                            TextSpan(
                              text: ' x ${_subIngredientCounts[ingredient]}',
                              style: TextStyle(
                                color: _subIngredientCounts[ingredient] != 0 ? null : greyColor2,
                              ),
                            ),
                          ]
                        ),
                      ),
                    ),
                    IncrementValueButton(
                      onChanged: (num value) {
                        if (_subIngredientCounts[ingredient]! <= 0) {
                          return;
                        }
                        _subIngredientCounts[ingredient] = (_subIngredientCounts[ingredient]! - value.toInt()).clamp(0, 99);
                        setState(() { });
                      },
                      child: IgnorePointer(
                        child: IconButton(
                          onPressed: () { },
                          icon: Icon(Icons.remove),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ),
                    IncrementValueButton(
                      onChanged: (num value) {
                        if (_subIngredientCounts[ingredient]! >= 99) {
                          return;
                        }
                        _subIngredientCounts[ingredient] = (_subIngredientCounts[ingredient]! + value.toInt()).clamp(0, 99);
                        setState(() { });
                      },
                      child: IgnorePointer(
                        child: IconButton(
                          onPressed: () { },
                          icon: Icon(Icons.add),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                    ),
                  ],
                )),
                MySubHeader(
                  titleText: '計算結果',
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('食材')),
                      DataColumn(label: Text('等階加成')),
                      DataColumn(label: Text('等級加成')),
                      DataColumn(label: Text('數量')),
                      DataColumn(label: Text('加成前能量')),
                      DataColumn(label: Text('加成後能量')),
                      DataColumn(label: Text('備註')),
                    ],
                    rows: [
                      ...ingredientResultData.map((e) => _buildRow(
                        e, levelBonus,
                      )),
                      DataRow(
                        cells: [
                          DataCell(Text('合計')),
                          DataCell(Text('')),
                          DataCell(Text('')),
                          DataCell(Text(Display.numInt(totalCount))),
                          DataCell(Text(Display.numInt(totalEnergy))),
                          DataCell(Text(Display.numInt(totalEnergyWithBonus))),
                          DataCell(Text('')),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          Gap.trailing,
        ],
      ),
    );
  }

  double _getMainIngredientsBonus() {
    if (_requiredIngredientCounts.isEmpty) {
      return 0;
    }

    // 主要食材材料數少於10的食譜: 6%
    // 主要食材材料數1x的食譜：11%
    // 主要食材材料數2x的食譜：17%
    // 主要食材材料數3x的食譜：25%
    // 主要食材材料數5x的食譜：35%
    final count = _requiredIngredientCounts.map((e) => e.$2).reduce((value, element) => value + element);
    return count < 10 ? 0.06
        : count < 20 ? 0.11
        : count < 30 ? 0.17
        : count < 50 ? 0.25
        : 0.35;
  }

  _buildRow(_IngredientData data, double levelBonus) {
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              if (MyEnv.USE_DEBUG_IMAGE)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: IngredientImage(
                    ingredient: data.ingredient,
                    width: 30,
                  ),
                ),
              Text(data.ingredient.nameI18nKey.xTr),
            ],
          ),
        ),
        DataCell(
          Text(
              data.isMain ? '${(levelBonus * 100).toInt()}%' : '0%'
          ),
        ),
        DataCell(
          Text('60%'),
        ),
        DataCell(
          Text(data.count.toString()),
        ),
        DataCell(
          Text(Display.numInt(data.totalEnergy)),
        ),
        DataCell(
          Text(
            Display.numInt(data.totalEnergyWithBonus),
          ),
        ),
        DataCell(
          Text(data.isMain ? '主要食材' : '額外食材'),
        ),
      ],
    );
  }
}

class _IngredientData {
  _IngredientData({
    required this.ingredient,
    required this.count,
    required this.isMain,
    required this.levelBonus,
  }) {
    final tmpTotalEnergyWithBonus = isMain
        ? ingredient.energy * count * (1 + levelBonus) * 1.6 // FIXME: 1.6 為等級加成，目前固定為 30 等
        : ingredient.energy * count;
    totalEnergyWithBonus = tmpTotalEnergyWithBonus.toInt();

    totalEnergy = ingredient.energy * count;
  }

  Ingredient ingredient;
  int count;
  bool isMain;
  double levelBonus;
  int totalEnergy = 0;
  int totalEnergyWithBonus = 0;
}


