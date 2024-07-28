import 'package:flutter/material.dart';
import 'package:meals/screen/filters_screen.dart';

class FilterItem extends StatelessWidget {
  const FilterItem(
      {super.key,
      required this.onChanged,
      required this.value,
      required this.title,
      required this.label,
      required this.operation});
  final bool value;
  final String title;
  final String label;
  final Operation operation;
  final void Function(
    bool isChecked,
    Operation value,
  ) onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      value: value,
      onChanged: (isChecked) {
        onChanged(isChecked, operation);
      },
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
      ),
      subtitle: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
      ),
      activeColor: Theme.of(context).colorScheme.tertiary,
      contentPadding: const EdgeInsets.only(
        left: 34,
        right: 22,
      ),
    );
  }
}
