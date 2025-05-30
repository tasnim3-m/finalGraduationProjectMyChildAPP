// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:my_child/app/style/style_color.dart';
// import 'package:my_child/views/widgets/app_table.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class JordanVaccinationProgram extends StatefulWidget {
//   const JordanVaccinationProgram({super.key});

//   @override
//   State<JordanVaccinationProgram> createState() =>
//       _JordanVaccinationProgramState();
// }

// class _JordanVaccinationProgramState extends State<JordanVaccinationProgram> {
//   String? nationalId;
//   Map<String, dynamic>? childData;
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     fetchChildData();
//   }

//   Future<void> fetchChildData() async {
//     final prefs = await SharedPreferences.getInstance();
//     nationalId = prefs.getString('selected_child_id');

//     if (nationalId == null) {
//       setState(() => isLoading = false);
//       return;
//     }

//     try {
//       final supabase = Supabase.instance.client;

//       final response = await supabase
//           .from('Person')
//           .select()
//           .eq('National_Id', nationalId as Object)
//           .single();

//       setState(() {
//         childData = response;
//         isLoading = false;
//       });
//     } catch (e) {
//       print("خطأ أثناء جلب البيانات: $e");
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }

//     if (childData == null) {
//       return const Scaffold(
//         body: Center(child: Text("لم يتم العثور على بيانات الطفل")),
//       );
//     }

//     return Container(
//       margin: const EdgeInsets.only(top: 40),
//       child: ListView(
//         children: [
//           ChildInfoContainer(
//             data1: "اسم الطفل",
//             data2: "الرقم الوطني",
//             backgroundColor: primaryBlueColor,
//             firstIconName: "assets/icons/person.svg",
//             secondIconName: "assets/icons/id-card.svg",
//             textColor: primaryWhiteColor,
//           ),
//           ChildInfoContainer(
//             data1: "${childData!['First_Name']} ${childData!['Last_Name']}",
//             data2: childData!['National_Id'].toString(),
//           ),
//           ChildInfoContainer(
//             data1: "الجنس",
//             data2: "تاريخ الميلاد",
//             backgroundColor: primaryBlueColor,
//             firstIconName: "assets/icons/gender.svg",
//             secondIconName: "assets/icons/date.svg",
//             textColor: primaryWhiteColor,
//           ),
//           ChildInfoContainer(
//             data1: childData!['Gender'],
//             data2: childData!['Birth_Date'],
//           ),
//           ChildInfoContainer(
//             data1: "العنوان",
//             data2: "رقم الهاتف",
//             backgroundColor: primaryBlueColor,
//             firstIconName: "assets/icons/address.svg",
//             secondIconName: "assets/icons/phone.svg",
//             textColor: primaryWhiteColor,
//           ),
//         ChildInfoContainer(
//   data1: childData!['City'] ?? "غير معروف",
//   data2: childData!['Phone_Number']?.toString() ?? "غير معروف",
// ),

//           const SizedBox(height: 30),

//           // باقي عناصر جدول المطاعيم تبقى كما هي أو تربطها بالداتا لاحقاً حسب جدولك
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_child/app/style/style_color.dart';
import 'package:my_child/views/widgets/app_table.dart';
import 'package:my_child/views/widgets/application_appBar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JordanVaccinationProgram extends StatefulWidget {
  const JordanVaccinationProgram({super.key});

  @override
  State<JordanVaccinationProgram> createState() =>
      _JordanVaccinationProgramState();
}

class _JordanVaccinationProgramState extends State<JordanVaccinationProgram> {
  bool isLoading = true;
  String? errorMessage;
  String? nationalId;
  Map<String, dynamic>? childData;
  List<Map<String, String?>> vaxRecords = [];

  @override
  void initState() {
    super.initState();
    _fetchChildData();
  }

  Future<void> _fetchChildData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      nationalId = prefs.getString('selected_child_id');

      if (nationalId == null) throw 'لم يتم العثور على الرقم الوطني.';

      final supabase = Supabase.instance.client;

      final person = await supabase
          .from('Person')
          .select('First_Name,Last_Name,Gender,Birth_Date,Regions,Phone_Number')
          .eq('National_Id', nationalId!)
          .maybeSingle();

      if (person == null) throw 'لم يتم العثور على بيانات الطفل.';

      childData = person;

      final vaxCards = await supabase
          .from('PersonVaxCard')
          .select('Vax_ID,Date_Of_Dose,Dose_Num')
          .eq('Person_ID', nationalId!)
          .order('Date_Of_Dose', ascending: true) as List<dynamic>;

      final vaxIds = vaxCards.map((e) => e['Vax_ID'] as int).toList();

      List<Map<String, dynamic>> vaxList = [];
      if (vaxIds.isNotEmpty) {
        final rawVax = await supabase
            .from('Vax')
            .select('Vax_Id,Vax_Name')
            .filter('Vax_Id', 'in', '(${vaxIds.join(',')})') as List<dynamic>;
        vaxList = rawVax.cast<Map<String, dynamic>>();
      }

      final records = <Map<String, String?>>[];
      for (var card in vaxCards) {
        final vaxName = vaxList.firstWhere((v) => v['Vax_Id'] == card['Vax_ID'],
            orElse: () => {'Vax_Name': 'غير معروف'})['Vax_Name'];

        records.add({
          'vaxName': vaxName?.toString(),
          'date': (card['Date_Of_Dose'] as String?)?.split('T').first ?? '',
          'doseNum': card['Dose_Num']?.toString() ?? '',
        });
      }

      setState(() {
        isLoading = false;
        vaxRecords = records;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: ApplicationAppBar(),
        body: Center(
          child: Text(errorMessage!, style: const TextStyle(color: Colors.red)),
        ),
      );
    }

    final fullName = '${childData!['First_Name']} ${childData!['Last_Name']}';
    final gender = childData!['Gender'] ?? 'غير معروف';
    final birthDate = (childData!['Birth_Date'] as String).split('T').first;
    final city = childData!['Regions'] ?? 'غير معروف';
    final phone = childData!['Phone_Number']?.toString() ?? 'غير معروف';

    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(height: 50),
          ChildInfoContainer(
            data1: "اسم الطفل",
            data2: "الرقم الوطني",
            backgroundColor: primaryBlueColor,
            firstIconName: "assets/icons/person.svg",
            secondIconName: "assets/icons/id-card.svg",
            textColor: primaryWhiteColor,
          ),
          ChildInfoContainer(data1: fullName, data2: nationalId!),
          ChildInfoContainer(
            data1: "الجنس",
            data2: "تاريخ الميلاد",
            backgroundColor: primaryBlueColor,
            firstIconName: "assets/icons/gender.svg",
            secondIconName: "assets/icons/date.svg",
            textColor: primaryWhiteColor,
          ),
          ChildInfoContainer(data1: gender, data2: birthDate),
          ChildInfoContainer(
            data1: "العنوان",
            data2: "رقم الهاتف",
            backgroundColor: primaryBlueColor,
            firstIconName: "assets/icons/address.svg",
            secondIconName: "assets/icons/phone.svg",
            textColor: primaryWhiteColor,
          ),
          ChildInfoContainer(data1: city, data2: phone),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child:
                Text("المطاعيم", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                for (var record in vaxRecords) ...[
                  Table(
                    columnWidths: const {
                      0: FlexColumnWidth(5),
                      1: FlexColumnWidth(8),
                    },
                    border: TableBorder.all(
                        borderRadius: BorderRadius.circular(10)),
                    children: [
                      TableRow(children: [
                        const TableHeaderV(text: "اسم المطعوم"),
                        TableDetailsV(text: record['vaxName'] ?? 'غير معروف'),
                      ]),
                      TableRow(children: [
                        const TableHeaderV(text: "التاريخ"),
                        TableDetailsV(text: record['date'] ?? 'غير معروف'),
                      ]),
                      TableRow(children: [
                        const TableHeaderV(text: "الجرعة"),
                        TableDetailsV(text: record['doseNum'] ?? 'غير معروف'),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ChildInfoContainer extends StatelessWidget {
  const ChildInfoContainer({
    super.key,
    required this.data1,
    required this.data2,
    this.firstIconName,
    this.secondIconName,
    this.backgroundColor,
    this.textColor,
    this.ICONw = 25,
    this.ICONh = 25,
  });
  final String data1;
  final String data2;
  final String? firstIconName;
  final String? secondIconName;
  final Color? backgroundColor;
  final Color? textColor;

  final double ICONw;
  final double ICONh;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: backgroundColor,
          border:
              Border.symmetric(horizontal: BorderSide(color: Colors.black))),
      child: Row(
        children: [
          childInformation(
            IconName: firstIconName,
            iconH: ICONh,
            iconW: ICONw,
            data: data1,
            textColor: textColor,
          ),
          childInformation(
            IconName: secondIconName,
            iconH: ICONh,
            iconW: ICONw,
            data: data2,
            textColor: textColor,
          )
        ],
      ),
    );
  }
}

class childInformation extends StatelessWidget {
  const childInformation({
    super.key,
    this.IconName,
    required this.data,
    this.textColor,
    this.iconW,
    this.iconH,
  });
  final String data;
  final String? IconName;
  final Color? textColor;
  final double? iconW;
  final double? iconH;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListTile(
        leading: IconName != null
            ? SvgPicture.asset(
                IconName!,
                // تعيين اللون الأبيض لجميع الأيقونات
                colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                width: iconW,
                height: iconH,
              )
            : SizedBox.shrink(),
        title: Text(
          data,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
