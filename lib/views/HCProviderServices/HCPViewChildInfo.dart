import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_child/app/style/style_color.dart';
import 'package:my_child/views/widgets/app_table.dart';
import 'package:my_child/views/widgets/application_appBar.dart';

import '../home_screen/views_drawer/Jordan_Vaccination_Program.dart';

class Hcpviewchildinfo extends StatefulWidget {
  const Hcpviewchildinfo({super.key});

  @override
  State<Hcpviewchildinfo> createState() => _HcpviewchildinfoState();
}

class _HcpviewchildinfoState extends State<Hcpviewchildinfo> {
  bool _isLoading = true;
  String? _errorMessage;
  String? _storedNationalId;
  Map<String, dynamic>? _childInfo;

  List<Map<String, String?>> _vaxRecords = [];

  @override
  void initState() {
    super.initState();
    _fetchChildData();
  }

  Future<void> _fetchChildData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final nationalId = prefs.getString('Child_National_Id');
      if (nationalId == null) {
        throw 'لم يتم العثور على الرقم الوطني للطفل.';
      }
      _storedNationalId = nationalId;

      final supabase = Supabase.instance.client;

      final personData = await supabase
          .from('Person')
          .select(
              'National_Id,First_Name,Last_Name,Gender,Birth_Date,Regions,Phone_Number')
          .eq('National_Id', nationalId)
          .maybeSingle();

      if (personData == null) {
        throw 'لا توجد بيانات لهذا الرقم الوطني.';
      }
      _childInfo = personData;

      final vaxCards = await supabase
          .from('PersonVaxCard')
          .select('Vax_ID,Date_Of_Dose,Dose_Num')
          .eq('Person_ID', nationalId)
          .order('Date_Of_Dose', ascending: true) as List<dynamic>;

      final vaxIds = vaxCards.map((c) => c['Vax_ID'] as int).toList();
      print(vaxIds);
      List<Map<String, dynamic>> vaxList = [];
      if (vaxIds.isNotEmpty) {
        final rawVaxList = await supabase
            .from('Vax')
            .select('Vax_Id,Vax_Name')
            .filter('Vax_Id', 'in', '(${vaxIds.join(',')})') as List<dynamic>;
        vaxList = rawVaxList.cast<Map<String, dynamic>>();
        print(vaxList);
      }

      final records = <Map<String, String?>>[];
      for (var card in vaxCards) {
        final int vid = card['Vax_ID'] as int;
        final String? name = vaxList
            .firstWhere((v) => v['Vax_Id'] == vid,
                orElse: () => {'Vax_Name': null})['Vax_Name']
            ?.toString();
        final String? date =
            (card['Date_Of_Dose'] as String?)?.split('T').first;
        final String? doseNum = (card['Dose_Num'] as dynamic)?.toString();

        records.add({
          'vaxName': name ?? 'null',
          'date': date ?? 'null',
          'doseNum': doseNum ?? 'null',
        });
      }

      setState(() {
        _vaxRecords = records;
        _isLoading = false;
      });
    } catch (e, stack) {
      print('Error in _fetchChildData: $e');
      print(stack);
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: ApplicationAppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (_errorMessage != null) {
      return Scaffold(
        appBar: ApplicationAppBar(),
        body: Center(
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    final fullName =
        '${_childInfo!['First_Name']?.toString() ?? 'null'} ${_childInfo!['Last_Name']?.toString() ?? 'null'}';
    final displayedNationalId = _storedNationalId ?? 'null';
    final gender = _childInfo!['Gender']?.toString() ?? 'null';
    final birthDate =
        (_childInfo!['Birth_Date'] as String?)?.split('T').first ?? 'null';
    final regions = _childInfo!['Regions']?.toString() ?? 'null';
    final phone = _childInfo!['Phone_Number']?.toString() ?? 'null';

    return Scaffold(
      appBar: ApplicationAppBar(),
      body: Container(
        margin: const EdgeInsets.only(top: 40),
        child: ListView(
          children: [
            ChildInfoContainer(
              data1: "اسم الطفل",
              data2: " لرقم الوطني",
              backgroundColor: primaryBlueColor,
              firstIconName: "assets/icons/person.svg",
              secondIconName: "assets/icons/id-card.svg",
              textColor: primaryWhiteColor,
            ),
            ChildInfoContainer(data1: fullName, data2: _storedNationalId!),
            ChildInfoContainer(
              data1: "الجنس",
              data2: "التاريخ",
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
            ChildInfoContainer(data1: regions, data2: phone),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/AddNewVax')
                        .then((value) => _fetchChildData()),
                    icon: const Icon(Icons.add),
                    label: const Text("إضافة مطعوم جديد"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlueColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("المطاعيم",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  for (var record in _vaxRecords) ...[
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(5),
                        1: FlexColumnWidth(8),
                      },
                      border: TableBorder.all(
                          borderRadius: BorderRadius.circular(10)),
                      children: [
                        TableRow(children: [
                          TableHeaderV(
                            text: "اسم المطعوم",
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10)),
                          ),
                          TableDetailsV(text: record['vaxName']!),
                        ]),
                        TableRow(children: [
                          TableHeaderV(
                            text: " التاريخ",
                          ),
                          TableDetailsV(text: record['date']!)
                        ]),
                        TableRow(children: [
                          TableHeaderV(
                            text: "حالة التطعيم",
                            borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(10)),
                          ),
                          TableDetailsV(text: record['doseNum']!),
                        ]),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
