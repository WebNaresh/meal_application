import 'package:flutter/material.dart';
import 'package:meals/screen/filter_item.dart';

enum Operation { gluten, lactose, vegan, vegetarian }

class FiltersScreen extends StatefulWidget {
  const FiltersScreen({
    super.key,
    required this.glutenFreeFilterSet,
    required this.lactoseFreeFilterSet,
    required this.vegetarianFilterSet,
    required this.veganFilterSet,
  });
  final bool glutenFreeFilterSet;
  final bool lactoseFreeFilterSet;
  final bool vegetarianFilterSet;
  final bool veganFilterSet;

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  late bool _glutenFreeFilterSet = false;
  late bool _lactoseFreeFilterSet = false;
  late bool _vegetarianFilterSet = false;
  late bool _veganFilterSet = false;
  @override
  void initState() {
    super.initState();
    _glutenFreeFilterSet = widget.glutenFreeFilterSet;
    _lactoseFreeFilterSet = widget.lactoseFreeFilterSet;
    _vegetarianFilterSet = widget.vegetarianFilterSet;
    _veganFilterSet = widget.veganFilterSet;
  }

  void _setMainState(bool isChecked, Operation value) {
    setState(() {
      switch (value) {
        case Operation.gluten:
          _glutenFreeFilterSet = isChecked;
          break;
        case Operation.lactose:
          _lactoseFreeFilterSet = isChecked;
        case Operation.vegan:
          _veganFilterSet = isChecked;
        case Operation.vegetarian:
          _vegetarianFilterSet = isChecked;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Filters "),
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          if (didPop) return;
          Navigator.of(context).pop({
            Operation.gluten: _glutenFreeFilterSet,
            Operation.lactose: _lactoseFreeFilterSet,
            Operation.vegan: _veganFilterSet,
            Operation.vegetarian: _vegetarianFilterSet,
          });
        },
        child: Column(
          children: [
            FilterItem(
              onChanged: _setMainState,
              value: _glutenFreeFilterSet,
              title: "Gluten-free",
              label: "Only include gluten-free meals.",
              operation: Operation.gluten,
            ),
            FilterItem(
              onChanged: _setMainState,
              value: _lactoseFreeFilterSet,
              title: "Lactose-free",
              label: "Only include lactose-free meals.",
              operation: Operation.lactose,
            ),
            FilterItem(
              onChanged: _setMainState,
              value: _vegetarianFilterSet,
              title: "Vegetarian",
              label: "Only include vegetarian meals.",
              operation: Operation.vegetarian,
            ),
            FilterItem(
              onChanged: _setMainState,
              value: _veganFilterSet,
              title: "Vegan",
              label: "Only include vegan meals.",
              operation: Operation.vegan,
            ),
          ],
        ),
      ),
    );
  }
}
