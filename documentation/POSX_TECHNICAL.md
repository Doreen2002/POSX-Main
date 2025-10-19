
# POSX Technical Documentation

## 1. Introduction & Architecture
PosX is a cross-platform POS app built with Flutter/Dart, integrating with ERPNext via REST APIs for real-time and offline operations. The codebase is organized by feature, with clear separation of business logic, data models, services, and UI components.

**Architecture Diagram:**
```
Frontend (Flutter/Dart)
  |-- controllers/
  |-- services/
  |-- models/
  |-- widgets_components/
  |-- api_requests/
Backend (ERPNext/Python)
```

---

## 2. Module/File Reference

### controllers/item_screen_controller.dart
Manages cart, item addition, discount/VAT logic, order submission, pricing rule integration.
**Key Functions:**
- `addItemsToCart(Item item)` (line 41): Adds item, applies discounts, calculates VAT, updates totals.
- `submitOrder()` (line 120): Validates and sends order to backend.
- Integrates with `PricingRuleEvaluationService` (line 85).
**Code Example:**
```dart
void addItemsToCart(Item item) {
  itemTotal = item.rate * item.qty;
  // ...other logic...
}
```

### services/pricing_rule_evaluation_service.dart
Real-time pricing rule evaluation, O(1) rule lookup, item/invoice-level discount logic.
**Key Functions:**
- `evaluatePricingRulesForItem(Item item)`: Applies rules and discounts.
- `getApplicableRules(Item item)`: Returns matching rules for an item.
**Code Example:**
```dart
final updatedItem = PricingRuleEvaluationService.evaluatePricingRulesForItem(item);
```

### services/optimized_data_manager.dart
O(1) map-based lookups for items, batches, customers; replaces all List searches for performance.
**Key Functions:**
- `getItemByCode(String code)`, `getItemByBarcode(String barcode)`, `getItemsByGroup(String group)`
- `syncData(List<Item> items)`: Populates maps after sync.
**Code Example:**
```dart
final item = OptimizedDataManager.getItemByCode(code);
```

### services/simple_hardware_optimizer.dart
Hardware detection, MariaDB config generation, tiering, cross-platform support.
**Key Functions:**
- `detectHardware()`, `applyOptimizations()`
- `getHardwareTier()`: Returns tier classification.
**Code Example:**
```dart
final hardware = await SimpleHardwareOptimizer.detectHardware();
```

### services/mariadb_config_manager.dart
Config file discovery, backup, merge, rollback, validation.
**Key Functions:**
- `findConfigFile()`, `backupConfigFile()`, `applyConfigChanges()`

### widgets_components/number_pad.dart
Touch input for quantities in cart.

### widgets_components/price_check.dart
Item price lookup and display, barcode scanning.

### widgets_components/hardware_optimization_panel.dart
Hardware status and optimization UI.

### api_requests/items.dart
Fetches item data from backend.

### api_requests/sales.dart
Submits sales/invoice data to backend.

### api_requests/customer.dart
Fetches customer data from backend.

---

## 3. API Reference
All API requests are in `lib/api_requests/`, mapped to backend endpoints in `offline_pos_erpnext/API/`.
**How it works:**
- Requests sent as HTTP (POST/GET) with JSON payloads.
- Responses parsed and mapped to Dart models.
- Error handling via try/catch and centralized logging.
- Field mapping ensures correct transfer of VAT, discount, batch, barcode, and pricing rule data.

---

## 4. Data Models & Field Directory
Document all fields, types, relationships, and meanings for each model.

### models/item.dart
**Fields:**
- `itemCode`: Unique code for the item (ERPNext Item Code)
- `name`: Item name
- `rate`: Price per unit
- `qty`: Quantity in cart
- `itemTotal`: `rate * qty` (total price before discount/VAT)
- `discountAmount`: Discount applied to item
- `vatRate`: VAT percentage
- `vatAmount`: VAT calculated on discounted price
- `barcode`: Barcode for scanning
- `batchNo`: Batch number (for batch-tracked items)
- `expiryDate`: Batch expiry date
**Usage:** Used for all item logic, cart operations, and API mapping. VAT and discount fields drive calculation logic.

### models/customer_list_model.dart
**Fields:**
- `customerName`: Name of customer
- `loyaltyPoints`: Points earned by customer
- `group`: Customer group for pricing/discount rules
**Usage:** Used for customer selection, loyalty logic, and discount eligibility.

### models/batch_list_model.dart
**Fields:**
- `batchNo`: Batch number
- `expiryDate`: Expiry date of batch
- `qty`: Quantity available in batch
**Usage:** Used for batch selection, expiry validation, and stock management.

### models/pricing_rule_model.dart
**Fields:**
- `ruleId`: Unique ID for pricing rule
- `discountType`: Type of discount (percentage, fixed)
- `conditions`: Conditions for rule application (item, customer, qty, date)
**Usage:** Used for rule evaluation, discount application, and audit trail.

### Field Directory (Quick Reference)
| Field Name      | Meaning/Calculation                      |
|-----------------|------------------------------------------|
| itemCode        | Unique item identifier                   |
| name            | Item name                                |
| rate            | Price per unit                           |
| qty             | Quantity in cart                         |
| itemTotal       | rate * qty                               |
| discountAmount  | Discount applied to item                 |
| vatRate         | VAT percentage                           |
| vatAmount       | VAT on discounted price                  |
| barcode         | Barcode for scanning                     |
| batchNo         | Batch number                             |
| expiryDate      | Batch expiry date                        |
| customerName    | Name of customer                         |
| loyaltyPoints   | Points earned by customer                |
| group           | Customer group for pricing/discount      |
| ruleId          | Unique ID for pricing rule               |
| discountType    | Type of discount (percentage, fixed)     |
| conditions      | Rule conditions (item, customer, qty)    |

---

## 5. Business Logic & Calculation Rules
**VAT Inclusive:**
1. Item flagged as VAT inclusive (`custom_is_vat_inclusive == 1`).
2. Net price reverse-calculated from gross price.
3. Discount applied to net price.
4. VAT calculated on discounted net price.
**VAT Exclusive:**
1. Item flagged as VAT exclusive.
2. Discount applied to net price.
3. VAT added on top of discounted price.
**Discounts:**
- Always applied to VAT-exclusive price for correct tax handling.
- Can be item-level or invoice-level, with max limits and rule-based application.
**Pricing Rules:**
- Evaluated in real time using O(1) lookups.
- Rule tracking fields (`applied_pricing_rule_id`, `discount_source`) updated for audit and ERPNext sync.

---

## 6. Troubleshooting & FAQ
**Common errors:**
- Database connection failures: Check config, credentials, and hardware optimizer status.
- Sync failures: Validate API endpoints, network, and backend status.
- Barcode scan issues: Ensure barcode is registered and mapped in `OptimizedDataManager`.
**Error codes and messages:**
- All errors logged via `logErrorToFile` and displayed in UI error containers.
**Debugging tips:**
- Use centralized logging for all exceptions.
- Check API responses for missing or mismatched fields.
- Validate field mappings between frontend and backend.

---

## 7. Changelog
Document major updates, schema changes, API changes, and new features here.
- 2025-10-11: Developer manual restructured, added file-by-file breakdowns and logic explanations.
- 2025-09-30: O(1) lookup system implemented for all data access.
- 2025-09-15: Hardware optimizer and MariaDB config manager added.

---

## 8. References
- Backend: `POSX-ERPNEXT_TECHNICAL.md`, ERPNext schema, API folder
- Frontend: All referenced Dart files above
