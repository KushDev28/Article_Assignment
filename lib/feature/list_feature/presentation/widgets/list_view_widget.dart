import 'package:flutter/material.dart';

class ReusableListView<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final EdgeInsetsGeometry padding;
  final ScrollPhysics? physics;

  const ReusableListView({
    Key? key,
    required this.items,
    required this.itemBuilder,
    this.padding = const EdgeInsets.all(16),
    this.physics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      physics: physics,
      itemCount: items.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return itemBuilder(context, items[index], index);
      },
    );
  }
}
