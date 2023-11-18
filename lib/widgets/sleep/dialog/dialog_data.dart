import 'package:flutter/widgets.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

// Base Dialog
const sleepStyleDialogHorizontalMarginValue = 24.0;

// Search Dialog
const sleepStyleSearchDialogHorizontalListViewPaddingValue = 16.0;

typedef CalculateCounts<T extends BaseSearchOptions> = (int, int) Function(T searchOptions);
typedef CommonSleepChildrenBuilder<T extends BaseSearchOptions> = List<Widget> Function(BuildContext context, VoidCallback search, T searchOptions);

// Sort Dialog
const sleepStyleSortDialogHorizontalListViewPaddingValue = 16.0;

typedef CommonSortChildrenBuilder<T extends BaseSortOptions> = List<Widget> Function(BuildContext context, T sortOptions);
