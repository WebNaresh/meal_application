import 'package:flutter_riverpod/flutter_riverpod.dart';

enum Filter { glutenFree, isLactoseFree, vegan, vegetarian }

class FiltersProvider extends StateNotifier<Map<Filter, bool>> {
  FiltersProvider()
      : super({
          Filter.glutenFree: false,
          Filter.isLactoseFree: false,
          Filter.vegan: false,
          Filter.vegetarian: false,
        });

  void setFilter(Filter filter, bool isActive) {
    state = {...state, filter: isActive};
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersProvider, Map<Filter, bool>>((ref) {
  return FiltersProvider();
});
