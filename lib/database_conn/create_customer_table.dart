import 'dart:async';
import 'package:offline_pos/database_conn/mysql_conn.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';

Future<bool> createTableCustomer() async {
 bool isCreatedDB = false;
  try {
    final conn = await getDatabase();
    await conn.query("""
    CREATE TABLE IF NOT EXISTS Customer (
        name varchar(255) PRIMARY KEY,
        posx_id varchar(255),
        customer_name varchar(255),
        /* territory varchar(255), */
        /* customer_group varchar(255), */
        /* customer_type varchar(255), */
        email_id varchar(255),
        mobile_no varchar(255),
        address_line1 varchar(255),
        address_line2 varchar(255),
        city varchar(255),
        /* state varchar(255), */
        /* zip_code varchar(255), */
        country varchar(255),
        loyalty_points FLOAT,
        conversion_rate FLOAT,
        gender TEXT CHECK (gender IN ('male', 'female', '')),
        national_id varchar(255),
        loyalty_points_amount FLOAT,
        sync_status varchar(255),
        custom_qr_code_data varchar(255),
        modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        INDEX idx_customer_qr (custom_qr_code_data)
    );
""");

    isCreatedDB = true;
    await conn.close();
  } catch (e) {
    logErrorToFile("Error creating customer table $e");
    isCreatedDB = false;
  }

  return isCreatedDB;
}


