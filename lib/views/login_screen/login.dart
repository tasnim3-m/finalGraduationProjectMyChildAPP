import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:my_child/app/style/style_color.dart';
import 'package:my_child/app/utils/extentions_utils.dart';
import 'package:my_child/views/widgets/add_text_field.dart';
import 'package:my_child/views/widgets/app_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController familyCardController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    familyCardController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final supabase = Supabase.instance.client;
    final familyCardId = familyCardController.text.trim();
    final password = passwordController.text.trim();

    if (familyCardId.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("يرجى إدخال جميع الحقول")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await supabase
          .from('user_accounts')
          .select()
          .eq('Family_Card_Id', familyCardId)
          .eq('password', password);

      if (response.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("بيانات الدخول غير صحيحة")),
        );
      } else {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('Family_Card_Id', familyCardId);
        context.pushRemoveUntil("/familylog");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ أثناء التحقق: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 40,
            bottom: bottomPadding + 20, // ⬅️ عشان الكيبورد
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/images/my_childws.png"),
              const AppImage(
                width: 180,
                height: 180,
                imagename: "assets/images/my_child_logo.png",
              ),
              const SizedBox(height: 30),
              AddTextField(
                inputController: familyCardController,
                hintText: "رقم دفتر العائلة",
                iconName: "assets/icons/fam_card.svg",
                validator: (value) {
                  if ((value ?? "").isEmpty) {
                    return "رقم دفتر العائلة مطلوب";
                  }
                  return null;
                },
                onChanged: (_) {},
                keyBoardTYpe: TextInputType.text,
              ),
              const SizedBox(height: 20),
              AddTextField(
                inputController: passwordController,
                maxlength: 20,
                hintText: "كلمة السر",
                iconName: "assets/icons/password-svgrepo-com (1).svg",
                validator: (value) {
                  if ((value ?? "").isEmpty) {
                    return "كلمة السر مطلوبة";
                  }
                  return null;
                },
                onChanged: (_) {},
                keyBoardTYpe: TextInputType.text,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: MediaQuery.sizeOf(context).width,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlueColor,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                      side: const BorderSide(color: Color(0xffB4B4B4)),
                    ),
                  ),
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "تسجيل الدخول",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
