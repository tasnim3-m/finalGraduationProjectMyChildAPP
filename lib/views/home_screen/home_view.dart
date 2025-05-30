import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:my_child/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:my_child/app/style/style_color.dart';
import 'package:my_child/views/widgets/app_image.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Future<void> initNotifications() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'my_child_app',
      'My Child App',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'مرحباً بك 👶',
      'اضغط هنا لعرض مواعيد التطعيم',
      platformDetails,
      payload: "/MySchedules", // ✅ نستخدمه للتنقل عند الضغط
    );
  }

  String? nationalId;
  Map<String, dynamic>? childData;
  bool isLoading = true;

  @override
  void initState() {
    initNotifications();
    super.initState();
    fetchChildData();
  }

  Future<void> fetchChildData() async {
    final prefs = await SharedPreferences.getInstance();
    nationalId = prefs.getString('selected_child_id');

    if (nationalId == null) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final supabase = Supabase.instance.client;

      final response = await supabase
          .from('Person')
          .select()
          .eq('National_Id', nationalId as Object)
          .single();

      setState(() {
        childData = response;
        isLoading = false;
      });
    } catch (e) {
      print("خطأ: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (childData == null) {
      return const Scaffold(
        body: Center(child: Text("لم يتم العثور على بيانات الطفل")),
      );
    }

    return Scaffold(
        body: Container(
      margin: const EdgeInsets.only(top: 40),
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
              color: primaryBlueColor,
              border: Border.symmetric(
                horizontal: BorderSide(color: primaryGrayColor),
              ),
            ),
            child: ListTile(
              leading: AppImage(
                imagename: childData!['Gender'] == 'أنثى'
                    ? "assets/images/fmalePic.png"
                    : "assets/images/malePic.png",
                width: 85,
                height: 85,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "الاسم: ${childData!['First_Name']} ${childData!['Last_Name']}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "الجنس: ${childData!['Gender']}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    "تاريخ الميلاد: ${childData!['Birth_Date']}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "تعليمات هامة (عزيزتي الأم):",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
          ),
          textIconHome(
              textt:
                  "المطاعيم ضمن البرنامج الوطني للتطعيم تعطى مجانابغض النظر عن الجنسية."),
          textIconHome(
              textt: "ضرورة الإلتزام بالموعيد المحددة وكذالك الجرعات المقررة."),
          textIconHome(
              textt:
                  "بعض الأطفال يمكن أن يصابوا بأعراض جانبية خفيفة مثل الألم الموضعي أو الحمى البسيطة لساعات قليلة بينما الاصابة بالمرض نفسه خطيرة جدًا وتسبب إعاقة مدى الحياة."),
          textIconHome(
              textt:
                  "عند أي أعراض خفيفة في أول يوم بعد التطعيم مثل الإرتفاع الخفيف بدرجة الحرارة وإحمرار وألم بسيط مكانإعطاء الإبرة يمكن إعطاء خافض حرارة ووضع كمادات دافئة مكان الموضع. "),
          textIconHome(
              textt: "راجعي المركز الصحي عند حدوث أي أعراض جانبية غيرخفيفة."),
          textIconHome(
              textt:
                  "بطاقة التطعيم (كرت التطعيم) وثيقة رسمية مهمة وتطبيق طفلي يساعدك على الاحتافظ بها للطفل مدى الحياة.")
        ],
      ),
    ));
  }
}

class textIconHome extends StatelessWidget {
  const textIconHome({
    required this.textt,
    super.key,
  });
  final String textt;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.circle, size: 12),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              textt,
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
