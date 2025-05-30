import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// MODEL
class HealthCenter {
  final String centerName;
  final String governorateName;
  final String brigadeName;
  final String vaccineDays;
  final String vaccineTime;

  HealthCenter({
    required this.centerName,
    required this.governorateName,
    required this.brigadeName,
    required this.vaccineDays,
    required this.vaccineTime,
  });

  factory HealthCenter.fromMap(Map<String, dynamic> map) {
    return HealthCenter(
      centerName: map['Health_Centers'],
      governorateName: map['City_Name'],
      brigadeName: map['Regions_Name'],
      vaccineDays: '', // بيانات ثابتة حالياً
      vaccineTime: '', // بيانات ثابتة حالياً
    );
  }
}

/// DATA SOURCE
class HealthCenterDataSourceImpl {
  final SupabaseClient client;
  HealthCenterDataSourceImpl(this.client);

  Future<List<HealthCenter>> getAllHealthCenters() async {
    final response = await client.from('Regions_and_Cities').select();
    return (response as List)
        .map((item) => HealthCenter.fromMap(item))
        .toList();
  }
}

/// REPOSITORY INTERFACE
abstract class HealthCenterRepository {
  Future<List<HealthCenter>> getAllHealthCenters();
}

/// REPOSITORY IMPLEMENTATION
class HealthCenterRepositoryImpl implements HealthCenterRepository {
  final HealthCenterDataSourceImpl dataSource;
  HealthCenterRepositoryImpl(this.dataSource);

  @override
  Future<List<HealthCenter>> getAllHealthCenters() {
    return dataSource.getAllHealthCenters();
  }
}

/// VIEWMODEL
class HealthCenterViewModel extends ChangeNotifier {
  final HealthCenterRepository repository;
  HealthCenterViewModel(this.repository);

  List<HealthCenter> _allCenters = [];
  List<String> _governorates = [];
  List<String> _brigades = [];
  List<HealthCenter> _filteredCenters = [];

  String? selectedGovernorate;
  String? selectedBrigade;

  List<String> get governorates => _governorates;
  List<String> get brigades => _brigades;
  List<HealthCenter> get filteredCenters => _filteredCenters;

  Future<void> loadCenters() async {
    _allCenters = await repository.getAllHealthCenters();
    _governorates = _allCenters.map((e) => e.governorateName).toSet().toList()
      ..sort();
    notifyListeners();
  }

  void selectGovernorate(String? value) {
    selectedGovernorate = value;
    selectedBrigade = null;
    _brigades = _allCenters
        .where((e) => e.governorateName == selectedGovernorate)
        .map((e) => e.brigadeName)
        .toSet()
        .toList()
      ..sort();
    _filteredCenters = [];
    notifyListeners();
  }

  void selectBrigade(String? value) {
    selectedBrigade = value;
    _filteredCenters = _allCenters
        .where((e) =>
            e.governorateName == selectedGovernorate &&
            e.brigadeName == selectedBrigade)
        .toList();
    notifyListeners();
  }
}

/// WIDGET UI SCREEN
class HealthCenterLocations extends StatefulWidget {
  const HealthCenterLocations({super.key});

  @override
  State<HealthCenterLocations> createState() => _HealthCenterLocationsState();
}

class _HealthCenterLocationsState extends State<HealthCenterLocations> {
  Lockups? selectedGovernorate;
  Lockups? selectedBrigade;

  @override
  void initState() {
    super.initState();
    final viewModel =
        Provider.of<HealthCenterViewModel>(context, listen: false);
    viewModel.loadCenters();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<HealthCenterViewModel>(context);
    List<Lockups> governorates = viewModel.governorates
        .map((name) => Lockups(name.hashCode, name))
        .toList();
    List<Lockups> brigades =
        viewModel.brigades.map((name) => Lockups(name.hashCode, name)).toList();

    return Container(
      margin: const EdgeInsets.only(top: 60),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          AppDropDown(
            hintText: "اختر المحافظة...",
            value: selectedGovernorate,
            items: governorates
                .map((e) => DropdownMenuItem<Lockups>(
                      value: e,
                      child: Text(e.name),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedGovernorate = value;
                selectedBrigade = null;
              });
              if (value != null) {
                viewModel.selectGovernorate(value.name);
              }
            },
          ),
          const SizedBox(height: 20),
          AppDropDown(
            hintText: "اختر اللواء...",
            value: selectedBrigade,
            items: brigades
                .map((e) => DropdownMenuItem<Lockups>(
                      value: e,
                      child: Text(e.name),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedBrigade = value;
              });
              if (value != null) {
                viewModel.selectBrigade(value.name);
              }
            },
          ),
          const SizedBox(height: 40),
          ...viewModel.filteredCenters.map((center) {
            return Table(
              columnWidths: const {
                0: FlexColumnWidth(5),
                1: FlexColumnWidth(8),
              },
              border: TableBorder.all(borderRadius: BorderRadius.circular(10)),
              children: [
                TableRow(children: [
                  TableHeaderV(
                    text: "اسم المركز ",
                    borderRadius:
                        const BorderRadius.only(topRight: Radius.circular(10)),
                  ),
                  TableDetailsV(text: center.centerName)
                ]),
                TableRow(children: [
                  TableHeaderV(
                    text: "ايام التطعيم",
                    borderRadius: const BorderRadius.only(),
                  ),
                  const TableDetailsV(text: "الثلاثاء")
                ]),
                TableRow(children: [
                  TableHeaderV(
                    text: "الوقت",
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(10)),
                  ),
                  const TableDetailsV(text: "الساعة ال 11")
                ]),
              ],
            );
          }),
        ],
      ),
    );
  }
}

/// DROPDOWN HELPER
class AppDropDown extends StatelessWidget {
  const AppDropDown({
    super.key,
    required this.items,
    required this.onChanged,
    required this.hintText,
    this.value,
  });

  final List<DropdownMenuItem<Lockups>> items;
  final void Function(Lockups?) onChanged;
  final String hintText;
  final Lockups? value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: DropdownButtonFormField<Lockups>(
        value: value,
        decoration: InputDecoration(hintText: hintText),
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}

/// LOCKUPS CLASS
class Lockups {
  final String name;
  final int id;
  Lockups(this.id, this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Lockups &&
          runtimeType == other.runtimeType &&
          name == other.name;

  @override
  int get hashCode => name.hashCode;
}

/// TABLE UI COMPONENTS PLACEHOLDER
class TableHeaderV extends StatelessWidget {
  final String text;
  final BorderRadius borderRadius;
  const TableHeaderV({super.key, required this.text, required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blueGrey[100],
        borderRadius: borderRadius,
      ),
      child: Text(text),
    );
  }
}

class TableDetailsV extends StatelessWidget {
  final String text;
  const TableDetailsV({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Text(text),
    );
  }
}
