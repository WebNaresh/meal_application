import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/meal.dart';
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

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => TabsScreenState();
}

class TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  final List<Meal> _favoriteMeals = [];
  Map<Operation, bool> _selectedFilters = kInitialFilters;

  void _toggleMealFavoriteStatus(Meal meal) {
    final isExisting = _favoriteMeals.contains(meal);
    if (isExisting) {
      setState(() {
        _favoriteMeals.remove(meal);
      });
      _showInfoMessage("Meal is removed from favorites");
    } else {
      setState(() {
        _favoriteMeals.add(meal);
      });
      _showInfoMessage("Meal is added to the favorites");
    }
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

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
    final availableMeals = dummyMeals.where((meal) {
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
    Widget activePage = _selectedPageIndex == 0
        ? CategoriesScreen(
            onToggleFavorite: _toggleMealFavoriteStatus,
            availableMeals: availableMeals,
          )
        : MealsScreen(
            meals: _favoriteMeals, onToggleFavorite: _toggleMealFavoriteStatus);

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
