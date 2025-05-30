import 'dart:async';
import 'package:flutter/material.dart';
import 'package:my_child/app/utils/extentions_utils.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Otp extends StatefulWidget {
  const Otp({super.key});

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  int countdown = 60;
  late final Timer _timer;

  String? _phoneNumber;
  String _fetchedOtpCode = '';

  @override
  void initState() {
    super.initState();
    _startCountdown();
    _fetchOtpCode();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown == 0) {
        timer.cancel();
      } else {
        setState(() {
          countdown--;
        });
      }
    });
  }

  Future<void> _fetchOtpCode() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('phone_number');
    if (phone == null) return;

    final supabase = Supabase.instance.client;
    final otpRecords =
        await supabase.from('otp_codes').select().eq('phone_number', phone);

    if (otpRecords.isNotEmpty) {
      final otp = otpRecords[0]['otp_code'] as String;
      setState(() {
        _phoneNumber = phone;
        _fetchedOtpCode = otp;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('رمز التحقق'),
            content: Text('رمزك هو: $_fetchedOtpCode'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('حسناً'),
              ),
            ],
          ),
        );
      });
    }
  }

  Future<void> _verifyAndCreateAccount() async {
    final prefs = await SharedPreferences.getInstance();
    final familyId = prefs.getString('signup_family_id');
    final phone = prefs.getString('signup_phone');
    final password = prefs.getString('signup_password');

    if (familyId != null && phone != null && password != null) {
      final supabase = Supabase.instance.client;

      final existing = await supabase
          .from('user_accounts')
          .select('Family_Card_Id')
          .eq('Family_Card_Id', familyId);

      if (existing.isEmpty) {
        await supabase.from('user_accounts').insert({
          'Family_Card_Id': familyId,
          'password': password,
          'phone_number': phone,
        });

        // حذف البيانات المؤقتة
        prefs.remove('signup_family_id');
        prefs.remove('signup_password');
        prefs.remove('signup_phone');

        context.pushRemoveUntil('/familylog');
      }
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/my_childws.png"),
            const SizedBox(height: 16),
            Text(
              _phoneNumber != null
                  ? "تم إرسال رمز التحقق إلى الرقم $_phoneNumber"
                  : "تم إرسال رمز التحقق إلى الرقم المدخل",
              style: TextStyle(color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Directionality(
              textDirection: TextDirection.ltr,
              child: PinCodeTextField(
                appContext: context,
                length: 4,
                onChanged: (_) {},
                onCompleted: (value) {
                  if (value == _fetchedOtpCode) {
                    _verifyAndCreateAccount();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('رمز التحقق غير صحيح')),
                    );
                  }
                },
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text("إعادة إرسال الرمز خلال ${countdown}s",
                style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
