part of '../dish_maker_page.dart';

typedef IngredientAmountChanged = void Function(Ingredient ingredient, int amount);

class _IngredientsOfPotView extends StatelessWidget {
  const _IngredientsOfPotView({
    super.key,
    required this.totalStoredIngredientsCount,
    required this.itemWidth,
    required this.onAmountChanged,
    required this.storedIngredientOf,
    required this.onReset,
  });

  final int totalStoredIngredientsCount;
  final double itemWidth;
  final IngredientAmountChanged onAmountChanged;
  final Map<Ingredient, StoredIngredientItem> storedIngredientOf;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: HORIZON_PADDING,
      ),
      children: [
        Gap.lg,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: totalStoredIngredientsCount == 0 ? null : () {
                DialogUtility.confirm(
                  context,
                  title: Text('確定要清空?'.xTr),
                  onConfirm: () {
                    onReset();
                  },
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                      right: Gap.smV,
                    ),
                    child: Icon(Icons.delete_forever),
                  ),
                  Text('清空'.xTr),
                ],
              ),
            ),
          ],
        ),
        Gap.md,
        Wrap(
          spacing: _spacing,
          runSpacing: _spacing,
          children: Ingredient.values.map((ingredient) =>
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: itemWidth,
                ),
                child: _buildIngredient(
                  context, ingredient,
                ),
              )).toList(),
        ),
        Gap.md,
        Text(
          '食材庫存總數: ${Display.numInt(totalStoredIngredientsCount)}',
          style: TextStyle(
            fontSize: 24,
          ),
          textAlign: TextAlign.end,
        ),
        Gap.trailing,
      ],
    );
  }

  Widget _buildIngredient(BuildContext context, Ingredient ingredient) {
    final theme = context.theme;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 4,
      ),
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.dividerColor,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Gap.md,
          if (MyEnv.USE_DEBUG_IMAGE)
            Padding(
              padding: const EdgeInsets.only(right: Gap.mdV),
              child: IngredientImage(
                ingredient: ingredient,
                size: 48,
                disableTooltip: true,
              ),
            ),
          Expanded(
            child: Text(
              ingredient.nameI18nKey.xTr,
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          IncrementValueButton(
            onChanged: (num value) => _valueChanged(ingredient, value.toInt() * -1),
            child: Icon(Icons.remove),
          ),
          Stack(
            children: [
              Opacity(
                opacity: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildValue(100, isPlaceholder: true),
                ),
              ),
              Positioned.fill(
                child: Center(child: _buildValue(storedIngredientOf[ingredient]?.amount ?? 0)),
              ),
            ],
          ),
          IncrementValueButton(
            onChanged: (num value) => _valueChanged(ingredient, value.toInt()),
            child: Icon(Icons.add),
          ),
          Gap.md,
        ],
      ),
    );
  }

  Widget _buildValue(int amount, {
    isPlaceholder = false,
  }) {
    final isNone = amount == 0;

    return Text(
      '${isPlaceholder ? 99 : amount}',
      style: TextStyle(
        color: isNone ? greyColor2 : null,
        fontWeight: isNone ? null : FontWeight.bold,
        backgroundColor: isNone ? null : positiveColor.withOpacity(.2),
      ),
    );
  }

  void _valueChanged(Ingredient ingredient, int amountDelta) {
    final oldAmount = storedIngredientOf[ingredient]?.amount ?? 0;
    final int validAmount = (oldAmount + amountDelta).clamp(0, 99);

    onAmountChanged(ingredient, validAmount);
  }

}

