import "package:flutter/material.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui' as ui;

class AddTextField extends StatelessWidget {
  const AddTextField({
    super.key,
    required this.hintText,
    required this.iconName,
    this.onChanged,
    required this.validator,
    this.keyBoardTYpe,
    this.maxlength,
    this.inputController,
  });
  final String hintText;
  final String iconName;
  final TextInputType? keyBoardTYpe;
  final Function(String value)? onChanged;
  final String? Function(String? value) validator;
  final int? maxlength;
  final TextEditingController? inputController;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: TextFormField(
          controller: inputController,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          maxLength: maxlength,
          keyboardType: keyBoardTYpe,
          onChanged: onChanged,
          validator: validator,
          cursorOpacityAnimates: true,
          cursorColor: Colors.black,
          cursorErrorColor: Colors.red,
          decoration: InputDecoration(
            hintText: hintText,
            hintTextDirection: TextDirection.rtl,
            prefixIcon: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(
                iconName,
                fit: BoxFit.fill,
                colorFilter:
                    ColorFilter.mode(Color(0xffB4B4B4), BlendMode.srcATop),
              ),
            ),
          )),
    );
  }
}

class DatePikerField extends StatelessWidget {
  const DatePikerField({
    super.key,
    required this.hintText,
    required this.iconName,
    required this.validator,
    required this.onTap,
    required this.controller,
  });
  final String hintText;
  final String iconName;
  final String? Function(String? value) validator;
  final void Function() onTap;
  final TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller,
            validator: validator,
            showCursor: false,
            enabled: false,
            cursorOpacityAnimates: true,
            cursorColor: Colors.black,
            cursorErrorColor: Colors.red,
            decoration: InputDecoration(
              hintText: hintText,
              hintTextDirection: TextDirection.rtl,
              prefixIcon: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset(
                  iconName,
                  fit: BoxFit.fill,
                  colorFilter:
                      ColorFilter.mode(Color(0xffB4B4B4), BlendMode.srcATop),
                ),
              ),
            )),
      ),
    );
  }
}
