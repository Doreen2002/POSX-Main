import 'dart:async';
import 'package:offline_pos/database_conn/mysql_conn.dart';
import 'package:offline_pos/widgets_components/log_error_to_file.dart';

/// Create PricingRules main table
Future<bool> createPricingRulesTable() async {
  bool isCreatedDB = false;
  try {
    final conn = await getDatabase();
    await conn.query("""
      CREATE TABLE IF NOT EXISTS PricingRules (
        pricing_rule_id VARCHAR(255) PRIMARY KEY,
        title VARCHAR(255) NOT NULL,
        company VARCHAR(255) NOT NULL,
        currency VARCHAR(10) NOT NULL,
        disable TINYINT DEFAULT 0,
        
        -- Application Logic
        apply_on ENUM('Item Code', 'Item Group', 'Brand') NOT NULL,
        selling TINYINT DEFAULT 1,
        rate_or_discount ENUM('Rate', 'Discount Percentage', 'Discount Amount') NOT NULL,
        
        -- Discount Values
        discount_percentage DECIMAL(8,3) DEFAULT 0,
        discount_amount DECIMAL(18,6) DEFAULT 0,
        rate DECIMAL(18,6) DEFAULT 0,
        
        -- Quantity/Amount Conditions
        min_qty DECIMAL(10,3) DEFAULT 0,
        max_qty DECIMAL(10,3) DEFAULT NULL,
        min_amt DECIMAL(18,6) DEFAULT 0,
        max_amt DECIMAL(18,6) DEFAULT NULL,
        
        -- Date Conditions
        valid_from DATE DEFAULT NULL,
        valid_upto DATE DEFAULT NULL,
        
        -- Priority & Rules
        priority INT DEFAULT 1,
        apply_multiple_pricing_rules TINYINT DEFAULT 0,
        is_cumulative TINYINT DEFAULT 0,
        
        -- Customer Filtering
        applicable_for ENUM('', 'Customer', 'Customer Group', 'Territory') DEFAULT '',
        customer VARCHAR(255) DEFAULT NULL,
        customer_group VARCHAR(255) DEFAULT NULL,
        territory VARCHAR(255) DEFAULT NULL,
        
        -- Product Discounts
        price_or_product_discount ENUM('Price', 'Product') DEFAULT 'Price',
        free_item VARCHAR(255) DEFAULT NULL,
        free_qty DECIMAL(10,3) DEFAULT 0,
        
        -- Advanced
        margin_type ENUM('', 'Percentage', 'Amount') DEFAULT '',
        margin_rate_or_amount DECIMAL(18,6) DEFAULT 0,
        mixed_conditions TINYINT DEFAULT 0,
        rule_description TEXT DEFAULT NULL,
        condition_code TEXT DEFAULT NULL,
        
        -- Reconciliation Fields
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        modified_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        erpnext_created DATETIME DEFAULT NULL,
        erpnext_modified DATETIME DEFAULT NULL,
        sync_timestamp DATETIME DEFAULT NULL,
        
        -- Indexes for Performance
        INDEX idx_apply_on (apply_on),
        INDEX idx_priority (priority),
        INDEX idx_dates (valid_from, valid_upto),
        INDEX idx_qty (min_qty, max_qty),
        INDEX idx_amount (min_amt, max_amt),
        INDEX idx_company (company),
        INDEX idx_modified (erpnext_modified),
        INDEX idx_customer (customer),
        INDEX idx_customer_group (customer_group),
        INDEX idx_territory (territory),
        INDEX idx_disable (disable),
        INDEX idx_selling (selling)
      )
    """);
    isCreatedDB = true;
    await conn.close();
  } catch (e) {
    logErrorToFile("Error creating PricingRules table: $e");
    isCreatedDB = false;
  }
  return isCreatedDB;
}

/// Create PricingRuleItems child table
Future<bool> createPricingRuleItemsTable() async {
  bool isCreatedDB = false;
  try {
    final conn = await getDatabase();
    await conn.query("""
      CREATE TABLE IF NOT EXISTS PricingRuleItems (
        id INT AUTO_INCREMENT PRIMARY KEY,
        pricing_rule_id VARCHAR(255) NOT NULL,
        item_code VARCHAR(255) NOT NULL,
        uom VARCHAR(50) DEFAULT NULL,
        
        -- Reconciliation Fields
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        modified_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        erpnext_created DATETIME DEFAULT NULL,
        erpnext_modified DATETIME DEFAULT NULL,
        sync_timestamp DATETIME DEFAULT NULL,
        
        -- Foreign Key Constraint
        FOREIGN KEY (pricing_rule_id) REFERENCES PricingRules(pricing_rule_id) ON DELETE CASCADE,
        
        -- Indexes
        INDEX idx_pricing_rule (pricing_rule_id),
        INDEX idx_item_code (item_code),
        UNIQUE KEY unique_rule_item (pricing_rule_id, item_code)
      )
    """);
    isCreatedDB = true;
    await conn.close();
  } catch (e) {
    logErrorToFile("Error creating PricingRuleItems table: $e");
    isCreatedDB = false;
  }
  return isCreatedDB;
}

/// Create PricingRuleItemGroups child table
Future<bool> createPricingRuleItemGroupsTable() async {
  bool isCreatedDB = false;
  try {
    final conn = await getDatabase();
    await conn.query("""
      CREATE TABLE IF NOT EXISTS PricingRuleItemGroups (
        id INT AUTO_INCREMENT PRIMARY KEY,
        pricing_rule_id VARCHAR(255) NOT NULL,
        item_group VARCHAR(255) NOT NULL,
        uom VARCHAR(50) DEFAULT NULL,
        
        -- Reconciliation Fields
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        modified_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        erpnext_created DATETIME DEFAULT NULL,
        erpnext_modified DATETIME DEFAULT NULL,
        sync_timestamp DATETIME DEFAULT NULL,
        
        -- Foreign Key Constraint
        FOREIGN KEY (pricing_rule_id) REFERENCES PricingRules(pricing_rule_id) ON DELETE CASCADE,
        
        -- Indexes
        INDEX idx_pricing_rule (pricing_rule_id),
        INDEX idx_item_group (item_group),
        UNIQUE KEY unique_rule_group (pricing_rule_id, item_group)
      )
    """);
    isCreatedDB = true;
    await conn.close();
  } catch (e) {
    logErrorToFile("Error creating PricingRuleItemGroups table: $e");
    isCreatedDB = false;
  }
  return isCreatedDB;
}

/// Create PricingRuleBrands child table
Future<bool> createPricingRuleBrandsTable() async {
  bool isCreatedDB = false;
  try {
    final conn = await getDatabase();
    await conn.query("""
      CREATE TABLE IF NOT EXISTS PricingRuleBrands (
        id INT AUTO_INCREMENT PRIMARY KEY,
        pricing_rule_id VARCHAR(255) NOT NULL,
        brand VARCHAR(255) NOT NULL,
        
        -- Reconciliation Fields
        created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
        modified_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        erpnext_created DATETIME DEFAULT NULL,
        erpnext_modified DATETIME DEFAULT NULL,
        sync_timestamp DATETIME DEFAULT NULL,
        
        -- Foreign Key Constraint
        FOREIGN KEY (pricing_rule_id) REFERENCES PricingRules(pricing_rule_id) ON DELETE CASCADE,
        
        -- Indexes
        INDEX idx_pricing_rule (pricing_rule_id),
        INDEX idx_brand (brand),
        UNIQUE KEY unique_rule_brand (pricing_rule_id, brand)
      )
    """);
    isCreatedDB = true;
    await conn.close();
  } catch (e) {
    logErrorToFile("Error creating PricingRuleBrands table: $e");
    isCreatedDB = false;
  }
  return isCreatedDB;
}

/// Create all pricing rule tables
Future<bool> createAllPricingRuleTables() async {
  try {
    bool mainTable = await createPricingRulesTable();
    bool itemsTable = await createPricingRuleItemsTable();
    bool groupsTable = await createPricingRuleItemGroupsTable();
    bool brandsTable = await createPricingRuleBrandsTable();
    
    bool allCreated = mainTable && itemsTable && groupsTable && brandsTable;
    
    if (allCreated) {
      logErrorToFile("All pricing rule tables created successfully");
    } else {
      logErrorToFile("Some pricing rule tables failed to create");
    }
    
    return allCreated;
  } catch (e) {
    logErrorToFile("Error creating pricing rule tables: $e");
    return false;
  }
}

/// Drop all pricing rule tables (for clean reinstall)
Future<bool> dropAllPricingRuleTables() async {
  try {
    final conn = await getDatabase();
    
    // Drop child tables first (due to foreign key constraints)
    await conn.query("DROP TABLE IF EXISTS PricingRuleBrands");
    await conn.query("DROP TABLE IF EXISTS PricingRuleItemGroups");
    await conn.query("DROP TABLE IF EXISTS PricingRuleItems");
    await conn.query("DROP TABLE IF EXISTS PricingRules");
    
    await conn.close();
    logErrorToFile("All pricing rule tables dropped successfully");
    return true;
  } catch (e) {
    logErrorToFile("Error dropping pricing rule tables: $e");
    return false;
  }
}