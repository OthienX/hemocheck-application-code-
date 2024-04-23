import 'package:permission_handler/permission_handler.dart';
import 'database_helper.dart';

Future<void> requestStoragePermissionAndInitializeDatabase() async {
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    status = await Permission.storage.request();
  }
  if (status.isGranted) {
    // Storage permission is granted, initialize the database
    try {
      final dbHelper = DatabaseHelper();
      await dbHelper.initDatabase();
    } catch (e) {
      // Handle database initialization error
    }
  } else {
    // Handle permission denied scenario
  }
}
