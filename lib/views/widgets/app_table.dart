import 'package:flutter/material.dart';
import 'package:my_child/app/style/style_color.dart';

class TableDetailsV extends StatelessWidget {
  const TableDetailsV({
    super.key,
    required this.text,
    this.textColor = Colors.black,
  });

  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }
}

class TableHeaderV extends StatelessWidget {
  const TableHeaderV({
    super.key,
    required this.text,
    this.width,
    this.borderRadius,
  });
  final String text;
  final double? width;
  final BorderRadiusGeometry? borderRadius;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide()),
        borderRadius: borderRadius ??
            BorderRadius.only(
                topLeft: Radius.circular(0), topRight: Radius.circular(0)),
        color: primaryBlueColor,
      ),
      //the ?? means if the width is not nul take the value of if if the value s null use media q
      width: width ?? MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              fontSize: 18,
              //bold
              fontWeight: FontWeight.bold,
              color: primaryWhiteColor),
        ),
      ),
    );
  }
}
