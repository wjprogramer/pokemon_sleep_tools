import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:pokemon_sleep_tools/all_in_one/all_in_one.dart';
import 'package:pokemon_sleep_tools/all_in_one/i18n/i18n.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';
import 'package:pokemon_sleep_tools/data/repositories/repositories.dart';
import 'package:pokemon_sleep_tools/pages/features_main/field_edit/field_edit_page.dart';
import 'package:pokemon_sleep_tools/pages/features_main/map/map_page.dart';
import 'package:pokemon_sleep_tools/pages/routes.dart';
import 'package:pokemon_sleep_tools/persistent/persistent.dart';
import 'package:pokemon_sleep_tools/view_models/field_view_model.dart';
import 'package:pokemon_sleep_tools/widgets/common/common.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/images/field_image.dart';
import 'package:pokemon_sleep_tools/widgets/sleep/images/fruit_image.dart';
import 'package:provider/provider.dart';

/// TODO: 可以顯示蒐集率
class MapsPage extends StatefulWidget {
  const MapsPage._();

  static const MyPageRoute route = ('/MapsPage', _builder);
  static Widget _builder(dynamic args) {
    return const MapsPage._();
  }

  static void go(BuildContext context) {
    context.nav.push(
      route,
    );
  }

  @override
  State<MapsPage> createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  SleepFaceRepository get _sleepFaceRepo => getIt();

  // UI
  late ThemeData _theme;

  // Page status
  var _initialized = false;

  // Data
  final _pokemonCountOfFiled = <PokemonField, int>{};
  final _sleepFaceCountOfFiled = <PokemonField, int>{};

  @override
  void initState() {
    super.initState();

    scheduleMicrotask(() async {
      // field to basic_profile_id
      final fieldToBasicProfileIdList = <PokemonField, Set<int>>{};

      // init
      for (var field in PokemonField.values) {
        fieldToBasicProfileIdList[field] = {};
        _sleepFaceCountOfFiled[field] = 0;
      }

      // load
      final sleepFaces = await _sleepFaceRepo.findAll();

      // process
      for (var sleepFace in sleepFaces) {
        fieldToBasicProfileIdList[sleepFace.field]!.add(sleepFace.basicProfileId);
        _sleepFaceCountOfFiled[sleepFace.field] = _sleepFaceCountOfFiled[sleepFace.field]! + 1;
      }

      // extract
      for (var field in PokemonField.values) {
        _pokemonCountOfFiled[field] = fieldToBasicProfileIdList[field]!.length;
      }

      // complete
      _initialized = true;
      if (mounted) {
        setState(() { });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _theme = context.theme;

    if (!_initialized) {
      return LoadingView();
    }

    return Consumer<FieldViewModel>(
      builder: (context, fieldViewModel, child) {
        return Scaffold(
          appBar: buildAppBar(
            titleText: 't_map'.xTr,
          ),
          body: ListView(
            children: [
              ...PokemonField.values.map((e) => _buildField(e, fieldViewModel.getItem(e))),
              Gap.trailing,
            ],
          ),
        );
      },
    );
  }

  Widget _buildField(PokemonField field, StoredPokemonFieldItem storedFieldItem) {
    return Stack(
      children: [
        Opacity(
          opacity: 0,
          child: _buildFieldContent(field, storedFieldItem),
        ),
        if (MyEnv.USE_DEBUG_IMAGE)
          Positioned.fill(
            child: Opacity(
              opacity: .3,
              child: FieldImage(
                field: field,
                fit: BoxFit.cover,
              ),
            ),
          ),
        // Positioned.fill(
        //   child: Container(
        //     width: double.infinity,
        //     height: double.infinity,
        //     decoration: BoxDecoration(
        //       color: whiteColor.withOpacity(.2),
        //       // gradient: LinearGradient(
        //       //   stops: [
        //       //     0.6, 1,
        //       //   ],
        //       //   colors: [
        //       //     Colors.white.withOpacity(0.9),
        //       //     Colors.white.withOpacity(0),
        //       //   ],
        //       // ),
        //     ),
        //   ),
        // ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              MapPage.go(context, field);
            },
            child: _buildFieldContent(field, storedFieldItem),
          ),
        ),
        if (field == PokemonField.f1)
          Positioned(
            top: 0,
            right: 0,
            child: TextButton(
              onPressed: () {
                FieldEditPage.go(context, field);
              },
              child: Row(
                children: [
                  Icon(
                    Icons.edit,
                  ),
                  Gap.sm,
                  Text(
                    '設定樹果',
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFieldContent(PokemonField field, StoredPokemonFieldItem storedFieldItem) {
    List<Fruit> fruits = field.fruits;
    if (field == PokemonField.f1) {
      fruits = storedFieldItem.fruits;
    }

    return Hp(
      child: Container(
        padding: const EdgeInsets.only(
          top: Gap.xlV,
          bottom: Gap.xlV,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              field.nameI18nKey.xTr,
              style: _theme.textTheme.bodyLarge,
            ),
            Gap.xs,
            if (MyEnv.USE_DEBUG_IMAGE)
              Wrap(
                spacing: 0,
                runAlignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('${'t_fruits'.xTr}:'),
                  ...fruits.map((fruit) => Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: FruitImage(
                            fruit: fruit,
                            width: 24,
                          ),
                        ),
                        Text(fruit.nameI18nKey.xTr),
                      ],
                    ),
                  )),
                ],
              )
            else
              Text(
                '${'t_fruits'.xTr}: ${field.fruits.map((e) => e.nameI18nKey.xTr).join('t_separator'.xTr)}',
                style: _theme.textTheme.bodyMedium,
              ),
            Text(
              '解鎖數量: ${field.unlockCount}\n'
                  '寶可夢數量: ${_pokemonCountOfFiled[field]}\n'
                  '睡姿數量: ${_sleepFaceCountOfFiled[field]}',
              style: _theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

}


