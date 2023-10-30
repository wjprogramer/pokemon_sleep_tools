part of 'pokemon_basic_profile_page.dart';

class _PokemonBasicProfileView extends WidgetView<PokemonBasicProfilePage, _PokemonBasicProfileLogic> {
  const _PokemonBasicProfileView(_PokemonBasicProfileLogic state) : super(state);

  ThemeData get _theme => s._theme;
  bool get _initialized => s._initialized;
  bool get _isView => s._isView;
  PokemonBasicProfile get _basicProfile => s._basicProfile;
  bool get _existInBox => s._existInBox;
  Map<int, String> get _sleepNamesOfBasicProfile => s._sleepNamesOfBasicProfile;

  Widget _buildAppBarTitle() {
    final titleStyle = (
        _isView ? _theme.appBarTheme.titleTextStyle : const TextStyle()
    ) ?? const TextStyle();

    return Row(
      children: [
        if (MyEnv.USE_DEBUG_IMAGE)
          Padding(
            padding: const EdgeInsets.only(right: Gap.mdV),
            child: PokemonTypeImage(
              pokemonType: _basicProfile.pokemonType,
              width: 24,
            ),
          ),
        if (_existInBox)
          const Padding(
            padding: EdgeInsets.only(right: Gap.mdV),
            child: PokemonRecordedIcon(),
          ),
        Expanded(
          child: Text.rich(
            TextSpan(
              text: _basicProfile.nameI18nKey.xTr,
              style: titleStyle,
              children: [
                TextSpan(
                  text: ' #${_basicProfile.boxNo}',
                  style: titleStyle.copyWith(
                    fontSize: (titleStyle.fontSize ?? 18) * 0.7,
                    color: greyColor3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildIngredientsUnderLevel(int level, List<(Ingredient, int)> ingredients) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Stack(
          children: [
            Opacity(
              opacity: 0,
              child: _buildLevel(999),
            ),
            _buildLevel(level),
          ],
        ),
        Gap.sm,
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            children: ingredients.map((e) => _buildIngredient(e.$1, e.$2)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildIngredient(Ingredient ingredient, int count) {
    return InkWell(
      onTap: s._getAddToBoxCallback(ingredient),
      borderRadius: BorderRadius.circular(8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (MyEnv.USE_DEBUG_IMAGE)
            Padding(
              padding: const EdgeInsets.only(right: 2),
              child: IngredientImage(
                ingredient: ingredient,
                size: 32,
                disableTooltip: true,
              ),
            ),
          Text(ingredient.nameI18nKey.xTr),
        ],
      ),
    );
  }

  Widget _buildLevel(int level) {
    return Text(
      'Lv $level',
    );
  }

  Widget _buildSleepFace(SleepFace sleepFace, List<int> markStyles) {
    final marked = markStyles.contains(sleepFace.style);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => s._onSleepFaceMarkToggled(sleepFace, markStyles),
              icon: BookmarkIcon(marked: marked),
            ),
            Text(
              _sleepNamesOfBasicProfile[sleepFace.style] ?? s._sleepFaceRepo.getCommonSleepFaceName(sleepFace.style) ?? '',
            ),
            Gap.md,
            SnorlaxRankItem(rank: sleepFace.snorlaxRank),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(left: 48),
          child: RichText(
            text: TextSpan(
              text: '',
              style: _theme.textTheme.bodyMedium,
              children: [
                WidgetSpan(
                  child: Padding(
                    padding: const EdgeInsets.only(right: Gap.smV),
                    child: CandyOfPokemonIcon(
                      size: 16,
                      boxNo: s._basicProfileWithSmallestBoxNoInChain.boxNo,
                    ),
                  ),
                ),
                TextSpan(
                  text: '${sleepFace.rewards.candy}',
                ),
                const WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: Gap.mdV,
                      right: Gap.smV,
                    ),
                    child: DreamChipIcon(size: 16,),
                  ),
                ),
                TextSpan(
                  text: '${sleepFace.rewards.shards}',
                ),
                const WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: Gap.mdV,
                      right: Gap.smV,
                    ),
                    child: XpIcon(size: 16,),
                  ),
                ),
                TextSpan(
                  text: '${sleepFace.rewards.exp}',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWithLabel({
    required String text,
    required Widget child,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
  }) {
    return Row(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Container(
          margin: const EdgeInsets.only(right: 12),
          constraints: BoxConstraints.tightFor(width: s._leadingWidth),
          child: DefaultTextStyle(
            style: _theme.textTheme.bodySmall ?? const TextStyle(),
            child: MyLabel(
              text: text,
            ),
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

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return LoadingView(
        isView: _isView,
      );
    }

    return Scaffold(
      appBar: _isView ? null : buildAppBar(
        title: _buildAppBarTitle(),
      ),
      body: Consumer2<MainViewModel, SleepFaceViewModel>(
        builder: (context, mainViewModel, sleepFaceViewModel, child) {
          // final profiles = mainViewModel.profiles;
          final markStyles = sleepFaceViewModel.markStylesOf[_basicProfile.id] ?? [];

          Widget mainBodyContent = buildListView(
            padding: const EdgeInsets.symmetric(
              horizontal: HORIZON_PADDING,
            ),
            children: [
              if (MyEnv.USE_DEBUG_IMAGE)
                SizedBox(
                  height: 200,
                  child: PokemonImage(
                    basicProfile: _basicProfile,
                    fit: BoxFit.fitHeight,
                    disableTooltip: true,
                  ),
                ),
              MySubHeader(
                titleText: 't_abilities'.xTr,
              ),
              Gap.md,
              _buildWithLabel(
                text: 't_sleep_type'.xTr,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SleepTypeLabel(
                    sleepType: _basicProfile.sleepType,
                  ),
                ),
              ),
              Gap.md,
              _buildWithLabel(
                text: 't_specialty'.xTr,
                crossAxisAlignment: CrossAxisAlignment.center,
                child: Row(
                  children: [
                    SpecialtyLabel(
                      specialty: _basicProfile.specialty,
                    ),
                    const Spacer(),
                    if (kDebugMode)
                      IconButton(
                        onPressed: () {
                          SpecialtyInfoPage.go(context);
                        },
                        icon: const Icon(
                          Icons.info_outline,
                          color: greyColor2,
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
              ),
              Gap.md,
              _buildWithLabel(
                text: 't_fruit'.xTr,
                child: Row(
                  children: [
                    if (MyEnv.USE_DEBUG_IMAGE)
                      Padding(
                        padding: const EdgeInsets.only(right: Gap.smV),
                        child: FruitImage(
                          fruit: _basicProfile.fruit,
                          width: 24,
                        ),
                      ),
                    Expanded(
                      child: Text(
                          '${_basicProfile.fruit.nameI18nKey.xTr} (${'機率'.xTr}: ${Display.numDouble(s._ingredientRate == null ? null : 100.0 - s._ingredientRate!)}%)'
                      ),
                    ),
                  ],
                ),
              ),
              Gap.md,
              _buildWithLabel(
                text: 't_main_skill'.xTr,
                child: InkWell(
                  onTap: () {
                    MainSkillPage.go(context, _basicProfile.mainSkill);
                  },
                  child: Text(_basicProfile.mainSkill.nameI18nKey.xTr),
                ),
              ),
              Gap.md,
              _buildWithLabel(
                text: 't_help_interval_base'.xTr,
                child: Text(Display.numInt(_basicProfile.maxHelpInterval)),
              ),
              Gap.md,
              _buildWithLabel(
                text: 't_abilities'.xTr,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Text(Display.numInt(_basicProfile.helpInterval))
                    Row(
                      children: [
                        const FriendPointsIcon(),
                        Gap.md,
                        Expanded(
                          child: Text(Display.numInt(_basicProfile.friendshipPoints)),
                        ),
                      ],
                    ),
                    Gap.sm,
                    Row(
                      children: [
                        Text('t_max_carry'.xTr),
                        Gap.md,
                        Expanded(
                          child: Text(Display.numInt(_basicProfile.maxCarry)),
                        ),
                      ],
                    ),
                    Text(
                        '成為夥伴報酬: ${_basicProfile.recruitRewards.exp}, ${_basicProfile.recruitRewards.shards}'
                    ),
                  ],
                ),
              ),
              Gap.md,
              MySubHeader(
                titleText: 't_ingredients'.xTr,
              ),
              if (kDebugMode && !kDebugMode)
                SliderWithButtons(
                  value: s._currPokemonLevel.toDouble(),
                  onChanged: (v) {
                    s._currPokemonLevel = v.toInt();
                    setState(() { });
                  },
                  max: 60,
                  min: 1,
                  divisions: 59,
                  hideSlider: true,
                ),
              // TODO: 顯示各項組合，使用水平滑動可能比較好讀
              _buildIngredientsUnderLevel(1, [ (_basicProfile.ingredient1, _basicProfile.ingredientCount1) ]),
              _buildIngredientsUnderLevel(30, _basicProfile.ingredientOptions2),
              _buildIngredientsUnderLevel(60, _basicProfile.ingredientOptions3),
              Gap.md,
              MySubHeader(
                titleText: 't_evolution'.xTr,
              ),
              EvolutionsView(
                s._evolutions,
                basicProfile: _basicProfile,
                basicProfilesInEvolutionChain: s._basicProfilesInEvolutionChain,
                basicProfileWithSmallestBoxNoInChain: s._basicProfileWithSmallestBoxNoInChain,
              ),
              Gap.md,
              MySubHeader(
                titleText: 't_sleep_faces'.xTr,
              ),
              Gap.md,
              ...s._sleepFacesOfField.entries.where((e) => e.value.isNotEmpty).map((e) {
                final field = e.key;
                final sleepFaces = e.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InkWell(
                      onTap: () {
                        MapPage.go(context, field);
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          8, 8, 8, Gap.smV,
                        ),
                        child: Row(
                          children: [
                            const FieldMenuIcon(),
                            Gap.md,
                            Expanded(
                              child: Text(
                                field.nameI18nKey.xTr,
                              ),
                            ),
                            // Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Gap.xs,
                          ...sleepFaces.map((sleepFace) => _buildSleepFace(sleepFace, markStyles)),
                          Gap.md,
                        ],
                      ),
                    ),
                  ],
                );
              }),
              MySubHeader(
                titleText: '其他'.xTr,
              ),
              MyElevatedButton(
                onPressed: s._getViewPokedexCallback(),
                child: Text('查看寶可夢盒'.xTr),
              ),
              if (kDebugMode) ...[
                const MySubHeader(titleText: '測試用', color: positiveColor),
                MyElevatedButton(
                  onPressed: () {
                    DevPokemonBasicProfileIngredientsCombinationPage.go(context, _basicProfile);
                  },
                  child: const Text('食材組合'),
                ),
              ],
              Gap.trailing,
            ],
          );

          if (_isView) {
            mainBodyContent = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: kToolbarHeight,
                  child: Row(
                    children: [
                      Gap.h,
                      Expanded(child: _buildAppBarTitle()),
                    ],
                  ),
                ),
                Expanded(child: mainBodyContent),
              ],
            );
          }

          return mainBodyContent;
        },
      ),
    );
  }
}
