import 'package:flutter/material.dart';
import 'add_medicine_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'history_screen.dart';
import 'medicine.dart';
import 'medicine_tile.dart';
import 'storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Medicine> medicineBox;

  @override
  void initState() {
    super.initState();
    medicineBox = StorageService.medicineBox;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Medicine Reminders"),
        actions: [
          IconButton(
            icon: Icon(Icons.history),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HistoryScreen()));
            },
          )
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: medicineBox.listenable(),
        builder: (context, Box<Medicine> box, _) {
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              final medicine = box.getAt(index)!;
              return MedicineTile(medicine: medicine, medicineBox: medicineBox,);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddMedicineScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
