import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:my_child/app/utils/extentions_utils.dart';
import 'package:my_child/views/view_model/family_member_view_model.dart';
import 'package:my_child/views/widgets/app_image.dart';
import 'package:my_child/views/widgets/buld_table.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FamilyMembersLogin extends StatefulWidget {
  const FamilyMembersLogin({super.key});

  @override
  State<FamilyMembersLogin> createState() => _FamilyMembersLoginState();
}

class _FamilyMembersLoginState extends State<FamilyMembersLogin> {
  final FamilyMemberViewModel _familyMemberViewModel = FamilyMemberViewModel();

  @override
  void initState() {
    super.initState();
    getFamilyMember();
  }

  void getFamilyMember() async {
    final prefs = await SharedPreferences.getInstance();
    final familyCardId = prefs.getString('Family_Card_Id');

    if (familyCardId == null) {
      context.showAppSnackBar(message: "لم يتم العثور على رقم دفتر العائلة");
      return;
    }

    await _familyMemberViewModel.getChildrenByFamilyBookNumber(familyCardId);

    if (_familyMemberViewModel.errorMessage.isNotEmpty) {
      context.showAppSnackBar(message: _familyMemberViewModel.errorMessage);
    }

    setState(() {});
  }

  void _showLogoutDialog() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.scale,
      title: 'تسجيل خروج',
      desc: 'هل تريد تسجيل الخروج؟',
      btnOkText: "نعم",
      btnCancelText: "لا",
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        context.pushRemoveUntil("/login");
      },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        centerTitle: true,
        forceMaterialTransparency: true,
        clipBehavior: Clip.none,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // أيقونة تسجيل الخروج
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _showLogoutDialog,
            ),
            // شعار الوزارة في المنتصف
            const Expanded(
              child: Center(
                child: AppImage(
                  imagename: "assets/images/my_childws.png",
                  width: 75,
                  height: 75,
                ),
              ),
            ),
            const SizedBox(width: 40), // مساحة موازنة
          ],
        ),
      ),
      body: _familyMemberViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.only(top: 50, bottom: 30),
              child: Column(
                children: [
                  for (var child in _familyMemberViewModel.familyMemberList)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 15),
                      child: buildTable(
                        context,
                        '${child.First_Name} ${child.Last_Name}',
                        child.id,
                        "/home",
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}
