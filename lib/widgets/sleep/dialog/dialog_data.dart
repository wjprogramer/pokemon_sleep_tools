import 'package:flutter/widgets.dart';
import 'package:pokemon_sleep_tools/data/models/models.dart';

const sleepStyleSearchDialogHorizontalMarginValue = 24.0;
const sleepStyleSearchDialogHorizontalListViewPaddingValue = 16.0;

typedef CalculateCounts<T extends BaseSearchOptions> = (int, int) Function(T searchOptions);
typedef CommonSleepChildrenBuilder<T extends BaseSearchOptions> = List<Widget> Function(BuildContext context, VoidCallback search, T searchOptions);

