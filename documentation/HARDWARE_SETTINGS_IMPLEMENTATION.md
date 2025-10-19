# Hardware Settings Page - Complete Implementation Guide

**Date:** October 13, 2025  
**Status:** Design Complete - Ready for Implementation

---

## Overview

This document outlines the complete implementation of the Hardware Settings Page for PosX, including all hardware configuration sections and cash drawer fixes.

---

## 1. Page Structure

```
Hardware & Device Settings Page
├── AppBar (Green, "Hardware Settings")
├── ScrollView Body
│   ├── Section 1: System Optimization (Collapsible) ✅ DONE
│   ├── Section 2: Receipt Printer (NEW)
│   ├── Section 3: VFD Customer Display (NEW)
│   └── Section 4: Cash Drawer (NEW)
└── Sidebar Menu Icon (Bottom) (NEW)
```

---

## 2. Section 1: System Optimization (Database)

**Status:** ✅ Already Implemented (Oct 12, 2025)

**Features:**
- Hardware detection (CPU, RAM, SSD)
- Tier classification (Budget/Standard/Enterprise)
- MariaDB buffer pool optimization
- Manual re-optimize button

**UI State:** Collapsible ExpansionTile (default: collapsed)

**Files:**
- `lib/pages/hardware_settings_page.dart` - Main page
- `lib/widgets_components/hardware_optimization_panel.dart` - Panel widget
- `lib/services/simple_hardware_optimizer.dart` - Detection logic
- `lib/services/mariadb_config_manager.dart` - Config management

---

## 3. Section 2: Receipt Printer

### Features:
1. **Current Printer Display** - Shows saved printer
2. **Scan for Printers Button** - Detects Windows printers
3. **Printer Selection Dropdown** - With printer type icons
4. **Silent Print Toggle** - Skip OS dialog
5. **Auto-print Toggle** - Print after payment
6. **Test Print Button** - Receipt with barcode + QR code
7. **Status Indicator** - Connected/Not Found

### Storage (PrefKeys):
```dart
static const String receiptPrinterUrl = "receiptPrinterUrl";
static const String silentPrintEnabled = "silentPrintEnabled";
static const String autoPrintReceipt = "autoPrintReceipt";
static const String receiptPhoneNumber = "receiptPhoneNumber";  // NEW
static const String receiptFooterText = "receiptFooterText";    // NEW
```

### Receipt Customization Features:
1. **Phone Number Field** - Displayed in receipt header after company name
2. **Footer Text Field** - Custom message at receipt bottom (max 200 chars)
3. **Legal Compliance** - "TAX INVOICE" header (all caps, prominent)

### UI Layout:
```
┌─────────────────────────────────────────────────────────┐
│  🖨️ Receipt Printer                                     │
│                                                          │
│  Current Printer:                                       │
│  📋 EPSON TM-T20III Receipt ✅                          │
│                                                          │
│  [🔍 Scan for Printers]                                 │
│                                                          │
│  Select Printer:                                        │
│  [Dropdown ▼]                                           │
│    🧾 EPSON TM-T20III Receipt                          │
│    🧾 Star TSP143III                                   │
│    🖨️ HP LaserJet Pro                                  │
│    📄 Microsoft Print to PDF                            │
│                                                          │
│  Print Settings:                                        │
│  [ ] Silent Print (Skip print dialog)                  │
│      ℹ️ Enable to prevent payment blocking             │
│  [✓] Auto-print after payment                          │
│                                                          │
│  Receipt Customization:                                 │
│  Phone Number:                                          │
│  [📞 +966 12 345 6789_____________]                     │
│                                                          │
│  Receipt Footer (max 200 characters):                   │
│  ┌──────────────────────────────────────────┐          │
│  │ Please keep the receipt for any          │          │
│  │ exchange within 24Hrs. Exchange baby     │          │
│  │ milk, fridge items and temperature       │          │
│  │ sensitive items not allowed              │          │
│  └──────────────────────────────────────────┘          │
│  ℹ️ Appears at bottom of every receipt                │
│                                                          │
│  [🧪 Print Test Receipt] [💾 Save Settings]            │
└─────────────────────────────────────────────────────────┘
```

### Receipt Format Structure:
```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
            ABC Company Ltd
         Tel: +966 12 345 6789    ← NEW: From settings
         
         CR.NO: 1234567890123
         VAT: 300000000000003
         123 Main Street, Riyadh

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
              TAX INVOICE           ← Fixed: All caps
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Date: 13-10-2025        Time: 03:45 PM
Customer: CUST-001      Name: John Doe
Served By: Sales User   Reference: INV-001

───────────────────────────────────────────────
Item Name
Code | Unit | Qty | Price | Disc | Rate | VAT | Value
───────────────────────────────────────────────
[Items list...]
───────────────────────────────────────────────

T-Qty: 5               Gross Amount:     500.00
                       Discount:          50.00
                       Amount Excl VAT:  450.00
                       VAT Amount:        67.50
                       ────────────────────────
                       SubTotal Inc VAT: 517.50

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
          Payment Breakup
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Cash                              500.00
Credit Card                        20.00
───────────────────────────────────────────────
Total Paid                        520.00    ← NEW
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Change                |          2.50
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

         Tel: +966 12 345 6789    ← NEW: Repeated
         
    Please keep the receipt for   ← NEW: From settings
     any exchange within 24Hrs.
    Exchange baby milk, fridge
    items and temperature 
    sensitive items not allowed

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Receipt Changes Summary:
✅ **Header Section:**
- Phone number displayed prominently after company name
- Legal "TAX INVOICE" (all caps, size 8, black background, white text)

✅ **Removed Elements:**
- ❌ Customer signature line (not required)
- ❌ Hardcoded footer (VAT repeated, company info repeated)
- ❌ "PLEASE REFER TO THE EXCHANGE POLICY" (now customizable)
- ❌ "PRICE INCLUDING VAT" (now customizable)
- ❌ "!!!THANK YOU!!!" (now customizable)

✅ **New Elements:**
- Phone number in header (from `PrefKeys.receiptPhoneNumber`)
- Total Paid amount (sum of all payment methods)
- Phone number in footer (repeated for visibility)
- Custom footer text (from `PrefKeys.receiptFooterText`, max 200 chars)

### Text Field Specifications:
- **Phone Number:** Single-line input, keyboard type: phone
- **Footer Text:** Multi-line (2-3 lines), max 200 characters, counter hidden
- **Default Footer:** "Thank you for your business!" (if not customized)
- **Example Footer (131 chars):** 
  ```
  Please keep the receipt for any exchange within 24Hrs. 
  Exchange baby milk, fridge items and temperature sensitive 
  items not allowed
  ```

### Print Settings:                                        │
│  [ ] Silent Print (Skip print dialog)                  │
│      ℹ️ Enable to prevent payment blocking             │
│  [✓] Auto-print after payment                          │
│                                                          │
│  [🧪 Print Test Receipt] [💾 Save Settings]            │
└─────────────────────────────────────────────────────────┘
```

### Test Receipt Content:
- Company header (name, address, VAT, CR)
- "*** TEST RECEIPT ***"
- Date/Time
- Printer name and status
- Test barcode (EAN-13: 1234567890128)
- Test QR code (unique timestamp)
- Test ID footer

### Implementation Files:
- `lib/pages/hardware_settings_page.dart` - Add section with phone & footer fields
- `lib/data_source/local/pref_keys.dart` - Add keys (receiptPhoneNumber, receiptFooterText)
- `lib/widgets_components/generate_print.dart` - Update receipt format with dynamic phone/footer

### Receipt Print Code Changes:
**File:** `lib/widgets_components/generate_print.dart`

**Line ~42-48 (Header Section):**
```dart
pw.Text(UserPreference.getString(PrefKeys.companyName) ?? "",
    style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 12)),

// Phone Number from Settings
if (UserPreference.getString(PrefKeys.receiptPhoneNumber)?.isNotEmpty ?? false)
  pw.Text(
    'Tel: ${UserPreference.getString(PrefKeys.receiptPhoneNumber)}',
    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8),
  ),
```

**Line ~57 (TAX INVOICE Header):**
```dart
pw.Text('TAX INVOICE',
    style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 8,color: PdfColors.white)),
```

**Line ~205 (Removed Customer Signature):**
```dart
// OLD CODE REMOVED:
// pw.Container(
//   child: pw.Text('Customer Signature :',
//       style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 8)),
// ),
```

**Line ~345 (Added Total Paid):**
```dart
pw.Divider(color: PdfColors.grey400,),
// Total Paid Row
pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Container(
        child: pw.Text('Total Paid',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 7)),
      ),
      pw.Container(
        child: pw.Text(
          model.paidAmount.toStringAsFixed(model.decimalPoints),
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 7),
        ),
      ),
    ]
),
pw.Divider(color: PdfColors.black,),
```

**Line ~385-400 (Footer Section - Replaced Hardcoded Text):**
```dart
pw.Align(
  alignment: pw.Alignment.topCenter,
  child: pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.center,
    children: [
      // Phone Number from Settings
      if (UserPreference.getString(PrefKeys.receiptPhoneNumber)?.isNotEmpty ?? false)
        pw.Text(
          'Tel: ${UserPreference.getString(PrefKeys.receiptPhoneNumber)}',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 7),
        ),
      if (UserPreference.getString(PrefKeys.receiptPhoneNumber)?.isNotEmpty ?? false)
        pw.SizedBox(height: 5),
      
      // Custom Footer Text from Settings
      pw.Text(
        UserPreference.getString(PrefKeys.receiptFooterText) ?? 
            'Thank you for your business!',
        style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 6),
        textAlign: pw.TextAlign.center,
      ),
    ],
  ),
),
```

---

## 4. Section 3: VFD Customer Display

### Features:
1. **Enable/Disable Toggle** - Master switch
2. **COM Port Dropdown + Scan Button** - Detect available ports
3. **Baud Rate Dropdown** - 9600, 19200, 38400, 57600, 115200
4. **Data Bits Dropdown** - 7, 8
5. **Stop Bits Dropdown** - 1, 2
6. **Parity Dropdown** - None, Even, Odd
7. **Welcome Message Preview** - Shows how it displays (2x20)
8. **Test Display Button** - Send test message
9. **Status Indicator** - Connected/Not Connected

### Storage (PrefKeys):
```dart
static const String vfdEnabled = "vfdEnabled";
static const String vfdComPort = "vfdComPort";
static const String vfdBaudRate = "vfdBaudRate";
static const String vfdDataBits = "vfdDataBits";
static const String vfdStopBits = "vfdStopBits";
static const String vfdParity = "vfdParity";
```

### Content Source:
- Welcome text: `PrefKeys.companyName` (from ERPNext)
- Currency: `PrefKeys.currency` (from ERPNext)
- POS Profile: `PrefKeys.posProfileName` (from ERPNext)

### UI Layout:
```
┌─────────────────────────────────────────────────────────┐
│  📺 Customer Display (VFD)                               │
│                                                          │
│  [✓] Enable VFD Display                                 │
│                                                          │
│  Serial Port Configuration:                             │
│  COM Port:  [Dropdown: COM3 ▼] [🔄 Scan Ports]         │
│  Baud Rate: [Dropdown: 9600 ▼]                         │
│  Data Bits: [Dropdown: 8 ▼]                            │
│  Stop Bits: [Dropdown: 1 ▼]                            │
│  Parity:    [Dropdown: None ▼]                         │
│                                                          │
│  Display Preview (From ERPNext):                        │
│  ┌────────────────────┬────────────────────┐            │
│  │ ABC Company Ltd    │                    │ ← Line 1   │
│  │ Main Store POS     │                    │ ← Line 2   │
│  └────────────────────┴────────────────────┘            │
│  ℹ️ Company name loaded from ERPNext                   │
│                                                          │
│  Status: ✅ Connected (COM3, 9600 baud)                │
│                                                          │
│  [🧪 Test Display] [💾 Save Settings]                  │
└─────────────────────────────────────────────────────────┘
```

### VFD Display Format:
- **2 lines × 20 characters = 40 chars total**
- Line 1: Company name (padded/truncated to 20 chars)
- Line 2: POS Profile name (padded/truncated to 20 chars)

### Implementation Files:
- `lib/pages/hardware_settings_page.dart` - Add section
- `lib/data_source/local/pref_keys.dart` - Add keys
- `lib/widgets_components/vdf_logic.dart` - Update to use stored settings

---

## 5. Section 4: Cash Drawer

### Features:
1. **ERPNext Status Display** - Show enabled/disabled from POS Profile (read-only)
2. **Connection Type Radio Buttons**:
   - Via Receipt Printer (RJ11) - Recommended
   - Direct USB to PC
3. **Test Open Button** - Trigger drawer open
4. **Status Indicator** - Ready/Not Configured

### Storage (PrefKeys):
```dart
static const String openCashDrawer = "openCashDrawer";  // From ERPNext
static const String cashDrawerConnectionType = "cashDrawerConnectionType";  // Local
```

### UI Layout:
```
┌─────────────────────────────────────────────────────────┐
│  💰 Cash Drawer                                          │
│                                                          │
│  ERPNext POS Profile Setting:                           │
│  ✅ Manual open button enabled                          │
│  (Configure in ERPNext to show/hide manual button)      │
│                                                          │
│  Connection Type:                                       │
│  ● Via Receipt Printer (RJ11) ✅ Recommended           │
│  ○ Direct USB to PC                                     │
│                                                          │
│  ℹ️ Drawer always opens on every payment completion    │
│                                                          │
│  Status: ✅ Ready (via EPSON TM-T20III)                │
│                                                          │
│  [🧪 Test Open Drawer] [💾 Save Settings]              │
└─────────────────────────────────────────────────────────┘
```

### Implementation Files:
- `lib/pages/hardware_settings_page.dart` - Add section
- `lib/data_source/local/pref_keys.dart` - Add keys
- `lib/widgets_components/cash_drawer_logic.dart` - Smart connection function
- `lib/api_requests/pos.dart` - Sync ERPNext setting
- `lib/controllers/item_screen_controller.dart` - Load setting
- `lib/pages/items_cart.dart` - Fix button text and logic
- `lib/widgets_components/checkout_right_screen.dart` - Update function calls

---

## 6. Cash Drawer Fixes (Critical)

### Issue 1: Setting Not Synced from ERPNext
**Problem:** `custom_open_cash_drawer` from ERPNext POS Profile is not saved to PosX

**Fix Location:** `lib/api_requests/pos.dart` (around line 60)

```dart
// Add after other UserPreference.putString calls:
if (item['settings'] != null) {
    await UserPreference.putBool(
        PrefKeys.openCashDrawer, 
        item['settings']['open_cash_drawer'] == 1
    );
}
```

### Issue 2: Button Text Always Shows "Enabled"
**Problem:** Button shows "Enabled" regardless of setting

**Fix Location:** `lib/pages/items_cart.dart` (line 310-312)

```dart
// OLD:
model.cashDrawerEnabled
    ? 'Cash Drawer\nEnabled'
    : 'Cash Drawer\nEnabled',  // ❌ Wrong!

// NEW:
model.cashDrawerEnabled
    ? 'Cash Drawer\nEnabled'
    : 'Cash Drawer\nDisabled',  // ✅ Fixed!
```

### Issue 3: Button Always Works (No Conditional)
**Problem:** Button calls function even when disabled

**Fix Location:** `lib/pages/items_cart.dart` (line 363)

```dart
// OLD:
case 'Cash Drawer\nEnabled':
    openDrawerViaUsbSerial();
    break;

// NEW:
case 'Cash Drawer\nEnabled':
    if (model.cashDrawerEnabled) {
        openCashDrawer();  // New unified function
    } else {
        showToast('Cash drawer is disabled. Enable in ERPNext POS Profile.');
    }
    break;

case 'Cash Drawer\nDisabled':
    showToast('Cash drawer is disabled. Contact system admin.');
    break;
```

### Issue 4: Wrong Connection Method
**Problem:** Uses USB-Serial instead of printer ESC/POS

**Fix Location:** `lib/widgets_components/cash_drawer_logic.dart`

**Solution:** Create unified `openCashDrawer()` that auto-switches:
- If `cashDrawerConnectionType == "printer"` → Use ESC/POS (1B 70 00 19 FA)
- If `cashDrawerConnectionType == "direct"` → Use USB-Serial (DTR/RTS)

**Update All Calls:**
- `lib/widgets_components/checkout_right_screen.dart` (lines 549, 603)
- `lib/pages/items_cart.dart` (line 363)

---

## 7. Sidebar Menu Icon

### Location:
Bottom of sidebar, above Logout button

### Icon:
`assets/ico/settings.png` (need to create or use existing)

### Navigation:
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => HardwareSettingsPage(),
  ),
);
```

### Implementation File:
- `lib/widgets_components/side_bar.dart` - Add menu item

---

## 8. Implementation Checklist

### Phase 1: PrefKeys Setup ✅
- [x] Add all new PrefKeys constants to `pref_keys.dart`
- [x] Add receiptPhoneNumber and receiptFooterText keys

### Phase 2: Cash Drawer Fixes ✅
- [x] Fix ERPNext setting sync in `pos.dart`
- [x] Fix button text logic in `items_cart.dart`
- [x] Add conditional logic in `items_cart.dart`
- [x] Implement smart `openCashDrawer()` in `cash_drawer_logic.dart`
- [x] Update all function calls

### Phase 3: Settings Page UI ✅
- [x] Make database section collapsible
- [x] Add Receipt Printer section
- [x] Add VFD Display section
- [x] Add Cash Drawer section
- [x] Add sidebar menu icon
- [x] Add phone number text field
- [x] Add footer text field (max 200 chars)

### Phase 4: Receipt Print Format ✅
- [x] Update header with phone number
- [x] Change "Tax Invoice" to "TAX INVOICE" (legal compliance)
- [x] Remove customer signature line
- [x] Add "Total Paid" row in payment breakup
- [x] Replace hardcoded footer with dynamic text from settings
- [x] Add phone number to footer (repeated for visibility)

### Phase 5: Testing
- [ ] Test printer scan and selection
- [ ] Test silent print toggle
- [ ] Test receipt print with phone number and custom footer
- [ ] Test receipt print with barcode/QR
- [ ] Test VFD connection and display
- [ ] Test cash drawer both connection types
- [ ] Test settings persistence
- [ ] Test navigation from sidebar
- [ ] Test footer text max length (200 chars)
- [ ] Verify "TAX INVOICE" header displays correctly
- [ ] Verify "Total Paid" calculation is accurate

---

## 9. File Change Summary

### New Files:
- None (all using existing files)

### Modified Files:
1. `lib/data_source/local/pref_keys.dart` - Add 13 new keys (including phone & footer) ✅
2. `lib/api_requests/pos.dart` - Save cash drawer setting ✅
3. `lib/controllers/item_screen_controller.dart` - Load cash drawer setting ✅
4. `lib/pages/items_cart.dart` - Fix button text and logic ✅
5. `lib/widgets_components/cash_drawer_logic.dart` - Smart connection function ✅
6. `lib/widgets_components/checkout_right_screen.dart` - Update function calls ✅
7. `lib/pages/hardware_settings_page.dart` - Expand with new sections + phone/footer fields ✅
8. `lib/widgets_components/side_bar.dart` - Add settings menu icon ✅
9. `lib/widgets_components/vdf_logic.dart` - Use stored settings
10. `lib/widgets_components/generate_print.dart` - Update receipt format with phone/footer ✅

---

## 10. Dependencies

### Already Available:
- `printing: ^5.12.0` - Printer detection and silent printing
- `flutter_libserialport: ^0.4.0` - VFD and cash drawer serial communication
- `usb_serial: ^0.2.4` - Direct USB cash drawer connection

### No New Dependencies Needed! ✅

---

## 11. Design Notes

### Color Scheme:
- Primary: `AppColors.appbarGreen` (#018644)
- Background: `Colors.grey.shade50`
- Card: `Colors.white`
- Info: `Colors.blue.shade50` with `Colors.blue.shade200` border
- Warning: `Colors.orange.shade50` with `Colors.orange.shade200` border
- Success: `Colors.green.shade50` with `Colors.green.shade200` border

### Typography:
- Section Title: 20sp, bold, green
- Subtitle: 16sp, normal
- Body: 14sp
- Caption: 12sp, gray

### Spacing:
- Card padding: 16w
- Section gap: 16h
- Element gap: 8h/8w
- Border radius: 12r (cards), 8r (buttons)

---

## 12. Receipt Customization Details

### Phone Number Field
**Purpose:** Display contact information on receipts for customer inquiries

**Specifications:**
- Input Type: Single-line text field
- Keyboard: Phone number keyboard
- Icon: 📞 Phone icon (green)
- Placeholder: "Enter phone number for receipts"
- Max Length: None (but typically 15-20 digits with country code)
- Storage: `PrefKeys.receiptPhoneNumber`

**Display Locations on Receipt:**
1. **Header:** After company name (bold, size 8)
2. **Footer:** Repeated before custom footer text (bold, size 7)

**Example Values:**
- `+966 12 345 6789` (Saudi Arabia)
- `+1 (555) 123-4567` (USA)
- `+44 20 7946 0958` (UK)

### Footer Text Field
**Purpose:** Custom message for policies, thank you notes, or legal disclaimers

**Specifications:**
- Input Type: Multi-line text field
- Lines: 2-3 lines visible, scrollable
- Icon: 📝 Notes icon (green)
- Placeholder: "Enter custom footer text (e.g., "Thank you for your business!")"
- Max Length: **200 characters**
- Character Counter: Hidden (but enforced)
- Storage: `PrefKeys.receiptFooterText`
- Default: "Thank you for your business!" (if empty)

**Character Count Examples:**
- Short (35 chars): `"Thank you! Visit us again soon!"`
- Medium (85 chars): `"Please retain this receipt for exchanges. All sales are final after 30 days."`
- Long (131 chars): `"Please keep the receipt for any exchange within 24Hrs. Exchange baby milk, fridge items and temperature sensitive items not allowed"`
- Max (200 chars): Allows 1.5x the example text for flexibility

**Recommended Text Examples:**
```
Exchange Policy (131 chars):
"Please keep the receipt for any exchange within 24Hrs. Exchange baby milk, fridge items and temperature sensitive items not allowed"

Return Policy (97 chars):
"Returns accepted within 7 days with receipt. Items must be unused and in original packaging."

Thank You (48 chars):
"Thank you for shopping with us! Come again!"

Legal Notice (156 chars):
"All prices include VAT. This receipt is valid for warranty claims. No refunds on perishable items. Exchange policy applies as per store terms."
```

### Receipt Width Calculation
**80mm Thermal Receipt:**
- Character width: ~48-50 characters per line (font size 6)
- 200 characters = ~4 lines maximum
- Recommended: 3 lines (150 chars) for best readability

### Legal Compliance Features
1. **"TAX INVOICE" Header:**
   - All caps for legal prominence
   - Font size: 8 (larger than body text)
   - Background: Black
   - Text color: White
   - Placement: Between company header and transaction details

2. **VAT/Tax Information:**
   - VAT number displayed in header
   - VAT breakdown in totals section
   - Legal requirement satisfied

3. **Removed Non-Essential Elements:**
   - Customer signature (not required for retail)
   - Repeated company info (reduces clutter)
   - Hardcoded policies (now customizable)

### Best Practices
✅ **Do:**
- Keep phone number formatted consistently (with country code)
- Use clear, customer-friendly language in footer
- Test print receipts after changing settings
- Keep footer under 150 chars for 3 lines
- Include essential policies (exchange, return, warranty)

❌ **Don't:**
- Exceed 200 characters (enforced by system)
- Use special characters that may not print correctly
- Include time-sensitive information that changes frequently
- Write in ALL CAPS (hard to read, seems aggressive)
- Duplicate information already shown in header

### Thermal Printer Compatibility
- **Font:** Monospace (fixed-width)
- **Encoding:** UTF-8 (supports Arabic, emoji, special chars)
- **Line Width:** 48 characters (80mm paper, ESC/POS standard)
- **Auto-wrap:** Text wraps automatically at line boundary
- **Center Alignment:** Footer text is center-aligned for visual balance

---

## 13. Future Enhancements (Not in Scope)

- [ ] Card/Payment terminal configuration
- [ ] Label printer configuration
- [ ] Network printer support
- [ ] Printer templates editor
- [ ] VFD message customization
- [ ] Hardware diagnostics dashboard
- [ ] Export/Import settings
- [ ] Hardware health monitoring

---

## End of Document
