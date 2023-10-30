part of '../dish_maker_page.dart';

class _ResultDishesView extends StatelessWidget {
  const _ResultDishesView({
    super.key,
    required this.dishes,
    required this.canCookDishSet,
    required this.itemWidth,
    required this.dishLevelInfoOf,
    required this.level,
    required this.storedIngredientOf,
  });

  final List<Dish> dishes;
  final Set<Dish> canCookDishSet;
  final double itemWidth;
  final Map<Dish, DishLevelInfo> dishLevelInfoOf;
  final int level;
  final Map<Ingredient, StoredIngredientItem> storedIngredientOf;

  @override
  Widget build(BuildContext context) {
    final canCookDishes = <Dish>[];
    final cannotCookDishes = <Dish>[];

    for (final dish in dishes) {
      if (canCookDishSet.contains(dish)) {
        canCookDishes.add(dish);
      } else {
        cannotCookDishes.add(dish);
      }
    }

    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: HORIZON_PADDING,
      ),
      children: [
        Gap.lg,
        MySubHeader2(titleText: '可製作'.xTr,),
        Gap.sm,
        if (canCookDishes.isNotEmpty)
          _buildDishes(context, canCookDishes)
        else
          Text('t_none'.xTr),
        MySubHeader2(titleText: '不可製作'.xTr,),
        Gap.sm,
        if (cannotCookDishes.isNotEmpty)
          _buildDishes(context, cannotCookDishes)
        else
          Text('t_none'.xTr),
        Gap.trailing,
      ],
    );
  }

  Widget _buildDishes(BuildContext context, List<Dish> dishes) {
    return Wrap(
      spacing: _spacing,
      children: dishes.map((dish) => ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: itemWidth,
        ),
        child: _buildDish(
          context, dish,
        ),
      )).toList(),
    );
  }

  Widget _buildDish(BuildContext context, Dish dish) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),
      child: DishCard(
        dish: dish,
        level: level,
        energy: dishLevelInfoOf[dish]?.energy,
        storedIngredientOf: storedIngredientOf,
        onTap: () {
          DishPage.go(context, dish);
        },
      ),
    );
  }

}
