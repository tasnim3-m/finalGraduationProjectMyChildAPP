import 'package:flutter/material.dart';
import 'package:my_child/app/style/style_color.dart';
import 'package:my_child/app/utils/extentions_utils.dart';
import 'package:my_child/views/view_model/HCPLogin_view_model.dart';
import 'package:my_child/views/widgets/add_text_field.dart';
import 'package:my_child/views/widgets/app_image.dart';

class HcproviderLogin extends StatefulWidget {
  const HcproviderLogin({super.key});

  @override
  State<HcproviderLogin> createState() => _HcproviderLoginState();
}

class _HcproviderLoginState extends State<HcproviderLogin> {
  final _formKey = GlobalKey<FormState>();
  //من خلال هذا الاوبجكت بقد اوصل للميثودس يلي داخل الفو مودل
  final HcploginViewModel _hcploginViewModel = HcploginViewModel();
  final TextEditingController _usernameControler = TextEditingController();
  final TextEditingController _passwordControler = TextEditingController();
  Future<void> loginAdmin(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      //طول ما الميثود ما رجعت ريسبوند رح يضل واقف هون
      await _hcploginViewModel.loginHCP(
          _usernameControler.text, _passwordControler.text);

      if (_hcploginViewModel.errorMessage.isNotEmpty) {
        context.showAppSnackBar(message: "رمز الدخول خاطئ");
      } else {
        Navigator.pushNamed(context, '/Hcphome');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 120),
          width: MediaQuery.sizeOf(context).width,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset("assets/images/my_childws.png"),
                AppImage(
                  width: 150,
                  height: 150,
                  imagename: "assets/images/hcprviderLoginLogo.png",
                ),
                SizedBox(height: 20),
                AddTextField(
                  inputController: _usernameControler,
                  maxlength: 10,
                  hintText: "   اسم المستخدم ",
                  iconName: "assets/icons/person.svg",
                  validator: (value) {
                    if ((value ?? "").isEmpty) {
                      return "اسم المستخدم مطلوب ";
                    }
                    return null;
                  },
                  keyBoardTYpe: TextInputType.text,
                ),
                SizedBox(height: 20),
                AddTextField(
                  inputController: _passwordControler,
                  //الهدف منه نتحكم بالمدخلات احدى وظائفه انو ناخد القيمة المخزنة جوا التكست فيلد
                  maxlength: 10,
                  hintText: "   كلمة السر ",
                  iconName: "assets/icons/password-svgrepo-com.svg",
                  validator: (value) {
                    if ((value ?? "").isEmpty) {
                      return "كلمة السر مطلوبة ";
                    } else if (value?.length != 4) {
                      return "يجب أن تكون كلمة السر مكونة من 4 أرقام";
                    } else if (!(RegExp(r'^[0-9]+$').hasMatch(value!))) {
                      return "كلمة السر يجب أن تحتوي فقط على أرقام";
                    }
                    return null;
                  },
                  keyBoardTYpe: TextInputType.number,
                ),
                SizedBox(height: 30),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    onPressed: () => loginAdmin(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlueColor,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                        side: const BorderSide(color: Color(0xffB4B4B4)),
                      ),
                    ),
                    child: const Text(
                      "تسجيل الدخول",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
