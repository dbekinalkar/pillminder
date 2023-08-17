import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'medicine.dart';
import 'notification_service.dart';
import 'storage_service.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TimeOfDay _selectedTime;
  int _dayInterval = 1;
  late Box<Medicine> medicineBox;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    medicineBox = StorageService.medicineBox;

    _selectedTime = TimeOfDay.fromDateTime(DateTime.now());
  }

  _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  _submitForm() {
    if (_formKey.currentState!.validate()) {
      DateTime now = DateTime.now();

      DateTime reminderDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      if (reminderDateTime.isBefore(now)) {
        reminderDateTime = reminderDateTime.add(const Duration(days: 1));
      }

      // Check if the reminderDateTime is in the past
      if (reminderDateTime.isBefore(now)) {
        // If it's in the past, show an error message
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Please select a future date and time for the reminder.')));
        return;
      }

      final medicine = Medicine(
          name: _nameController.text,
          reminderTime: reminderDateTime,
          dayInterval: _dayInterval);
      medicineBox.add(medicine);
      NotificationService().scheduleNotification(medicineBox.keys.last,
          "Medicine Reminder", medicine.name, reminderDateTime);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Medicine Reminder")),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Medicine Name"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the medicine name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text("Reminder Time: ${_selectedTime.format(context)}"),
                trailing: const Icon(Icons.access_time),
                onTap: _selectTime,
              ),
              DropdownButtonFormField(
                value: _dayInterval,
                onChanged: (int? newValue) {
                  setState(() {
                    _dayInterval = newValue!;
                  });
                },
                items: [1, 2, 3, 4, 5, 6, 7]
                    .map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text("$value days"),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: "Day Interval"),
              ),
              ElevatedButton(
                  onPressed: _submitForm, child: const Text("Add Reminder"))
            ],
          ),
        ),
      ),
    );
  }
}
