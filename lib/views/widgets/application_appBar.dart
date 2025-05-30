import 'package:flutter/material.dart';
import 'package:my_child/views/widgets/app_image.dart';

class ApplicationAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ApplicationAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      //any thig out of the edges of the app bar make if un hidden ,,show it
      //show the thing even thoug it is bigger than the space of app bar
      clipBehavior: Clip.none,
      centerTitle: true,
      forceMaterialTransparency: true,
//edit the numbers
      toolbarHeight: 55,
      title: Padding(
        padding: const EdgeInsets.only(top: 37.0),
        child: AppImage(
          imagename: "assets/images/my_childws.png",
          width: 75,
          height: 75,
        ),
      ),
      actions: [],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
