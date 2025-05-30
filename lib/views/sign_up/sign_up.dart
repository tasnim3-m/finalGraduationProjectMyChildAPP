import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:my_child/app/style/style_color.dart';
import 'package:my_child/app/utils/extentions_utils.dart';
import 'package:my_child/views/widgets/add_text_field.dart';
import 'package:my_child/views/widgets/app_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController familyCardController = TextEditingController();
  final TextEditingController fatherIdController = TextEditingController();
  final TextEditingController motherIdController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final supabase = Supabase.instance.client;
    final familyCardId = familyCardController.text.trim();
    final fatherId = fatherIdController.text.trim();
    final motherId = motherIdController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone_number', phone);

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("كلمتا المرور غير متطابقتين")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final persons = await supabase
          .from('Person')
          .select('Phone_Number')
          .eq('Family_Card_Id', familyCardId)
          .eq('Father_National_Id', fatherId)
          .eq('Mother_National_Id', motherId) as List<dynamic>;

      if (persons.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("المعلومات غير موجودة في قاعدة البيانات")),
        );
        return;
      }

      final person = persons.first as Map<String, dynamic>;
      final dbPhone = person['Phone_Number'].toString();
      if (dbPhone.trim() != phone) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("رقم الهاتف لا يتطابق مع المسجل")),
        );
        return;
      }

      // توليد رمز عشوائي
      final randomOtp =
          (1000 + (DateTime.now().millisecondsSinceEpoch % 9000)).toString();

      // حذف رمز قديم
      await supabase.from('otp_codes').delete().eq('phone_number', phone);

      // تخزين OTP
      await supabase.from('otp_codes').insert({
        'phone_number': phone,
        'otp_code': randomOtp,
      });

      // تخزين بيانات التسجيل مؤقتاً
      await prefs.setString('signup_family_id', familyCardId);
      await prefs.setString('signup_password', password);
      await prefs.setString('signup_phone', phone);

      context.pushRemoveUntil('/Otp');
    } catch (e) {
      print("حدث خطأ: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("حدث خطأ: $e")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        leading: const Icon(Icons.login),
        title: const AppImage(
          imagename: "assets/images/my_childws.png",
          width: 60,
          height: 60,
        ),
        actions: const [SizedBox(width: 30)],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text("إنشاء حساب جديد",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryBlueColor)),
                const SizedBox(height: 30),
                AddTextField(
                  inputController: familyCardController,
                  hintText: "رقم دفتر العائلة",
                  iconName: 'assets/icons/fam_card.svg',
                  onChanged: (_) {},
                  validator: (v) => v == null || v.isEmpty
                      ? "الرجاء إدخال رقم دفتر العائلة"
                      : null,
                ),
                const SizedBox(height: 20),
                AddTextField(
                  inputController: fatherIdController,
                  hintText: "الرقم الوطني للأب",
                  iconName: 'assets/icons/id-card.svg',
                  onChanged: (_) {},
                  validator: (v) => v == null || v.isEmpty
                      ? "الرجاء إدخال الرقم الوطني للأب"
                      : null,
                ),
                const SizedBox(height: 20),
                AddTextField(
                  inputController: motherIdController,
                  hintText: "الرقم الوطني للأم",
                  iconName: 'assets/icons/id-card.svg',
                  onChanged: (_) {},
                  validator: (v) => v == null || v.isEmpty
                      ? "الرجاء إدخال الرقم الوطني للأم"
                      : null,
                ),
                const SizedBox(height: 20),
                AddTextField(
                  inputController: phoneController,
                  hintText: "رقم الهاتف",
                  iconName: 'assets/icons/call.svg',
                  onChanged: (_) {},
                  validator: (v) =>
                      v == null || v.isEmpty ? "الرجاء إدخال رقم الهاتف" : null,
                ),
                const SizedBox(height: 20),
                AddTextField(
                  inputController: passwordController,
                  hintText: "إنشاء كلمة المرور",
                  iconName: 'assets/icons/password-svgrepo-com (1).svg',
                  onChanged: (_) {},
                  validator: (v) => v == null || v.isEmpty
                      ? "الرجاء إدخال كلمة المرور"
                      : null,
                ),
                const SizedBox(height: 20),
                AddTextField(
                  inputController: confirmPasswordController,
                  hintText: "تأكيد كلمة المرور",
                  iconName: 'assets/icons/password-svgrepo-com.svg',
                  onChanged: (_) {},
                  validator: (v) => v == null || v.isEmpty
                      ? "الرجاء تأكيد كلمة المرور"
                      : null,
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlueColor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("إنشاء الحساب",
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("لديك حساب بالفعل؟ "),
                    GestureDetector(
                      onTap: () {
                        context.pushRemoveUntil("/login");
                      },
                      child: Text(
                        "تسجيل الدخول",
                        style: TextStyle(
                          color: primaryBlueColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
