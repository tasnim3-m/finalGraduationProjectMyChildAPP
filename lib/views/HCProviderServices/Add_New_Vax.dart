import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_child/app/style/style_color.dart';
import 'package:my_child/views/widgets/application_appBar.dart';
import 'package:my_child/views/HCProviderServices/lockups.dart'; // الصنف Lockups المشترك

class AppDropDown<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final void Function(T?) onChanged;
  final String hintText;

  const AppDropDown({
    super.key,
    required this.items,
    required this.onChanged,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: items,
      onChanged: onChanged,
    );
  }
}

class Vaccine {
  final String name;
  bool isChecked;
  DateTime? date;
  final int vaxId;
  final int doseNum;

  Vaccine({
    required this.name,
    this.isChecked = false,
    this.date,
    required this.vaxId,
    required this.doseNum,
  });
}

class AddNewVax extends StatefulWidget {
  const AddNewVax({super.key});

  @override
  State<AddNewVax> createState() => _AddNewVaxState();
}

class _AddNewVaxState extends State<AddNewVax> {
  final List<Lockups> months = [
    Lockups(id: 1, name: "مطاعيم الشهر الأول"),
    Lockups(id: 2, name: "مطاعيم الشهر الثاني"),
    Lockups(id: 3, name: "مطاعيم الشهر الثالث"),
    Lockups(id: 4, name: "مطاعيم الشهر الرابع"),
    Lockups(id: 5, name: "مطاعيم الشهر التاسع"),
    Lockups(id: 6, name: "مطاعيم الشهر الثاني عشر"),
    Lockups(id: 7, name: "مطاعيم الشهر الثامن عشر"),
  ];

  final Map<int, List<Vaccine>> vaccinesByMonth = {
    1: [ Vaccine(name: "مطعوم التدرن جرعة 1", vaxId: 111, doseNum: 1) ],
    2: [
      Vaccine(name: "مطعوم السداسي جرعة 1", vaxId: 222, doseNum: 1),
      Vaccine(name: "مطعوم الروتافيروس جرعة 1", vaxId: 333, doseNum: 1),
      Vaccine(name: "مطعوم المكورات الرئوية جرعة 1", vaxId: 555, doseNum: 1),
    ],
    3: [
      Vaccine(name: "مطعوم السداسي جرعة 2", vaxId: 222, doseNum: 2),
      Vaccine(name: "مطعوم الروتافيروس جرعة 2", vaxId: 333, doseNum: 2),
      Vaccine(name: "مطعوم شلل الأطفال جرعة 1", vaxId: 444, doseNum: 1),
    ],
    4: [
      Vaccine(name: "مطعوم السداسي جرعة 3", vaxId: 222, doseNum: 3),
      Vaccine(name: "مطعوم الروتافيروس جرعة 3", vaxId: 333, doseNum: 3),
      Vaccine(name: "مطعوم شلل الأطفال جرعة 2", vaxId: 444, doseNum: 2),
      Vaccine(name: "مطعوم المكورات الرئوية جرعة 2", vaxId: 555, doseNum: 2),
    ],
    5: [
      Vaccine(name: "مطعوم الحصبة جرعة 1", vaxId: 444, doseNum: 1),
      Vaccine(name: "مطعوم فيتامين أ جرعة 1", vaxId: 911, doseNum: 1),
      Vaccine(name: "مطعوم شلل الأطفال جرعة 3", vaxId: 444, doseNum: 3),
    ],
    6: [
      Vaccine(name: "مطعوم المكورات الرئوية جرعة 3", vaxId: 555, doseNum: 3),
      Vaccine(name: "مطعوم التهاب الكبد جرعة 1", vaxId: 777, doseNum: 1),
      Vaccine(name: "مطعوم الثلاثي الفيروسي جرعة 1", vaxId: 999, doseNum: 1),
    ],
    7: [
      Vaccine(name: "مطعوم شلل الأطفال جرعة مدعمة 4", vaxId: 444, doseNum: 4),
      Vaccine(name: "مطعوم التهاب الكبد جرعة 2", vaxId: 777, doseNum: 2),
      Vaccine(name: "مطعوم الثلاثي البكتيري جرعة مدعمة 1", vaxId: 888, doseNum: 1),
      Vaccine(name: "مطعوم الثلاثي الفيروسي جرعة 2", vaxId: 999, doseNum: 2),
      Vaccine(name: "مطعوم فيتامين أ جرعة 2", vaxId: 911, doseNum: 2),
      Vaccine(name: "مطعوم جدري الماء جرعة 1", vaxId: 920, doseNum: 1),
    ],
  };

  Lockups? selectedMonth;
  List<Vaccine> selectedVaccines = [];
  final Set<String> _existingPairs = {};

  @override
  void initState() {
    super.initState();
    _loadExistingVaccines();
  }

  Future<void> _loadExistingVaccines() async {
    final prefs = await SharedPreferences.getInstance();
    final nationalId = prefs.getString('Child_National_Id');
    if (nationalId == null) return;

    final supabase = Supabase.instance.client;
    final rows = await supabase
        .from('PersonVaxCard')
        .select('Vax_ID,Dose_Num')
        .eq('Person_ID', nationalId) as List<dynamic>;

    for (var r in rows) {
      _existingPairs.add('${r['Vax_ID']}:${r['Dose_Num']}');
    }

    if (selectedMonth != null) onMonthChanged(selectedMonth);
    setState(() {});
  }

  void onMonthChanged(Lockups? month) {
    setState(() {
      selectedMonth = month!;
      final all = vaccinesByMonth[month.id] ?? [];
      selectedVaccines = all.where((v) {
        return !_existingPairs.contains('${v.vaxId}:${v.doseNum}');
      }).toList();

      final now = DateTime.now();
      for (var vac in selectedVaccines) {
        vac.date = now;
      }
    });
  }

  Future<void> saveVaccines() async {
    final prefs = await SharedPreferences.getInstance();
    final nationalId = prefs.getString('Child_National_Id');
    if (nationalId == null) return;

    final truncated = nationalId.length > 2
        ? nationalId.substring(0, nationalId.length - 2)
        : nationalId;

    final supabase = Supabase.instance.client;

    if (selectedVaccines.any((v) => v.isChecked && v.date == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب اختيار تاريخ لكل مطعوم مأخوذ!')),
      );
      return;
    }

    for (var v in selectedVaccines) {
      if (v.isChecked) {
        await supabase.from('PersonVaxCard').insert({
          'Person_ID'    : nationalId,
          'VaxCard_ID'   : truncated,
          'Vax_ID'       : v.vaxId,
          'Dose_Num'     : v.doseNum,
          'Date_Of_Dose' : v.date!.toIso8601String(),
        });
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حفظ المطاعيم بنجاح!')),
    );
    _existingPairs.clear();
    await _loadExistingVaccines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const SizedBox(height: 40),
            AppDropDown<Lockups>(
              hintText: "اختر عمر الطفل بالأشهر",
              items: months
                  .map((m) => DropdownMenuItem<Lockups>(
                value: m,
                child: Text(m.name),
              ))
                  .toList(),
              onChanged: onMonthChanged,
            ),
            const SizedBox(height: 20),
            if (selectedMonth != null) ...[
              Text(
                selectedMonth!.name,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              ...selectedVaccines.map((vaccine) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CheckboxListTile(
                    title: Text(vaccine.name),
                    value: vaccine.isChecked,
                    activeColor: primaryBlueColor,
                    onChanged: (chk) => setState(() {
                      vaccine.isChecked = chk ?? false;
                      if (vaccine.isChecked) {
                        vaccine.date = DateTime.now();
                      }
                    }),
                  ),
                  if (vaccine.isChecked)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'التاريخ: ${vaccine.date!.toLocal().toString().split(" ")[0]}',
                      ),
                    ),
                ],
              )),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveVaccines,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlueColor,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('حفظ', style: TextStyle(fontSize: 18)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
