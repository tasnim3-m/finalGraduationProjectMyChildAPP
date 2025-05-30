import 'package:flutter/material.dart';
import 'package:my_child/views/widgets/app_table.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget buildTable(
    BuildContext context, String name, String nationalId, String screen) {
  return GestureDetector(
    onTap: () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'selected_child_id', nationalId); // هذا هو رقم الطفل

      Navigator.pushNamed(context, screen); // الانتقال للشاشة الرئيسية
    },
    child: Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Table(
        columnWidths: {0: FlexColumnWidth(5), 1: FlexColumnWidth(8)},
        border: TableBorder.all(borderRadius: BorderRadius.circular(10)),
        children: [
          TableRow(children: [
            TableHeaderV(
              text: " الاسم: ",
              borderRadius: BorderRadius.only(topRight: Radius.circular(10)),
            ),
            TableDetailsV(text: name),
          ]),
          TableRow(children: [
            TableHeaderV(
              text: "الرقم الوطني:",
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(10)),
            ),
            TableDetailsV(text: nationalId),
          ]),
        ],
      ),
    ),
  );
}
