import 'package:offline_pos/database_conn/mysql_conn.dart';
import 'package:offline_pos/models/pos_profile_model.dart';
import 'package:offline_pos/models/type_ahead_model.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';
List <PaymentModeTypeAheadModel> modeOfPaymentList = [];

List<TempPOSProfileModel> posProfileList = [];

Future <List<PaymentModeTypeAheadModel>> fetchFromModeofPayment() async {
    final conn = await getDatabase();
  try {
  
    final  queryResult = await conn.query("SELECT * FROM ModeOfPayment;");

    // Map results to TempItem objects
     modeOfPaymentList = queryResult
        .map((row) => PaymentModeTypeAheadModel.fromJson(row.fields))
        .toList().cast<PaymentModeTypeAheadModel>();

   
    
    return modeOfPaymentList;
  } catch (e) {
    logErrorToFile("Error fetching data from Item Table $e");
    return [];
  } 
  finally{
     await conn.close();
  }
}

Future <List<TempPOSProfileModel>> fetchFromPosProfile() async {
      final conn = await getDatabase();
  try {

    // Execute the query
    final queryResult = await conn.query("SELECT * FROM PosProfile;");
  

    // Map results to TempItem objects
    final posProfileList = queryResult
        .map((row) => TempPOSProfileModel.fromJson(row.fields))
        .toList().cast<TempPOSProfileModel>();
  
 
    return posProfileList;
  } catch (e) {
    logErrorToFile("Error fetching data from pos profile Table $e");
    return [];
  } 
  finally
  {
       await conn.close();
  }
}