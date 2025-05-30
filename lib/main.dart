import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_child/app/style/style_color.dart';
import 'package:my_child/views/HCProviderServices/Add_New_Vax.dart';
import 'package:my_child/views/HCProviderServices/HCPHome.dart';
import 'package:my_child/views/HCProviderServices/HCPViewChildInfo.dart';
import 'package:my_child/views/home_screen/home_page.dart';
import 'package:my_child/views/home_screen/home_view.dart';
import 'package:my_child/views/home_screen/views_drawer/Health_Center_Locations.dart';
import 'package:my_child/views/home_screen/views_drawer/My_Schedules.dart';
import 'package:my_child/views/login_screen/HCprovider_login.dart';
import 'package:my_child/views/login_screen/family_members_login.dart';
import 'package:my_child/views/login_screen/login.dart';
import 'package:my_child/views/sign_up/otp.dart';
import 'package:my_child/views/sign_up/sign_up.dart';
import 'package:my_child/views/splash_screen/chose_user.dart';
import 'package:my_child/views/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as ui;
import 'package:supabase_flutter/supabase_flutter.dart';

// 🔑 المفتاح العالمي للتنقل بين الشاشات
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initSettings =
      InitializationSettings(android: androidSettings);

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload == "/MySchedules") {
        // ✅ ننتقل إلى HomePage مع تبويب "مواعيدي"
        Future.delayed(const Duration(milliseconds: 300), () {
          navigatorKey.currentState?.push(
            MaterialPageRoute(builder: (_) => const HomePage(initialTab: 2)),
          );
        });
      }
    },
  );

  // 🔌 الاتصال بـ Supabase
  await Supabase.initialize(
    url: 'https://stshjbljfcollcdncjmx.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN0c2hqYmxqZmNvbGxjZG5jam14Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIwNjc2NDMsImV4cCI6MjA1NzY0MzY0M30.IzlceKpfDUSoaoh_Kh97TaPT6VkPJMXnxkSnwWin558',
  );

  // 🟢 بدء التطبيق
  runApp(
    ChangeNotifierProvider(
      create: (_) => HealthCenterViewModel(
        HealthCenterRepositoryImpl(
          HealthCenterDataSourceImpl(Supabase.instance.client),
        ),
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      builder: (context, child) {
        return Directionality(
          textDirection: ui.TextDirection.rtl,
          child: child!,
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: primaryWhiteColor,
        fontFamily: "Almarai",
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: const TextStyle(color: Color(0xffB4B4B4)),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffB4B4B4)),
            borderRadius: BorderRadius.circular(15),
          ),
          errorBorder: OutlineInputBorder(
            borderSide:
                const BorderSide(color: Color.fromARGB(255, 182, 15, 15)),
            borderRadius: BorderRadius.circular(15),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffB4B4B4)),
            borderRadius: BorderRadius.circular(15),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffB4B4B4)),
            borderRadius: BorderRadius.circular(15),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xffB4B4B4)),
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        useMaterial3: true,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => SplashScreen(),
        "/login": (context) => LoginPage(),
        "/home": (context) => const HomePage(), // ← تبويب افتراضي
        "/familylog": (context) => const FamilyMembersLogin(),
        "/signup": (context) => SignUp(),
        "/choseUser": (context) => ChoseUser(),
        "/HcproviderLogin": (context) => HcproviderLogin(),
        "/Hcphome": (context) => HCPHome(),
        "/AddNewVax": (context) => AddNewVax(),
        "/Hcpviewchildinfo": (context) => Hcpviewchildinfo(),
        "/Otp": (context) => Otp(),
        "/MySchedules": (context) => MySchedules(), // للتنقل الداخلي فقط
      },
    );
  }
}
