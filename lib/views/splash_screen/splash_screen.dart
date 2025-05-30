import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_child/app/utils/extentions_utils.dart';
import 'package:my_child/views/widgets/app_image.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 2),
        //we used extentions_utils
        () => context.pushRemoveUntil('/choseUser'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppImage(
          width: 270,
          height: 270,
          imagename: "assets/images/my_childws.png",
        ),
        Divider(
          indent: 40,
          endIndent: 40,
          height: 40,
          thickness: 3,
        ),
        Text(
          "الخدمات الصحية لوزارة الصحة",
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
        )
      ],
    ));
  }
}
