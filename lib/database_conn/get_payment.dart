import 'package:offline_pos/database_conn/mysql_conn.dart';
import 'package:offline_pos/models/pos_profile_model.dart';
import 'package:offline_pos/models/type_ahead_model.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';
List <PaymentModeTypeAheadModel> modeOfPaymentList = [];

List<TempPOSProfileModel> posProfileList = [];

Future <List<PaymentModeTypeAheadModel>> fetchFromModeofPayment() async {
  try {
    final conn = await getDatabase();
    final  queryResult = await conn.query("SELECT * FROM ModeOfPayment;");

    // Map results to TempItem objects
     modeOfPaymentList = queryResult
        .map((row) => PaymentModeTypeAheadModel.fromJson(row.fields))
        .toList().cast<PaymentModeTypeAheadModel>();

    await conn.close();
    
    return modeOfPaymentList;
  } catch (e) {
    logErrorToFile("Error fetching data from Item Table $e");
    return [];
  } 
}

Future <List<TempPOSProfileModel>> fetchFromPosProfile() async {
  try {
    final conn = await getDatabase();
    // Execute the query
    final queryResult = await conn.query("SELECT * FROM PosProfile;");
  

    // Map results to TempItem objects
    final posProfileList = queryResult
        .map((row) => TempPOSProfileModel.fromJson(row.fields))
        .toList().cast<TempPOSProfileModel>();
  
    await conn.close();
    return posProfileList;
  } catch (e) {
    logErrorToFile("Error fetching data from pos profile Table $e");
    return [];
  } 
}