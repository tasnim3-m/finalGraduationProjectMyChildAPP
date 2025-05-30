import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_child/views/view_model/search_child_view_model.dart';
import 'package:my_child/views/widgets/application_appBar.dart';
import 'package:my_child/views/widgets/buld_table.dart';

class HCPHome extends StatefulWidget {
  const HCPHome({super.key});

  @override
  State<HCPHome> createState() => _HCPHomeState();
}

class _HCPHomeState extends State<HCPHome> {
  final TextEditingController _searchController = TextEditingController();
  final SearchChildViewModel _viewModel = SearchChildViewModel();

  bool _isLoading = false;

  Future<void> _onSearchSubmitted(String value) async {
    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('Child_National_Id', value);

    await _viewModel.searchByNationalId(value);

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            TextField(
              controller: _searchController,
              onSubmitted: _onSearchSubmitted,
              decoration: InputDecoration(
                hintText: "ابحث عن الرقم الوطني للطفل",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "    نتائج البحث",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_viewModel.child != null)
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: buildTable(
                  context,
                  "${_viewModel.child!.First_Name} ${_viewModel.child!.Last_Name}",
                  _viewModel.child!.id,
                  "/Hcpviewchildinfo",
                ),
              )
            else if (_viewModel.errorMessage.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Text(
                    _viewModel.errorMessage,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                )
              else
                const Padding(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Text(
                    "لا توجد نتائج للبحث.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
