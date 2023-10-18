import 'package:flutter/material.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/styles/colors/colors.dart';
import 'package:pokemon_sleep_tools/view_models/field_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/images/fruit_image.dart';
import 'package:provider/provider.dart';

/// TOOD: 初始值

class _Args {
  _Args({
    required this.field,
  });

  final PokemonField field;
}

class FieldEditPage extends StatefulWidget {
  const FieldEditPage._(this._args);

  static const MyPageRoute route = ('/FieldEditPage', _builder);
  static Widget _builder(dynamic args) {
    return FieldEditPage._(args);
  }

  static void go(BuildContext context, PokemonField field) {
    context.nav.push(
      route,
      arguments: _Args(
        field: field,
      ),
    );
  }

  final _Args _args;

  @override
  State<FieldEditPage> createState() => _FieldEditPageState();
}

class _FieldEditPageState extends State<FieldEditPage> {
  PokemonField get _field => widget._args.field;
  FieldViewModel get _fieldViewModel => context.read<FieldViewModel>();

  final _fruitOf = <Fruit>{};

  @override
  void initState() {
    super.initState();
    final fieldItem = _fieldViewModel.getItem(_field);
    _fruitOf.addAll(fieldItem.fruits);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        titleText: _field.nameI18nKey.xTr,
      ),
      body: ListView(
        children: [
          ...Hp.list(
            children: [
              if (_field == PokemonField.f1) ...[
                MySubHeader(
                  titleText: '自訂樹果 ${_fruitOf.length}/3',
                ),
                Wrap(
                  spacing: 4,
                  children: [
                    if (MyEnv.USE_DEBUG_IMAGE) ...Fruit.values.map((fruit) => IconButton(
                      onPressed: () => _toggleFruit(fruit),
                      tooltip: fruit.nameI18nKey.xTr,
                      icon: Stack(
                        children: [
                          FruitImage(
                            fruit: fruit,
                            width: 30,
                          ),
                          if (_fruitOf.contains(fruit)) Positioned(
                            right: 5,
                            bottom: 5,
                            child: Container(
                              width: 10,
                              height: 10,
                              child: Icon(
                                Icons.check,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                  ],
                ),
              ],
              Row(
                children: [
                  Spacer(),
                  MyElevatedButton(
                    onPressed: () async {
                      _fruitOf.clear();
                      setState(() { });
                    },
                    child: Text(
                      '清除',
                    ),
                  ),
                  Gap.md,
                  MyElevatedButton(
                    onPressed: () async {
                      await _fieldViewModel
                          .save(_field, fruits: _fruitOf.toList());
                      context.nav.pop();
                    },
                    child: Text(
                      '儲存',
                    ),
                  ),
                ],
              ),
            ],
          ),
          Gap.trailing,
        ],
      ),
    );
  }

  void _toggleFruit(Fruit fruit) {
    if (!_fruitOf.contains(fruit) && _fruitOf.length >= 3) {
      return;
    }

    if (_fruitOf.contains(fruit)) {
      _fruitOf.remove(fruit);
    } else {
      _fruitOf.add(fruit);
    }
    setState(() { });
  }
}


