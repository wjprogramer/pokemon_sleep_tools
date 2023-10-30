part of '../pokemon_slider_details_page.dart';

/// TODO: 增加睡姿星星數、增加睡姿圖片

class _PokemonDetails extends StatefulWidget {
  const _PokemonDetails({
    required this.profile,
    this.statistics,
    required this.onDeletedSuccess,
    required this.initialOffset,
    required this.onScroll,
    required this.viewSize,
  });

  final PokemonProfile profile;
  final PokemonProfileStatistics2? statistics;
  final Function() onDeletedSuccess;
  final double initialOffset;
  final ValueChanged<double> onScroll;
  final Size viewSize;

  @override
  __PokemonDetailsController createState() => __PokemonDetailsController();
}

class __PokemonDetailsController extends State<_PokemonDetails> {
  MainViewModel get _mainViewModel => context.read<MainViewModel>();
  PokemonBasicProfile get basicProfile => widget.profile.basicProfile;
  PokemonProfile get _profile => widget.profile;

  late ScrollController _scrollController;
  late ThemeData _theme;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController(initialScrollOffset: widget.initialOffset)
      ..addListener(() {
        widget.onScroll(_scrollController.offset);
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _theme = context.theme;
    return __PokemonDetailsView(this);
  }
}

class __PokemonDetailsView extends WidgetView<_PokemonDetails, __PokemonDetailsController> {
  const __PokemonDetailsView(__PokemonDetailsController state) : super(state);

  MainViewModel get _mainViewModel => context.read<MainViewModel>();
  PokemonBasicProfile get basicProfile => widget.profile.basicProfile;
  PokemonProfile get _profile => widget.profile;

  ScrollController get _scrollController => s._scrollController;
  ThemeData get _theme => s._theme;

  List<Widget> _buildListItems(BuildContext context, PokemonProfileStatistics2? statistics, {
    required double leadingWidth,
    required double mainWidth,
  }) {
    const subSkillItemSpacing = 24.0;
    const subSkillParentExtraMarginValue = 4.0;
    final subSkillWidth = (mainWidth - 2 * subSkillParentExtraMarginValue - subSkillItemSpacing) / 2;

    Widget image = const SizedBox(height: 100);
    if (MyEnv.USE_DEBUG_IMAGE) {
      const imageSize = 200.0;
      image = SizedBox(
        height: imageSize,
        width: double.infinity,
        child: PokemonImage(
          height: imageSize,
          basicProfile: widget.profile.basicProfile,
          disableTooltip: true,
          isShiny: _profile.isShiny,
        ),
      );
    }

    Widget buildWithLabel({
      required String text,
      required Widget child,
      CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    }) {
      return Row(
        crossAxisAlignment: crossAxisAlignment,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            constraints: BoxConstraints.tightFor(width: leadingWidth),
            child: MyLabel(
              text: text,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: MyLabel.verticalPaddingValue),
              child: child,
            ),
          ),
        ],
      );
    }

    Widget buildIngredientLevelLabel(int level) {
      return Stack(
        children: [
          // placeholder
          const Opacity(
            opacity: 0,
            child: Text('Lv 100'),
          ),
          Positioned.fill(
            child: Row(
              children: [
                const Text('Lv'),
                const Spacer(),
                Text('${level.clamp(1, 100)}'),
              ],
            ),
          ),
        ],
      );
    }

    return [
      Gap.xl,
      ...Hp.list(
        children: [
          Stack(
            children: [
              image,
              // 放收藏按鈕
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    verticalDirection: VerticalDirection.up,
                    children: [
                      IconButton(
                        onPressed: () => _viewBook(),
                        tooltip: '圖鑑'.xTr,
                        icon: const Iconify(Codicon.book, color: greyColor2),
                      ),
                      IconButton(
                        onPressed: () => _onTapFavorite(),
                        tooltip: _profile.isFavorite ? '取消收藏'.xTr : '收藏'.xTr,
                        icon: Icon(
                          _profile.isFavorite
                              ? Icons.star
                              : Icons.star_border,
                          color: _profile.isFavorite
                              ? starIconColor
                              : greyColor2,
                        ),
                      ),
                      IconButton(
                        onPressed: () => _showEditNoteDialog(),
                        tooltip: '筆記'.xTr,
                        icon: const Icon(
                          Icons.comment,
                          color: greyColor2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          MyElevatedButton(
            onPressed: () {
              ExpCalculatorPage.go(
                context,
                isLarvitarChain: widget.profile.isLarvitarChain,
              );
            },
            child: Text('t_upgrade'.xTr),
          ),
          Gap.xl,
          MySubHeader(
            titleText: 't_review'.xTr,
          ),
          Gap.xl,
          Text('${'Lv 50 評價'.xTr}: ${statistics?.result?.rankLv50}\n'
              '${'Lv 100 評價'.xTr}: ${statistics?.result?.rankLv100}'),
          Gap.xl,
          MySubHeader(
            titleText: 't_help_ability'.xTr,
          ),
          Gap.xl,
          buildWithLabel(
            text: 't_fruit'.xTr,
            crossAxisAlignment: CrossAxisAlignment.center,
            child: InkWell(
              onTap: () {
                FruitPage.go(context, basicProfile.fruit);
              },
              child: Row(
                children: [
                  if (MyEnv.USE_DEBUG_IMAGE)
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: FruitImage(
                        fruit: basicProfile.fruit,
                        width: 24,
                      ),
                    ),
                  Expanded(
                    child: Text(
                      basicProfile.fruit.nameI18nKey.xTr,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Gap.xl,
          buildWithLabel(
            text: 't_ingredients'.xTr,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: () {
                    IngredientPage.go(context, basicProfile.ingredient1);
                  },
                  child: Row(
                    children: [
                      buildIngredientLevelLabel(1),
                      Gap.md,
                      if (MyEnv.USE_DEBUG_IMAGE)
                        Padding(
                          padding: const EdgeInsets.only(),
                          child: IngredientImage(
                            ingredient: basicProfile.ingredient1,
                            size: 24,
                          ),
                        ),
                      Expanded(
                        child: Text(basicProfile.ingredient1.nameI18nKey.xTr),
                      ),
                      Text('x${basicProfile.ingredientCount1}'),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    IngredientPage.go(context, widget.profile.ingredient2);
                  },
                  child: Row(
                    children: [
                      buildIngredientLevelLabel(30),
                      Gap.md,
                      if (MyEnv.USE_DEBUG_IMAGE)
                        Padding(
                          padding: const EdgeInsets.only(),
                          child: IngredientImage(
                            ingredient: widget.profile.ingredient2,
                            size: 24,
                          ),
                        ),
                      Expanded(
                        child: Text(widget.profile.ingredient2.nameI18nKey.xTr),
                      ),
                      Text('x${widget.profile.ingredientCount2}'),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    IngredientPage.go(context, widget.profile.ingredient3);
                  },
                  child: Row(
                    children: [
                      buildIngredientLevelLabel(60),
                      Gap.md,
                      if (MyEnv.USE_DEBUG_IMAGE)
                        Padding(
                          padding: const EdgeInsets.only(),
                          child: IngredientImage(
                            ingredient: widget.profile.ingredient3,
                            size: 24,
                          ),
                        ),
                      Expanded(
                        child: Text(widget.profile.ingredient3.nameI18nKey.xTr),
                      ),
                      Text('x${widget.profile.ingredientCount3}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Gap.xl,
          buildWithLabel(
            text: 't_help_interval_2'.xTr,
            child: Text(
              '${basicProfile.maxHelpInterval} ${'t_seconds'.xTr} (${Display.seconds(basicProfile.maxHelpInterval)})',
            ),
          ),
          Gap.xl,
          buildWithLabel(
            text: 't_max_carry'.xTr,
            child: Text(
              '${widget.profile.basicProfile.maxCarry} 個\n',
            ),
          ),
          Gap.xl,
          MySubHeader(
            titleText: '${'t_main_skill'.xTr}${'t_slash'.xTr}${'t_sub_skills'.xTr}',
          ),
          Gap.xl,
          InkWell(
            onTap: () {
              MainSkillPage.go(context, widget.profile.basicProfile.mainSkill);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 16, horizontal: 24,
              ),
              decoration: BoxDecoration(
                border: Border.all(),
              ),
              child: Text(
                widget.profile.basicProfile.mainSkill.nameI18nKey.xTr,
              ),
            ),
          ),
          const SizedBox(height: subSkillItemSpacing),
          // TODO: 副技能反查?
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: subSkillParentExtraMarginValue,
            ),
            child: Wrap(
              spacing: subSkillItemSpacing,
              runSpacing: subSkillItemSpacing,
              children: [
                ...widget.profile.subSkills.mapIndexed((subSkillIndex, subSkill) => Tooltip(
                  message: subSkill.intro,
                  child: Container(
                    constraints: BoxConstraints.tightFor(
                      width: subSkillWidth,
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: subSkill.bgColor,
                              width: 2,
                            ),
                            color: subSkill.bgColor.withOpacity(.6),
                          ),
                          child: Center(
                            child: Text(subSkill.nameI18nKey.xTr),
                          ),
                        ),
                        Positioned(
                          left: -8,
                          top: -8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: subSkillLevelLabelColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 50,
                            ),
                            child: Text(
                              'Lv. ${SubSkill.levelList[subSkillIndex]}',
                              style: TextStyle(
                                fontSize: (_theme.textTheme.bodySmall?.fontSize ?? 16) * 0.7,
                                color: subSkillLevelLabelColor.fgColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
          MySubHeader(
            titleText: 't_others'.xTr,
          ),
          Gap.xl,
          Text(
            _profile.character.nameI18nKey.xTr,
          ),
          _buildCharacterInfo(_profile.character),
          Gap.md,
          MySubHeader(
            titleText: 't_analysis'.xTr,
          ),
          Gap.xl,
          MyElevatedButton(
            onPressed: () {
              /// 需要從 kDebugMode
              DevPokemonStatics2Page.go(context, _profile);
            },
            child: Text('詳細分析數據'),
          ),
          ...[
            // Text(
            //   '幫忙均能/次: ${statistics?.helpPerAvgEnergy.toStringAsFixed(2)}\n'
            //       '數量: ${statistics?.fruitCount}\n'
            //       '幫忙間隔: ${statistics?.helpInterval}\n'
            //       '樹果能量: ${statistics?.fruitEnergy}\n'
            //       '食材1能量: ${statistics?.ingredientEnergy1}\n'
            //       '食材2能量: ${statistics?.ingredientEnergy2}\n'
            //       '食材3能量: ${statistics?.ingredientEnergy3}\n'
            //       '食材均能: ${statistics?.ingredientEnergyAvg}\n'
            //       '幫手獎勵: ${statistics?.helperBonus}\n'
            //       '食材機率: ${statistics?.ingredientRate}\n'
            //       '技能等級: ${statistics?.skillLevel}\n'
            //       '主技能速度參數: ${statistics?.mainSkillSpeedParameter}\n'
            //       '持有上限溢出數: ${statistics?.maxOverflowHoldCount}\n'
            //       '持有上限溢出能量: ${statistics?.overflowHoldEnergy}\n'
            //       '性格速度: ${statistics?.characterSpeed}\n'
            //       '活力加速: ${statistics?.accelerateVitality}\n'
            //       '睡眠EXP獎勵: ${statistics?.sleepExpBonus}\n'
            //       '夢之碎片獎勵: ${statistics?.dreamChipsBonus}\n'
            //       '主技能能量: ${statistics?.mainSkillTotalEnergy}\n'
            //       '主技活力加速: ${statistics?.mainSkillAccelerateVitality}\n',
            // ),
            // Text(
            //   '總幫忙速度加成: S(${statistics?.totalHelpSpeedS}), M(${statistics?.totalHelpSpeedM})',
            // ),
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: TextButton(
            //     onPressed: () {
            //       AnalysisDetailsPage.go(context, _profile.id);
            //     },
            //     child: Text('詳細計算過程'.xTr),
            //   ),
            // ),
          ],
          Gap.xl,
          MySubHeader(
            titleText: 't_source'.xTr,
            color: dataSourceSubHeaderColor,
          ),
        ],
      ),
      ...ListTile.divideTiles(
        context: context,
        tiles: [
          const SearchListTile(
            titleText: 'Pokemon Sleep 理想向收益計算表',
            subTitleText: '參考版本 20231004v2，作為此 App 的演算法',
            url: 'https://bbs.nga.cn/read.php?tid=37305277&rand=768',
          ),
        ],
      ),
      ...Hp.list(
        children: [
          MySubHeader(
            titleText: 't_others'.xTr,
            color: dangerColor,
          ),
          if (kDebugMode) ...[
            MyElevatedButton(
              onPressed: () {
                DevPokemonStatics2Page.go(context, _profile);
              },
              child: Text(
                '測試'.xTr,
              ),
            ),
            MyElevatedButton(
              onPressed: () {
                // PokemonProfileStatistics2(_profile).calc();
              },
              child: Text(
                '測試'.xTr,
              ),
            ),
          ],
          MyElevatedButton(
            onPressed: () => _viewBook(),
            child: Text(
              '查看圖鑑'.xTr,
            ),
          ),
          MyElevatedButton(
            onPressed: () {
              // TODO: Loading, Error Handling
              DialogUtility.danger(
                context,
                confirmText: 't_delete'.xTr,
                title: Text('t_delete_pokemon'.xTr),
                content: Text(
                  't_delete_someone_hint'.xTrParams({
                    'someone': widget.profile.basicProfile.nameI18nKey.xTr,
                  }),
                ),
                onConfirm: () async {
                  if (_profile.isFavorite) {
                    DialogUtility.text(
                      context,
                      title: Text('無法刪除'.xTr),
                      content: Text('請先取消收藏'.xTr),
                    );
                    return;
                  }

                  await context.read<MainViewModel>().deleteProfile(widget.profile.id);
                  widget.onDeletedSuccess();
                },
              );
            },
            child: Text('t_delete'.xTr),
          ),
          Gap.xl,
        ]
      ),
      Gap.trailing,
    ];
  }

  void _viewBook() {
    PokemonBasicProfilePage.go(context, widget.profile.basicProfile);
  }

  Widget _buildCharacterInfo(PokemonCharacter character) {
    final positive = character.positive;
    final negative = character.negative;

    return Text.rich(
      TextSpan(
        style: _theme.textTheme.bodySmall?.copyWith(
          color: greyColor3,
        ),
        children: [
          if (positive == null && negative == null)
            TextSpan(
              text: '沒有因性格帶來的特色'.xTr,
              style: TextStyle(color: _theme.disabledColor),
            )
          else ...[
            if (positive != null) ...[
              TextSpan(
                text: positive,
              ),
              const WidgetSpan(
                child: Icon(Icons.keyboard_arrow_up, color: dangerColor, size: 14,),
              ),
            ],
            if (negative != null) ...[
              if (positive != null)
                TextSpan(
                  text: 't_separator'.xTr,
                ),
              TextSpan(
                text: negative,
              ),
              const WidgetSpan(
                child: Icon(Icons.keyboard_arrow_down, color: positiveColor, size: 14,),
              ),
            ],
          ],
        ],
      ),
      maxLines: 1,
    );
  }

  Future<void> _onTapFavorite() async {
    try {
      await _mainViewModel.updateProfile(_profile.copyWith(
        isFavorite: !_profile.isFavorite,
      ));
    } catch (e) {
      DialogUtility.text(
        context,
        title: Text(
          _profile.isFavorite
              ? '取消失敗'.xTr
              : '收藏失敗'.xTr,
        ),
        content: Text(getErrorMessage(e) ?? '未知錯誤'),
      );
    }
  }

  Future<void> _showEditNoteDialog() async {
    final noteEditController = TextEditingController(text: _profile.customNote);
    var isLoading = false;
    String? errMsg;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('筆記'.xTr),
          content: StatefulBuilder(
            builder: (context, innerSetState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: noteEditController,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: whiteColor,
                      border: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                    ),
                  ),
                  if (errMsg != null)
                    Text(
                      errMsg ?? '',
                      style: const TextStyle(color: dangerColor),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          context.nav.pop();
                        },
                        child: Text('t_cancel'.xTr),
                      ),
                      TextButton(
                        onPressed: () async {
                          try {
                            innerSetState(() {
                              isLoading = true;
                              errMsg = null;
                            });

                            await _mainViewModel.updateProfile(
                              _profile.copyWith(
                                customNote: noteEditController.text,
                              ),
                            );
                            context.nav.pop();
                          } catch (e) {
                            errMsg = getErrorMessage(e);
                          } finally {
                            innerSetState(() {
                              isLoading = false;
                            });
                          }
                        },
                        child: isLoading
                            ? const CircularProgressIndicator()
                            : Text('t_confirm'.xTr),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      },
    );

    noteEditController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final leadingWidth = math.min(widget.viewSize.width * 0.3, 150.0);
    final mainWidth = widget.viewSize.width - 2 * HORIZON_PADDING;

    return buildListView(
      controller: _scrollController,
      children: _buildListItems(
        context,
        widget.statistics,
        leadingWidth: leadingWidth,
        mainWidth: mainWidth,
      ),
    );
  }
}
