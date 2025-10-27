import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final Color? color;
  
  const AppLogo({
    super.key,
    this.size = 80,
    this.color,
  });
  
  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.home_rounded,
      size: size,
      color: color ?? Theme.of(context).colorScheme.primary,
    );
  }
}

