import 'package:flutter/material.dart';

class EmptyContainer extends StatelessWidget {
  final String content;

  const EmptyContainer(this.content, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: Text(
          content,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
