import 'dart:async';

import 'package:offline_pos/database_conn/mysql_conn.dart';
import 'package:offline_pos/models/sales_person.dart';
import 'package:offline_pos/models/currency_denominations_model.dart';
import 'package:offline_pos/models/user.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';
List<SalesPerson> salesPersonList  = [];

List<CurrencyDenomination> currencyDenominationList = [];


Future<bool> createSalesPersonTable() async {
 bool isCreatedDB = false;
  try {
 final conn = await getDatabase();
    await conn.query("CREATE TABLE IF NOT EXISTS SalesPerson ( name varchar(255) PRIMARY KEY,full_name varchar(255))");
    isCreatedDB = true;
    await conn.close();
  } catch (e) {
   logErrorToFile("Error creating sales person table $e");
    isCreatedDB = false;
    
  }

  return isCreatedDB;
}


Future<bool> createCurrencyDenominationTable() async {
 bool isCreatedDB = false;
  try {
 final conn = await getDatabase();
    await conn.query("CREATE TABLE IF NOT EXISTS CurrencyDenomination ( currency_denomination_id varchar(255)  PRIMARY KEY, currency_name varchar(255), denomination_value FLOAT)");
    isCreatedDB = true;
    await conn.close();
  } catch (e) {
   logErrorToFile("Error creating Currency Denomination  table $e");
    isCreatedDB = false;
    
  }

  return isCreatedDB;
}


Future<dynamic> insertCurrencyDenominationTable( {List<CurrencyDenomination>? d}) async {
  try {
    final conn = await getDatabase();
    dynamic res;
    for (var element in d!) {
      var insertItemQuery = 'INSERT  INTO CurrencyDenomination (currency_denomination_id,currency_name, denomination_value) ';
      res = await conn.query('''$insertItemQuery VALUES('${element.currencyDenominationId}', '${element.currencyName}','${element.denominationValue}')
      ON DUPLICATE KEY UPDATE
        denomination_value = VALUES(denomination_value),
        currency_name = VALUES(currency_name);
      ''');
      await conn.close();
    }
    return res;
  } catch (e) {
   logErrorToFile("Error inserting data into CurrencyDenomination Table $e");
  }
}


Future<bool> deleteAllCurrencyDenomination(ids) async {
  bool isDeleted = false;
  try {
    if(ids.isNotEmpty)
    {
    final db = await getDatabase();
    final placeholders = List.filled(ids.length, '?').join(', ');

    
    await db.query(
        "DELETE FROM CurrencyDenomination WHERE currency_denomination_id NOT IN ($placeholders)",
        ids,
      );

    isDeleted = true;
    await db.close();
    }
  } catch (e) {
    logErrorToFile("Error deleting CurrencyDenomination records: $e");
    isDeleted = false;
  }

  return isDeleted;
}

Future<dynamic> insertSalesPersonTable( {List<SalesPerson>? d}) async {
  try {
    final conn = await getDatabase();
    dynamic res;
    for (var element in d!) {
      var insertItemQuery = 'INSERT  INTO SalesPerson (name,full_name) ';
      res = await conn.query('''$insertItemQuery VALUES('${element.name}','${element.fullName}')
      ON DUPLICATE KEY UPDATE
        full_name = VALUES(full_name);
      ''');
      await conn.close();
    }
    return res;
  } catch (e) {
   logErrorToFile("Error inserting data into SalesPerson Table $e");
  }
}

Future<dynamic> insertUserTable( {List<User>? d}) async {
  try {
    final conn = await getDatabase();
    dynamic res;
    for (var element in d!) {
      var insertItemQuery = '''INSERT INTO User (name,full_name, username, password) VALUES (?, ?, ?, ?)
      ON DUPLICATE KEY UPDATE
        full_name = VALUES(full_name),
        username = VALUES(username),
        password = VALUES(password);''';
      res = await conn.query(insertItemQuery, [element.name, element.fullName, element.username, element.password]);
     await conn.close();
    }
 
  } catch (e) {
   logErrorToFile("Error inserting data into user Table $e");
  }
}

Future<bool> createTableUser() async {
  final conn = await getDatabase();
 bool isCreatedDB = false;
  try {
 
    await conn.query("CREATE TABLE IF NOT EXISTS User (name varchar(255) PRIMARY KEY,full_name varchar(255),username varchar(255),password varchar(255))");
    isCreatedDB = true;
    await conn.close();
  } catch (e) {
   logErrorToFile("Error creating user table $e");
    isCreatedDB = false;
  }

  return isCreatedDB;
}



Future<List<SalesPerson>> fetchFromSalesPerson() async {
  try {
    // query the query
    final conn = await getDatabase();
    final queryResult = await conn.query("SELECT * FROM SalesPerson;"); 

    // Map results to TempItem objects
    final salesPersonList = queryResult
        .map((row) => SalesPerson.fromJson(row.fields))
        .toList().cast<SalesPerson>();
 
 
    await conn.close();
    return salesPersonList ;
  } catch (e) {
   logErrorToFile("Error fetching data from SalesPerson Table $e");
    return [];
  } 
}


Future<List<CurrencyDenomination>> fetchFromCurrencyDenomination() async {
  try {
    // query the query
    final conn = await getDatabase();
    final queryResult = await conn.query("SELECT * FROM CurrencyDenomination Order by denomination_value DESC ;"); 

    // Map results to TempItem objects
    final currencyDenominationList = queryResult
        .map((row) => CurrencyDenomination.fromJson(row.fields))
        .toList().cast<CurrencyDenomination>();
 
 
    await conn.close();
    return currencyDenominationList ;
  } catch (e) {
   logErrorToFile("Error fetching data from CurrencyDenomination Table $e");
    return [];
  } 
}

Future<List<User>> fetchFromUser() async {
  try {
   
    final conn = await getDatabase();
    final queryResult = await conn.query("SELECT * FROM User;"); 

  
    final salesPersonList = queryResult
        .map((row) => User.fromJson(row.fields))
        .toList().cast<User>();
 
 
    await conn.close();
    return salesPersonList ;
  } catch (e) {
   logErrorToFile("Error fetching data from User Table $e");
    return [];
  } 
}