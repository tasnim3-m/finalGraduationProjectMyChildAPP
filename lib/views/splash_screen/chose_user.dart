import 'package:flutter/material.dart';
import 'package:my_child/app/style/style_color.dart';
import 'package:my_child/app/utils/extentions_utils.dart';
import 'package:my_child/views/widgets/app_image.dart';

class ChoseUser extends StatefulWidget {
  const ChoseUser({super.key});

  @override
  State<ChoseUser> createState() => _ChoseUserState();
}

class _ChoseUserState extends State<ChoseUser> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
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
              ),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  children: [
                    AddButton(
                        routeName: '/HcproviderLogin',
                        text: 'مقدم الرعاية الصحية'),
                    SizedBox(height: 50),
                    AddButton(
                      routeName: '/signup',
                      text: 'كرت المطاعيم للأطفال',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  final String text;
  final String routeName;

  const AddButton({
    super.key,
    required this.text,
    required this.routeName,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryBlueColor,
          elevation: 0,
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(13),
            side: BorderSide(color: Color(0xffB4B4B4)),
          ),
        ),
        onPressed: () {
          context.sendToNextScreen(routeName);
        },
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
