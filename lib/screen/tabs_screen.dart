import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/providers/favorites_provider.dart';
import 'package:meals/providers/meals_provider.dart';
import 'package:meals/screen/categories_screen.dart';
import 'package:meals/screen/filters_screen.dart';
import 'package:meals/screen/meals_screen.dart';
import 'package:meals/widgets/main_drawer.dart';

const Map<Operation, bool> kInitialFilters = {
  Operation.gluten: false,
  Operation.lactose: false,
  Operation.vegan: false,
  Operation.vegetarian: false,
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => TabsScreenState();
}

class TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;

  void selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  Map<Operation, bool> _selectedFilters = kInitialFilters;

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == "filters") {
      final result = await Navigator.of(context).push<Map<Operation, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(
            lactoseFreeFilterSet: _selectedFilters[Operation.lactose]!,
            glutenFreeFilterSet: _selectedFilters[Operation.gluten]!,
            veganFilterSet: _selectedFilters[Operation.vegan]!,
            vegetarianFilterSet: _selectedFilters[Operation.vegetarian]!,
          ),
        ),
      );

      setState(() {
        _selectedFilters = result ?? kInitialFilters;
      });

      print(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final meals = ref.watch(mealsProvider);
    final availableMeals = meals.where((meal) {
      if (_selectedFilters[Operation.gluten]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFilters[Operation.lactose]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilters[Operation.vegan]! && !meal.isVegan) {
        return false;
      }
      if (_selectedFilters[Operation.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      return true;
    }).toList();

    final favoriteMeals = ref.watch(favoriteMealsProvider);

    Widget activePage = _selectedPageIndex == 0
        ? CategoriesScreen(
            availableMeals: availableMeals,
          )
        : MealsScreen(
            meals: favoriteMeals,
          );

    final String activePageTitle =
        _selectedPageIndex == 0 ? "Categories" : "Favorites";

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      body: activePage,
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: selectPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: "Favorites",
          ),
        ],
      ),
    );
  }
}
