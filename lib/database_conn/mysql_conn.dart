
import 'dart:async';
import 'package:offline_pos/data_source/local/pref_keys.dart';
import 'package:offline_pos/data_source/local/user_preference.dart';
import 'package:mysql1/mysql1.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';

Future<dynamic> getDatabase() async {
  await UserPreference.getInstance();
  try {
    var settings = ConnectionSettings(
      host: UserPreference.getString(PrefKeys.databaseHostUrl) ?? '', 
      port: int.tryParse(UserPreference.getString(PrefKeys.databasePort) ?? '') ?? 3306,
      user: UserPreference.getString(PrefKeys.databaseUser) ?? '',
      password: UserPreference.getString(PrefKeys.databasePassword) ?? '',
      db: UserPreference.getString(PrefKeys.databaseName) ?? '', 
    );
    var conn = await MySqlConnection.connect(settings);
    return conn;
  } catch (e) {
    logErrorToFile('Error: $e');
    rethrow; 
  }

  
}



Future<void> closeDatabase(conn) async {
  await conn.close();
}



Future<bool> isNewDatabase() async {
  try {
    final conn = await getDatabase();

  
    final results = await conn.query('''
      SELECT table_name 
      FROM information_schema.tables
      WHERE table_schema = DATABASE() AND table_type = 'BASE TABLE'
    ''');

    for (var row in results) {
      String tableName = row[0];
     
      var countResult = await conn.query('SELECT COUNT(*) FROM `$tableName`');
      int count = countResult.first[0];

      if (count > 0) {
     
        await conn.close();
        return false; 
      }
    }

    await conn.close();
    return true;
  } catch (e) {
    logErrorToFile('Error checking database: $e');
    return false; 
  }
}
