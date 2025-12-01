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
  final conn = await getDatabase();
  try {

    await conn.query("CREATE TABLE IF NOT EXISTS SalesPerson ( name varchar(255) PRIMARY KEY,full_name varchar(255))");
    isCreatedDB = true;
   
  } catch (e) {
   logErrorToFile("Error creating sales person table $e");
    isCreatedDB = false;
    
  }
  finally{
     await conn.close();
  }

  return isCreatedDB;
}


Future<bool> createCurrencyDenominationTable() async {
 bool isCreatedDB = false;
  final conn = await getDatabase();
  try {

    await conn.query("CREATE TABLE IF NOT EXISTS CurrencyDenomination ( currency_denomination_id varchar(255)  PRIMARY KEY, currency_name varchar(255), denomination_value FLOAT)");
    isCreatedDB = true;
   
  } catch (e) {
   logErrorToFile("Error creating Currency Denomination  table $e");
    isCreatedDB = false;
    
  }
  finally{
     await conn.close();
  }

  return isCreatedDB;
}


Future<dynamic> insertCurrencyDenominationTable( {List<CurrencyDenomination>? d}) async {
  final conn = await getDatabase();
  try {
    
    dynamic res;
    for (var element in d!) {
      var insertItemQuery = 'INSERT  INTO CurrencyDenomination (currency_denomination_id,currency_name, denomination_value) ';
      res = await conn.query('''$insertItemQuery VALUES('${element.currencyDenominationId}', '${element.currencyName}','${element.denominationValue}')
      ON DUPLICATE KEY UPDATE
        denomination_value = VALUES(denomination_value),
        currency_name = VALUES(currency_name);
      ''');
     
    }
    return res;
  } catch (e) {
   logErrorToFile("Error inserting data into CurrencyDenomination Table $e");
  }
  finally{
     await conn.close();
  }
}


Future<bool> deleteAllCurrencyDenomination(ids) async {
  bool isDeleted = false;
   final db = await getDatabase();
  try {
    if(ids.isNotEmpty)
    {
   
    final placeholders = List.filled(ids.length, '?').join(', ');

    
    await db.query(
        "DELETE FROM CurrencyDenomination WHERE currency_denomination_id NOT IN ($placeholders)",
        ids,
      );

    isDeleted = true;
    
    }
  } catch (e) {
    logErrorToFile("Error deleting CurrencyDenomination records: $e");
    isDeleted = false;
  }
  finally{
    await db.close();
  }

  return isDeleted;
}

Future<dynamic> insertSalesPersonTable( {List<SalesPerson>? d}) async {
     final conn = await getDatabase();
  try {
 
    dynamic res;
    for (var element in d!) {
      var insertItemQuery = 'INSERT  INTO SalesPerson (name,full_name) ';
      res = await conn.query('''$insertItemQuery VALUES('${element.name}','${element.fullName}')
      ON DUPLICATE KEY UPDATE
        full_name = VALUES(full_name);
      ''');
     
    }
    return res;
  } catch (e) {
   logErrorToFile("Error inserting data into SalesPerson Table $e");
  }
  finally{
     await conn.close();
  }
}

Future<dynamic> insertUserTable( {List<User>? d}) async {
    final conn = await getDatabase();
  try {
  
    dynamic res;
    for (var element in d!) {
      var insertItemQuery = '''INSERT INTO User (name,full_name, username, password) VALUES (?, ?, ?, ?)
      ON DUPLICATE KEY UPDATE
        full_name = VALUES(full_name),
        username = VALUES(username),
        password = VALUES(password);''';
      res = await conn.query(insertItemQuery, [element.name, element.fullName, element.username, element.password]);
 
    }
 
  } catch (e) {
   logErrorToFile("Error inserting data into user Table $e");
  }
  finally{
        await conn.close();
  }
}

Future<bool> createTableUser() async {
  final conn = await getDatabase();
 bool isCreatedDB = false;
  try {
 
    await conn.query("CREATE TABLE IF NOT EXISTS User (name varchar(255) PRIMARY KEY,full_name varchar(255),username varchar(255),password varchar(255))");
    isCreatedDB = true;
    
  } catch (e) {
   logErrorToFile("Error creating user table $e");
    isCreatedDB = false;
  }
  finally{
    await conn.close();
  }

  return isCreatedDB;
}



Future<List<SalesPerson>> fetchFromSalesPerson() async {
    final conn = await getDatabase();
  try {
    // query the query
  
    final queryResult = await conn.query("SELECT * FROM SalesPerson;"); 

    // Map results to TempItem objects
    final salesPersonList = queryResult
        .map((row) => SalesPerson.fromJson(row.fields))
        .toList().cast<SalesPerson>();
 
 
  
    return salesPersonList ;
  } catch (e) {
   logErrorToFile("Error fetching data from SalesPerson Table $e");
    return [];
  } 
  finally{
      await conn.close();
  }
}


Future<List<CurrencyDenomination>> fetchFromCurrencyDenomination() async {
   final conn = await getDatabase();
  try {
    // query the query
   
    final queryResult = await conn.query("SELECT * FROM CurrencyDenomination Order by denomination_value DESC ;"); 

    // Map results to TempItem objects
    final currencyDenominationList = queryResult
        .map((row) => CurrencyDenomination.fromJson(row.fields))
        .toList().cast<CurrencyDenomination>();
 
 
    
    return currencyDenominationList ;
  } catch (e) {
   logErrorToFile("Error fetching data from CurrencyDenomination Table $e");
    return [];
  } 
  finally{
    await conn.close();
  }
}

Future<List<User>> fetchFromUser() async {
      final conn = await getDatabase();
  try {
   

    final queryResult = await conn.query("SELECT * FROM User;"); 

  
    final salesPersonList = queryResult
        .map((row) => User.fromJson(row.fields))
        .toList().cast<User>();
 
 
 
    return salesPersonList ;
  } catch (e) {
   logErrorToFile("Error fetching data from User Table $e");
    return [];
  } 
  finally{
       await conn.close();
  }
}