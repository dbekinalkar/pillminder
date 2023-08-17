import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'medicine.dart';


class MedicineTile extends StatelessWidget {
  final Medicine medicine;
  final Box<Medicine> medicineBox;

  MedicineTile({required this.medicine, required this.medicineBox});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(medicine.name),
      subtitle: Text(
          "Next Reminder: ${medicine.reminderTime.toLocal().toString()} every ${medicine.dayInterval} days"),
      trailing: IconButton(
        icon: Icon(Icons.check),
        onPressed: () {
          medicine.lastTaken = DateTime.now();
          medicineBox.put(medicineBox.keyAt(medicineBox.values.toList().indexOf(medicine)), medicine);
        },
      ),
    );
  }
}
