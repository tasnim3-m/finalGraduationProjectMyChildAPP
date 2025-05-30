import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_child/app/style/style_color.dart';
import 'package:my_child/app/utils/extentions_utils.dart';
import 'package:my_child/views/home_screen/home_view.dart';
import 'package:my_child/views/home_screen/views_drawer/Health_Center_Locations.dart';
import 'package:my_child/views/home_screen/views_drawer/Jordan_Vaccination_Program.dart';
import 'package:my_child/views/home_screen/views_drawer/My_Schedules.dart';
import 'package:my_child/views/widgets/app_image.dart';

class HomePage extends StatefulWidget {
  final int initialTab; // ✅ إضافة رقم التبويب المطلوب
  const HomePage({super.key, this.initialTab = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _ViewList = [
    HomeView(),
    JordanVaccinationProgram(),
    MySchedules(),
    HealthCenterLocations(),
  ];

  late int viewIndex;

  @override
  void initState() {
    super.initState();
    viewIndex = widget.initialTab; // ✅ استخدم التبويب الممرر
  }

  void _changeView(int vIndex) {
    setState(() {
      viewIndex = vIndex;
      context.popScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: primaryBlueColor,
        child: ListView(
          padding: const EdgeInsets.only(top: 65),
          children: [
            DrawerItem(
              assetName: "assets/icons/vaccination.svg",
              height: 35,
              width: 35,
              label: "برنامج التطعيم الاردني",
              onTapFunction: () {
                _changeView(1);
              },
            ),
            DrawerItem(
              height: 35,
              width: 35,
              assetName: "assets/icons/calendar.svg",
              label: "مواعيدي",
              onTapFunction: () {
                _changeView(2);
              },
            ),
            DrawerItem(
              height: 35,
              width: 35,
              assetName: "assets/icons/location.svg",
              label: "مراكز ومواعيد التطعيم",
              onTapFunction: () {
                _changeView(3);
              },
            ),
            
            DrawerItem(
              height: 35,
              width: 35,
              assetName: "assets/icons/exit.svg",
              label: "تسجيل الخروج",
              onTapFunction: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  animType: AnimType.scale,
                  title: 'تسجيل خروج',
                  desc: 'هل انت متاكد تريد الخروج؟',
                  btnOkText: "موافق",
                  btnCancelText: "رفض",
                  btnCancelOnPress: () {},
                  btnOkOnPress: () {
                    context.pushRemoveUntil("/login");
                  },
                ).show();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        clipBehavior: Clip.none,
        centerTitle: true,
        forceMaterialTransparency: true,
        toolbarHeight: 55,
        title: Padding(
          padding: const EdgeInsets.only(top: 37.0),
          child: AppImage(
            imagename: "assets/images/my_childws.png",
            width: 75,
            height: 75,
          ),
        ),
        actions: [
          AppBarIcons(
            iconName: Icons.notifications_outlined,
            leftPadding: 10,
          ),
          if (viewIndex != 0)
            GestureDetector(
              onTap: () {
                _changeView(0);
              },
              child: AppBarIcons(
                iconName: Icons.home_rounded,
              ),
            ),
        ],
      ),
      body: _ViewList[viewIndex],
    );
  }
}

class AppBarIcons extends StatelessWidget {
  const AppBarIcons({
    super.key,
    required this.iconName,
    this.size = 30,
    this.leftPadding = 20,
  });
  final IconData iconName;
  final double size;
  final double leftPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding),
      child: Icon(
        iconName,
        size: size,
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  const DrawerItem({
    super.key,
    required this.label,
    required this.onTapFunction,
    required this.assetName,
    this.height,
    this.width,
  });

  final String label;
  final void Function() onTapFunction;
  final String assetName;
  final double? height;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: primaryWhiteColor.withOpacity(0.4),
          borderRadius: BorderRadius.circular(7),
        ),
        child: SvgPicture.asset(
          assetName,
          height: height,
          width: width,
          colorFilter: ColorFilter.mode(primaryWhiteColor, BlendMode.srcATop),
        ),
      ),
      title: Text(
        label,
        style: const TextStyle(fontSize: 25, color: primaryWhiteColor),
      ),
      onTap: onTapFunction,
    );
  }
}