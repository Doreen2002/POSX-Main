import 'dart:async';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';

import '../models/customer_list_model.dart';
import 'package:offline_pos/database_conn/mysql_conn.dart';

Future<dynamic> insertTableCustomer({required List<TempCustomerData> d}) async {
  final conn = await getDatabase();
  try {
    const insertQuery = '''
      INSERT INTO Customer 
      (name, customer_name, email_id, mobile_no, gender, national_id, 
        address_line1, address_line2, city, country, 
        loyalty_points, loyalty_points_amount,conversion_rate , sync_status, posx_id,default_price_list) 
    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?, ?,?) 
      ON DUPLICATE KEY UPDATE
      customer_name       = IF(sync_status  != 'Edited', VALUES(customer_name), customer_name),
      email_id            = IF(sync_status  != 'Edited', VALUES(email_id), email_id),
      mobile_no           = IF(sync_status  != 'Edited', VALUES(mobile_no), mobile_no),
      gender              = IF(sync_status  != 'Edited', VALUES(gender), gender),
      national_id         = IF(sync_status  != 'Edited', VALUES(national_id), national_id),
      address_line1       = IF(sync_status  != 'Edited', VALUES(address_line1), address_line1),
      address_line2       = IF(sync_status  != 'Edited', VALUES(address_line2), address_line2),
      city                = IF(sync_status  != 'Edited', VALUES(city), city),
      country             = IF(sync_status  != 'Edited', VALUES(country), country),
      default_price_list             = IF(sync_status  != 'Edited', VALUES(default_price_list), default_price_list),
      loyalty_points      = IF(sync_status  != 'Edited', VALUES(loyalty_points), loyalty_points),
      loyalty_points_amount = IF(sync_status  != 'Edited', VALUES(loyalty_points_amount), loyalty_points_amount),
      conversion_rate     = IF(sync_status  != 'Edited', VALUES(conversion_rate), conversion_rate),
      sync_status         = IF(sync_status  != 'Edited', VALUES(sync_status), sync_status),
      modified            = IF(sync_status  != 'Edited', NOW(), modified);
    ''';

    for (var element in d) {
      await conn.query(insertQuery, [
        element.name,
        
        element.customerName,
        element.emailId,
        element.mobileNo,
        element.gender,
        element.nationalId,
        element.addressLine1,
        element.addressLine2,
        element.city,
        element.country,
        element.loyaltyPoints,
        element.loyaltyPointsAmount,
        element.conversionRate,
        element.syncStatus ?? "Synced",
        element.posxID ??  "",
        element.defaultPriceList ?? ""
      ]);
    }

    return true;
  } catch (e) {
    print("Error inserting data into Customer table: $e");

  
    return null;
  } finally {
    await conn.close();
  }
}



Future<dynamic> updateCustomerStatus(TempCustomerData customer, context) async {
  try {
    final conn = await getDatabase();
    dynamic res;

    const updateQuery = '''
      UPDATE Customer SET
        customer_name = ?,
        email_id = ?,
        mobile_no = ?,
        gender = ?,
        national_id = ?,
        address_line1 = ?,
        address_line2 = ?,
        city = ?,
        country = ?,
        sync_status = 'Edited',
        modified = NOW()

      WHERE name = ?
    ''';

    res = await conn.query(updateQuery, [
      customer.customerName,
      customer.emailId,
      customer.mobileNo,
      customer.gender,
      customer.nationalId,
      customer.addressLine1,
      customer.addressLine2,
      customer.city,
      customer.country,
      customer.name
   
    ]);

    await conn.close();
    return res;
  } catch (e) {
    logErrorToFile("Error updating data into Customer Table $e ${customer.name}");
    return null;
  }
}

Future<dynamic> updateCustomerSyncStatus(customer) async {
  try {
    final conn = await getDatabase();
    dynamic res;

    const updateQuery = '''
      UPDATE Customer SET
        sync_status = 'Synced',
        modified = NOW()

      WHERE name = ?
    ''';

    res = await conn.query(updateQuery, [
     
      customer
    ]);
    
    await conn.close();
    return res;
  } catch (e) {
    logErrorToFile("Error updating data into Customer Table $e ${customer}");
    return null;
  }
}

Future<dynamic> updateCustomerLoyaltyPoints(String customer, double amountToDeduct) async {
  try {
    final conn = await getDatabase();

   
    final result = await conn.query(
      'SELECT conversion_rate, loyalty_points_amount, loyalty_points FROM Customer WHERE name = ?',
      [customer]
    );

    if (result.isEmpty) {
     
      await conn.close();
      return null;
    }

    final conversionRate = result.first[0] ?? 0;
    final currentPointsAmount = result.first[1] ?? 0;
    final currentPoints = result.first[2] ?? 0;

    if (conversionRate == 0) {
      
      await conn.close();
      return null;
    }

    final pointsToDeduct = amountToDeduct / conversionRate;

    
    final newPointsAmount = currentPointsAmount - amountToDeduct;
    final newPoints = currentPoints - pointsToDeduct;

   
    final finalPointsAmount = newPointsAmount < 0 ? 0 : newPointsAmount.round();
    final finalPoints = newPoints < 0 ? 0 : newPoints.round();

    
    const updateQuery = '''
      UPDATE Customer SET
        loyalty_points = ?,
        loyalty_points_amount = ?,
        modified = NOW()
      WHERE name = ?
    ''';

    final res = await conn.query(updateQuery, [
      finalPoints,
      finalPointsAmount,
      customer
    ]);

    await conn.close();
    return res;
  } catch (e) {
    logErrorToFile("Error updating loyalty points: $e ($customer)");
    return null;
  }
}



Future<dynamic> updateCustomerID(String customer, String id) async {
  try {
    final conn = await getDatabase();
    dynamic res;

    const updateQuery = '''
      UPDATE Customer SET
        name = ?,
        sync_status = 'Synced',
        modified = NOW()
      WHERE name = ?
    ''';

    res = await conn.query(updateQuery, [id, customer]);

    
    await conn.close();
    return res;
  } catch (e) {
    logErrorToFile("Error updating data in Customer Table: $e | Customer: $customer");
    return null;
  }
}

Future<dynamic> updateSalesInvoiceCustomerID(String customer, String id) async {
  try {
    final conn = await getDatabase();
    dynamic res;

    const updateQuery = '''
      UPDATE SalesInvoice SET
        customer = ?
      WHERE customer = ?
    ''';

    res = await conn.query(updateQuery, [id, customer]);

   
    await conn.close();
    return res;
  } catch (e) {
    logErrorToFile("Error updating data in Sales Invoice Table: $e | Customer: $customer");
    return null;
  }
}