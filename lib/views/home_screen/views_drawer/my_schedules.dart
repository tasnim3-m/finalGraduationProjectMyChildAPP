import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:my_child/app/style/style_color.dart';
import 'package:my_child/views/widgets/app_table.dart';

class VaccineScheduleModel {
  final String vaccineName;
  final int doseNumber;
  final DateTime dueDate;
  final String status;

  VaccineScheduleModel({
    required this.vaccineName,
    required this.doseNumber,
    required this.dueDate,
    required this.status,
  });
}

class MySchedules extends StatefulWidget {
  const MySchedules({super.key});

  @override
  State<MySchedules> createState() => _MySchedulesState();
}

class _MySchedulesState extends State<MySchedules> {
  List<VaccineScheduleModel> scheduleList = [];
  List<DateTime> vaccineDates = [];
  bool isLoading = true;
  String errorMessage = '';
  DateTime? birthDate;
  DateTime? firstDueDate;

  @override
  void initState() {
    super.initState();
    _loadSchedule();
  }

  Future<void> _loadSchedule() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final nationalId = prefs.getString('selected_child_id');
      if (nationalId == null) {
        setState(() {
          errorMessage = 'الرقم الوطني غير موجود.';
          isLoading = false;
        });
        return;
      }

      final supabase = Supabase.instance.client;

      final person = await supabase
          .from('Person')
          .select('Birth_Date')
          .eq('National_Id', nationalId)
          .maybeSingle() as Map<String, dynamic>?;

      if (person == null || person['Birth_Date'] == null) {
        setState(() {
          errorMessage = 'لم يتم العثور على تاريخ الميلاد.';
          isLoading = false;
        });
        return;
      }

      birthDate = DateTime.parse(person['Birth_Date']);

      final doses = await supabase
          .from('Vax_Doses_Age_Test')
          .select('Vax_Id, Dose_Number, Due_Age_Days, Vax(Vax_Name)')
          .order('Due_Age_Days', ascending: true)
          .then((res) => res as List<dynamic>);

      final now = DateTime.now();
      final List<VaccineScheduleModel> schedule = [];
      final List<DateTime> allDates = [];

      for (var dose in doses) {
        final int days = dose['Due_Age_Days'];
        final dueDate = birthDate!.add(Duration(days: days));
        final String vaxName = dose['Vax']['Vax_Name'] ?? 'غير معروف';
        final int doseNum = dose['Dose_Number'];
        final status = dueDate.isBefore(now) ? 'متأخر' : 'قادم';

        schedule.add(VaccineScheduleModel(
          vaccineName: vaxName,
          doseNumber: doseNum,
          dueDate: dueDate,
          status: status,
        ));

        for (int i = 0; i < 7; i++) {
          allDates.add(dueDate.add(Duration(days: i)));
        }
      }

      firstDueDate = schedule.isNotEmpty ? schedule[0].dueDate : null;

      setState(() {
        scheduleList = schedule;
        vaccineDates = allDates;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'حدث خطأ أثناء التحميل:\n$e';
        isLoading = false;
      });
    }
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is DateTime && args.value == firstDueDate) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('موعد أول تطعيم'),
          content: const Text(
              'هذا هو أول يوم للتطعيم، لديك أسبوع لإتمام الجرعات المطلوبة.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('حسناً'),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 60, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 350,
            child: SfDateRangePicker(
              onSelectionChanged: _onSelectionChanged,
              headerStyle: DateRangePickerHeaderStyle(
                backgroundColor: primaryWhiteColor,
              ),
              backgroundColor: primaryWhiteColor,
              selectionColor: primaryBlueColor,
              todayHighlightColor: primaryBlueColor,
              monthViewSettings: DateRangePickerMonthViewSettings(
                specialDates: [
                  if (firstDueDate != null) firstDueDate!,
                  ...vaccineDates.where((d) => d != firstDueDate),
                ],
              ),
              monthCellStyle: DateRangePickerMonthCellStyle(
                specialDatesDecoration: BoxDecoration(
                  color: primaryBlueColor.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                todayCellDecoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 1.5),
                  shape: BoxShape.circle,
                ),
                specialDatesTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (isLoading)
            const Center(child: CircularProgressIndicator())
          else if (errorMessage.isNotEmpty)
            Center(child: Text(errorMessage))
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "المطاعيم",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  for (var vaccine in scheduleList)
                    VaccineCard(vaccine: vaccine),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class VaccineCard extends StatelessWidget {
  final VaccineScheduleModel vaccine;

  const VaccineCard({super.key, required this.vaccine});

  @override
  Widget build(BuildContext context) {
    final statusColor =
        vaccine.status == 'متأخر' ? Colors.red : primaryBlueColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(5),
          1: FlexColumnWidth(8),
        },
        border: TableBorder.all(
          borderRadius: BorderRadius.circular(10),
        ),
        children: [
          TableRow(children: [
            const TableHeaderV(
              text: "اسم المطعوم",
              borderRadius: BorderRadius.only(topRight: Radius.circular(10)),
            ),
            TableDetailsV(text: vaccine.vaccineName),
          ]),
          TableRow(children: [
            const TableHeaderV(text: "التاريخ"),
            TableDetailsV(
                text: vaccine.dueDate.toLocal().toString().split(' ')[0]),
          ]),
          TableRow(children: [
            const TableHeaderV(text: "الجرعة"),
            TableDetailsV(text: '${vaccine.doseNumber}'),
          ]),
          TableRow(children: [
            const TableHeaderV(
              text: "الحالة",
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(10)),
            ),
            TableDetailsV(
              text: vaccine.status,
              textColor: statusColor,
            ),
          ]),
        ],
      ),
    );
  }
}
