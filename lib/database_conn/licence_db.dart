import 'dart:async';

import 'package:offline_pos/database_conn/mysql_conn.dart';

import 'package:offline_pos/widgets_components/log_error_to_file.dart';



Future<bool> createLicenseTable() async {
 bool isCreatedDB = false;
 final conn = await getDatabase();
  try {
    
    await conn.query("CREATE TABLE IF NOT EXISTS LicenseDetails (id varchar(255) PRIMARY KEY, license_key varchar(255),license_type varchar(255), primary_url varchar(255),secondary_url varchar(255), activated_on varchar(255),expiry_date varchar(255), status varchar(255));");
    isCreatedDB = true;
   
  } catch (e) {
    logErrorToFile("Error creating license table $e");
   
    isCreatedDB = false;
  }
  finally{
     await conn.close();
  }

  return isCreatedDB;
}

Future <bool> insertLicenseDetails({required String id, required String licenseKey, required String licenseType,  String? primaryUrl, String? secondaryUrl, required String activatedOn, required String expiryDate, required String status}) async {
   final conn = await getDatabase();
  try {
  
    await conn.query(
      """INSERT INTO LicenseDetails 
      (id, license_key, license_type, primary_url, secondary_url, activated_on, expiry_date, status) 
      VALUES (?, ?, ?, ?, ?, ?, ?, ?)
      ON DUPLICATE KEY UPDATE
        license_key = VALUES(license_key),
        license_type = VALUES(license_type),
        primary_url = VALUES(primary_url),
        secondary_url = VALUES(secondary_url),
        activated_on = VALUES(activated_on),
        expiry_date = VALUES(expiry_date),
        status = VALUES(status)""",
      [id, licenseKey, licenseType, primaryUrl, secondaryUrl, activatedOn, expiryDate, status]
    );

   
    return true;
  } catch (e) {
    logErrorToFile("Error inserting into LicenseDetails: $e");
    return false;
  }
  finally{
     await conn.close();
  }
}