
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import 'medicine.dart';

class StorageService {
  static Box<Medicine>? _medicineBox;

  static Future<void> init() async {
    final appDocumentDirectory = await getApplicationDocumentsDirectory();
    Hive.init(appDocumentDirectory.path);
    _medicineBox = await Hive.openBox<Medicine>('medicines');
  }

  static Box<Medicine> get medicineBox {
    if (_medicineBox == null) {
      throw Exception("Box not initialized. Call StorageService.init() first.");
    }
    return _medicineBox!;
  }
}

