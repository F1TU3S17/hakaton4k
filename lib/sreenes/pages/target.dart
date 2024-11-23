import 'package:flutter/material.dart';

class TargetPage extends StatelessWidget {

  const TargetPage({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: 100, width: 100,);
  }
}