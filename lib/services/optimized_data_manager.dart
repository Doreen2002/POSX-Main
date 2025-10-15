import 'dart:async';
import 'package:offline_pos/database_conn/dbsync.dart' as dbsync;
import 'package:offline_pos/models/item_model.dart';
import 'package:offline_pos/models/customer_list_model.dart' ;
import 'package:offline_pos/database_conn/get_item_queries.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';

/// Optimized Data Manager
/// Provides O(1) fast lookups using Maps instead of O(n) List searches
/// Replaces all itemListdata.firstWhere() patterns for maximum performance
class OptimizedDataManager {

  // =================================================================
  // ITEM MAPS (Core functionality - working and tested)
  // =================================================================
  
  /// Items by item code - PRIMARY lookup for POS operations
  static Map<String, TempItem> itemsByCode = {};
  
  /// Items by barcode - for barcode scanning operations  
  static Map<String, TempItem> itemsByBarcode = {};
  
  /// Items grouped by item group - for category browsing
  static Map<String, List<TempItem>> itemsByGroup = {};

  // =================================================================
  // CUSTOMER MAPS (Customer QR code support)
  // =================================================================
  
  /// Customers by QR code data - for QR scanning operations
  static Map<String, TempCustomerData> customersByQR = {};

  // =================================================================
  // CORE ITEM ACCESS METHODS (O(1) Performance)
  // =================================================================
  
  /// Get item by code - MAIN method for POS operations
  static TempItem? getItemByCode(String itemCode) => itemsByCode[itemCode];
  
  /// Get item by barcode - for scanning operations
  static TempItem? getItemByBarcode(String barcode) => itemsByBarcode[barcode];
  
  /// Get all items in a specific group - for category browsing
  static List<TempItem> getItemsByGroup(String itemGroup) => itemsByGroup[itemGroup] ?? [];
  
  /// Get item by name - for search operations
  static TempItem? getItemByName(String itemName) {
    for (TempItem item in itemsByCode.values) {
      if (item.itemName != null && item.itemName!.toLowerCase().contains(itemName.toLowerCase())) {
        return item;
      }
    }
    return null;
  }

  /// Get item by PLU - for weight scale barcode operations
  static TempItem? getItemByPLU(String plu) {
    for (TempItem item in itemsByCode.values) {
      if (item.plu != null && item.plu == plu) {
        return item;
      }
    }
    return null;
  }

  // =================================================================
  // CORE CUSTOMER ACCESS METHODS (O(1) Performance)
  // =================================================================
  
  /// Get customer by QR code data - for customer QR scanning
  static TempCustomerData? getCustomerByQR(String qrData) {
    return customersByQR[qrData];
  }
  
  /// Populate customer QR map for fast lookups
  static void populateCustomerQRMap(List<TempCustomerData> customers) {
    customersByQR.clear();
    
    for (var customer in customers) {
      if (customer.qrCodeData != null && customer.qrCodeData!.isNotEmpty) {
        customersByQR[customer.qrCodeData!] = customer;
      }
    }
    
    logErrorToFile("Populated ${customersByQR.length} customer QR codes for fast lookup");
  }

  // =================================================================
  // PLACEHOLDER METHODS (Future Implementation)
  // =================================================================
  
  /// Get customer by name - PLACEHOLDER (not yet implemented)
  static dynamic getCustomerByName(String customerName) {
   try{
    TempCustomerData? match;
    dbsync.customerDataList.map((e) {
      if(e.customerName!.toLowerCase() == customerName.toLowerCase()){
        match =  e;
      }
    }).toList();
    return match;
   }
   catch(e){
    logErrorToFile('OptimizedDataManager: getCustomerByName not yet implemented for: $customerName');
   }
  }
  
  /// Get batch by code - PLACEHOLDER (not yet implemented)
  static dynamic getBatchByCode(String batchCode) {
    // TODO: Implement batch lookup when batch data optimization is added
    logErrorToFile('OptimizedDataManager: getBatchByCode not yet implemented for: $batchCode');
    return null;
  }
  
  /// Get batches by item - PLACEHOLDER (not yet implemented)
  static List<dynamic> getBatchesByItem(String itemCode) {
    // TODO: Implement batch lookup when batch data optimization is added
    logErrorToFile('OptimizedDataManager: getBatchesByItem not yet implemented for: $itemCode');
    return [];
  }
  
  /// Get data counts - PLACEHOLDER (not yet implemented)
  static Map<String, int> getDataCounts() {
    // TODO: Implement comprehensive data counts when all data types are optimized
    logErrorToFile('OptimizedDataManager: getDataCounts not yet implemented');
    return {
      'items': itemsByCode.length,
      'customers': 0, // Placeholder
      'batches': 0,   // Placeholder
    };
  }

  // =================================================================
  // DATA LOADING AND MANAGEMENT
  // =================================================================
  
  /// Load all data maps from database - called by dbsync.dart
  static Future<void> loadAllDataMaps() async {
    try {
      logErrorToFile('OptimizedDataManager: Starting data loading...');
      
      await loadItemMaps();
      
      logErrorToFile('OptimizedDataManager: All data loaded successfully');
      logErrorToFile('OptimizedDataManager: Items: ${itemsByCode.length}');
      
    } catch (e) {
      logErrorToFile('OptimizedDataManager: Error loading data: $e');
    }
  }
  
  /// Load item data into Maps for O(1) access
  static Future<void> loadItemMaps() async {
    try {
      logErrorToFile('OptimizedDataManager: Loading items...');
      
      // Clear existing maps
      itemsByCode.clear();
      itemsByBarcode.clear();
      itemsByGroup.clear();
      
      // Load items using existing itemListdata from get_item_queries.dart
      for (TempItem item in itemListdata) {
        // Primary lookup by item code
        itemsByCode[item.itemCode] = item;
        
        // Barcode lookup
        if (item.barcode != null && item.barcode!.isNotEmpty) {
          itemsByBarcode[item.barcode!] = item;
        }
        
        // Group-based lookup for category browsing
        if (item.itemGroup != null && item.itemGroup!.isNotEmpty) {
          if (!itemsByGroup.containsKey(item.itemGroup!)) {
            itemsByGroup[item.itemGroup!] = [];
          }
          itemsByGroup[item.itemGroup!]!.add(item);
        }
      }
      
      logErrorToFile('OptimizedDataManager: Items loaded - ${itemsByCode.length} total');
      
    } catch (e) {
      logErrorToFile('OptimizedDataManager: Error loading items: $e');
    }
  }
  
  /// Clear all data maps - for cleanup or refresh
  static void clearAllMaps() {
    itemsByCode.clear();
    itemsByBarcode.clear();
    itemsByGroup.clear();
    logErrorToFile('OptimizedDataManager: All maps cleared');
  }
  
  /// Get memory usage statistics
  static Map<String, int> getMemoryStats() {
    return {
      'itemsByCode': itemsByCode.length,
      'itemsByBarcode': itemsByBarcode.length,
      'itemGroups': itemsByGroup.length,
    };
  }
}