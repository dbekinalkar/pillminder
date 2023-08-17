import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'medicine.dart';
import 'storage_service.dart';

class HistoryScreen extends StatelessWidget {
  final Box<Medicine> medicineBox = StorageService.medicineBox;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Medicine History")),
      body: ValueListenableBuilder(
        valueListenable: medicineBox.listenable(),
        builder: (context, Box<Medicine> box, _) {
          if (box.values.isEmpty) {
            return Center(child: Text("No medicine history available."));
          }
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              final medicine = box.getAt(index)!;
              return ListTile(
                title: Text(medicine.name),
                subtitle: medicine.lastTaken != null
                    ? Text("Last taken on: ${medicine.lastTaken!.toLocal().toString()}")
                    : Text("Not taken yet"),
              );
            },
          );
        },
      ),
    );
  }
}
