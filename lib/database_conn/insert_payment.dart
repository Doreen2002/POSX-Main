import 'dart:async';
import 'package:offline_pos/models/mode_of_payment.dart';
import 'package:offline_pos/database_conn/mysql_conn.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';

Future<dynamic> insertTableModeOfPayment({List<ModeOfPaymentModel>? d}) async {
  try {
    final conn = await getDatabase();
    dynamic res;

    for (var element in d!) {
      
      var insertItemQuery =  'INSERT INTO ModeOfPayment (name)';
      res = await conn.query('''$insertItemQuery VALUES('${element.modeOfPayment}') ON DUPLICATE KEY UPDATE
        name = VALUES(name)
      ;''');
   
    }
    await conn.close();
    
    return res;
  } catch (e) {
    logErrorToFile("Error inserting data into payment mode Table $e");
  }
}
