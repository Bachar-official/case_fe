import 'package:flutter/material.dart';

class EmptyListHandler extends StatelessWidget {
  final Widget listWidget;
  final bool isListEmpty;
  final String emptyMessage;
  const EmptyListHandler(
      {required this.listWidget,
      required this.emptyMessage,
      required this.isListEmpty,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        listWidget,
        Center(
          child: Text(isListEmpty ? emptyMessage : ''),
        ),
      ],
    );
  }
}
