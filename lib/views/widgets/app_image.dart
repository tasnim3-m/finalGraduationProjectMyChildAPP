import 'package:flutter/material.dart';

class AppImage extends StatelessWidget {
  const AppImage({
    super.key,
    required this.width,
    required this.height,
    required this.imagename,
  });

  final double width;
  final double height;
  final String imagename;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Image.asset(
        imagename,
        fit: BoxFit.contain,
      ),
    );
  }
}
