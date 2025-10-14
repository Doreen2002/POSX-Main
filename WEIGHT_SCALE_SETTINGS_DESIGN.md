# Weight Scale Settings Doctype Design

## Overview
Create a new **Weight Scale Settings** doctype that provides intelligent barcode configuration based on global standards with automatic validation and currency integration.

## Design Principles
1. **Standards-Based**: Barcode type selection drives field configuration
2. **Intelligent Validation**: System validates length and format automatically
3. **Flexible Prefixes**: Multiple prefixes per barcode type via child table
4. **Currency Integration**: Auto-sync from ERPNext Currency doctype
5. **User-Friendly**: Progressive disclosure (enable → type → configure)

## Doctype Structure

### **Weight Scale Settings (Main Doctype)**
```json
{
  "doctype": "Weight Scale Settings",
  "module": "POS",
  "issingle": 1,
  "fields": [...]
}
```

### **Weight Scale Prefix (Child Table)**
```json
{
  "doctype": "Weight Scale Prefix", 
  "module": "POS",
  "istable": 1,
  "fields": [...]
}
```

## Field Specifications

### **Section 1: Enable Weight Scale**
| Field | Type | Description | Behavior |
|-------|------|-------------|----------|
| `enable_weight_scale` | Check | Master switch for weight scale support | Shows/hides all other sections |

### **Section 2: Barcode Type Selection**
| Field | Type | Description | Options | Auto-Sets |
|-------|------|-------------|---------|-----------|
| `barcode_type` | Select | Official barcode standard | See options below | Barcode length |
| `barcode_length` | Int | Total barcode length | - | Auto-set (or manual if Custom) |
| `validate_check_digit` | Check | Enable check digit validation | - | Auto-set by type |

### **Section 3: Format Configuration (Auto-Populated)**
| Field | Type | Description | Auto-Set From |
|-------|------|-------------|---------------|
| `plu_start_position` | Int | PLU starting position (1-based) | Standard |
| `plu_length` | Int | Number of PLU digits | Standard |
| `actual_plu_digits` | Int | Actual PLU digits to extract | Manual entry |
| `value_start_position` | Int | Value starting position (1-based) | Manual entry |
| `value_length` | Int | Number of value digits | Manual entry |
| `value_type` | Select | "price" or "weight" | Manual selection |

### **Section 4: Currency Integration**
| Field | Type | Description | Behavior |
|-------|------|-------------|---------|
| `currency` | Link | ERPNext Currency | Links to Currency doctype |
| `currency_precision` | Int | Decimal places | Auto-synced from Currency |
| `use_currency_precision` | Check | Use auto-synced precision | Default: true |
| `manual_precision_override` | Int | Manual override (debug) | Only if use_currency_precision = false |

### **Section 5: Prefix Configuration (Child Table)**
| Field | Type | Description | Validation |
|-------|------|-------------|------------|
| `prefix` | Data | Barcode prefix (e.g., "21", "02") | Length based on standard |
| `description` | Data | Prefix description | Optional |
| `enabled` | Check | Enable this prefix | Default: true |

## Barcode Type Configuration

### **Weight Scale Compatible Barcode Types Only**
```json
{
  "EAN-13": {
    "label": "EAN-13 (13 digits)",
    "length": 13,
    "character_type": "Numeric (0-9)",
    "validate_check_digit": true,
    "typical_use": "🌍 Global retail & weigh-scale standard",
    "common_weight_scale_format": "2NNNNNVVVVVC or PPNNNNNVVVVVC"
  },
  "UPC-A": {
    "label": "UPC-A (12 digits)",
    "length": 12,
    "character_type": "Numeric (0-9)",
    "validate_check_digit": true,
    "typical_use": "🇺🇸 USA & Canada retail with weight scale support",
    "common_weight_scale_format": "4NNNNNVVVVVC"
  },
  "GS1-DataBar": {
    "label": "GS1 DataBar (14-18 digits)",
    "length": null,
    "character_type": "Numeric (0-9), may include GS1 AIs",
    "validate_check_digit": true,
    "typical_use": "Fresh produce, coupons, detailed encoding",
    "variable_length": true,
    "min_length": 14,
    "max_length": 18,
    "common_weight_scale_format": "Variable with embedded data"
  },
  "Code128": {
    "label": "Code128/GS1-128 (Variable)",
    "length": null,
    "character_type": "Alphanumeric (A-Z, 0-9, symbols)",
    "validate_check_digit": false,
    "typical_use": "Logistics, advanced weighing systems",
    "variable_length": true,
    "max_length": 48,
    "common_weight_scale_format": "Flexible alphanumeric encoding"
  },
  "Custom": {
    "label": "Custom Configuration",
    "length": null,
    "character_type": "User-defined",
    "validate_check_digit": false,
    "typical_use": "Non-standard or proprietary weight scale formats",
    "requires_manual_config": true
  }
}
```

## User Workflow

### **Step 1: Enable Weight Scale**
```
[✓] Enable Weight Scale Support
    ↓ (Shows barcode configuration section)
```

### **Step 2: Select Barcode Type**
```
Barcode Type: [EAN-13 (13 digits) ▼]
              ↓ (Auto-sets length to 13, enables check digit validation)
Barcode Length: 13 (read-only, auto-set)
Validate Check Digit: ✓ (read-only, auto-set)

If "Custom" selected:
Barcode Type: [Custom Configuration ▼]
              ↓ (Enables manual length entry)
Barcode Length: [___] (editable field)
Validate Check Digit: [✓] (user choice)
```

### **Step 3: Configure Weight Scale Format**
```
Weight Scale Format Configuration:
├─ PLU Start Position: [3] (1-based position)
├─ PLU Length: [5] digits total
├─ Actual PLU Digits: [4] (digits to extract from PLU field)
├─ Value Start Position: [8] (1-based position)
├─ Value Length: [5] digits
└─ Value Type: [Price ▼] (Price/Weight)

Note: These fields are always editable for flexibility
```

### **Step 4: Configure Currency**
```
Currency: [BHD ▼] → Auto-sets precision to 3
Currency Precision: 3 (auto-synced)
✓ Use Currency Precision
```

### **Step 5: Add Prefixes**
```
Weight Scale Prefixes:
┌─────────────────────────────────────┐
│ Prefix │ Description │ Enabled     │
├─────────────────────────────────────┤
│ 21     │ Bakery      │ ✓           │
│ 02     │ Fruits      │ ✓           │
│ 90     │ Fixed Price │ ✓           │
└─────────────────────────────────────┘
```

## Validation Logic

### **On Barcode Type Change**
```python
def on_barcode_type_change(self):
    if self.barcode_type and self.barcode_type != "Custom":
        config = get_barcode_type_config(self.barcode_type)
        
        # Auto-set length and validation
        if config.get("length"):
            self.barcode_length = config["length"]
            self.set_df_property("barcode_length", "read_only", 1)
        elif config.get("variable_length"):
            # For variable length types like GS1 DataBar
            self.barcode_length = config.get("min_length", 14)
            self.set_df_property("barcode_length", "read_only", 0)
            # Set length constraints
            self.set_df_property("barcode_length", "description", 
                f"Range: {config.get('min_length', 1)}-{config.get('max_length', 48)} digits")
        
        self.validate_check_digit = config.get("validate_check_digit", False)
        
    elif self.barcode_type == "Custom":
        # Enable manual configuration
        self.set_df_property("barcode_length", "read_only", 0)
        self.set_df_property("barcode_length", "description", "Enter custom barcode length")
        self.barcode_length = None
        self.validate_check_digit = 0
```

### **On Currency Change**
```python
def on_currency_change(self):
    if self.currency:
        currency_doc = frappe.get_doc("Currency", self.currency)
        if self.use_currency_precision:
            self.currency_precision = currency_doc.decimal_places
```

### **Validation Rules**
```python
def validate(self):
    if self.enable_weight_scale:
        # Require barcode type
        if not self.barcode_type:
            frappe.throw("Please select a Barcode Type")
        
        # Require barcode length
        if not self.barcode_length:
            frappe.throw("Please specify Barcode Length")
        
        # Validate length constraints for variable length types
        if self.barcode_type in ["GS1-DataBar", "Code128"]:
            config = get_barcode_type_config(self.barcode_type)
            min_len = config.get("min_length", 1)
            max_len = config.get("max_length", 48)
            if not (min_len <= self.barcode_length <= max_len):
                frappe.throw(f"Length for {self.barcode_type} must be between {min_len} and {max_len} digits")
        
        # Validate weight scale configuration (if enabled)
        if self.is_weight_scale_configured():
            self.validate_weight_scale_format()
        
        # Require currency for weight scale
        if not self.currency:
            frappe.throw("Please select a Currency")

def validate_weight_scale_format(self):
    """Validate weight scale specific configuration"""
    # Validate position arithmetic
    if self.plu_start_position and self.plu_length:
        if self.plu_start_position + self.plu_length - 1 > self.barcode_length:
            frappe.throw("PLU section exceeds barcode length")
    
    if self.value_start_position and self.value_length:
        if self.value_start_position + self.value_length - 1 > self.barcode_length:
            frappe.throw("Value section exceeds barcode length")
    
    # Validate actual PLU digits
    if self.actual_plu_digits and self.plu_length:
        if self.actual_plu_digits > self.plu_length:
            frappe.throw("Actual PLU digits cannot exceed PLU length")
    
    # Validate prefix lengths (context-sensitive)
    for prefix_row in self.prefixes:
        if prefix_row.enabled and prefix_row.prefix:
            prefix_len = len(prefix_row.prefix)
            if self.plu_start_position and prefix_len >= self.plu_start_position:
                frappe.throw(f"Prefix '{prefix_row.prefix}' ({prefix_len} digits) is too long. Must be less than PLU start position ({self.plu_start_position})")

def is_weight_scale_configured(self):
    """Check if weight scale format fields are configured"""
    return (self.plu_start_position and self.plu_length and 
            self.value_start_position and self.value_length)
```

## JavaScript Behavior

### **Progressive Disclosure**
```javascript
frappe.ui.form.on('Weight Scale Settings', {
    enable_weight_scale: function(frm) {
        frm.toggle_display(['barcode_section', 'format_section', 'currency_section', 'prefix_section'], 
                          frm.doc.enable_weight_scale);
    },
    
    barcode_type: function(frm) {
        if (frm.doc.barcode_type) {
            frm.call('on_barcode_type_change');
        }
        
        // Show/hide length field based on type
        const is_custom = frm.doc.barcode_type === 'Custom';
        const is_variable = ['GS1-DataBar', 'Code128'].includes(frm.doc.barcode_type);
        
        frm.toggle_enable('barcode_length', is_custom || is_variable);
        
        // Update field descriptions
        if (is_custom) {
            frm.set_df_property('barcode_length', 'description', 'Enter custom barcode length');
        } else if (is_variable) {
            // Set appropriate range description via server call
            frm.call('get_length_constraints');
        }
    },
    
    currency: function(frm) {
        if (frm.doc.currency && frm.doc.use_currency_precision) {
            frm.call('sync_currency_precision');
        }
    },
    
    // Real-time validation for position fields
    plu_start_position: function(frm) { frm.call('validate_positions'); },
    plu_length: function(frm) { frm.call('validate_positions'); },
    value_start_position: function(frm) { frm.call('validate_positions'); },
    value_length: function(frm) { frm.call('validate_positions'); }
});

// Child table validation
frappe.ui.form.on('Weight Scale Prefix', {
    prefix: function(frm, cdt, cdn) {
        // Real-time prefix validation
        frm.call('validate_prefix_length', {
            'prefix': locals[cdt][cdn].prefix
        });
    }
});
```

## API Integration

### **Sync to PosX Frontend**
```python
@frappe.whitelist()
def get_weight_scale_config():
    """Get weight scale configuration for PosX frontend"""
    settings = frappe.get_single("Weight Scale Settings")
    
    if not settings.enable_weight_scale:
        return {"enabled": False}
    
    prefixes = [p.prefix for p in settings.prefixes if p.enabled]
    
    return {
        "enabled": True,
        "barcode_length": settings.barcode_length,
        "prefixes": prefixes,
        "plu_start": settings.plu_start_position,
        "plu_length": settings.plu_length,
        "actual_plu_digits": settings.actual_plu_digits,
        "value_start": settings.value_start_position,
        "value_length": settings.value_length,
        "value_type": settings.value_type,
        "currency_precision": settings.currency_precision,
        "validate_check_digit": settings.validate_check_digit
    }
```

## Benefits of This Design

### **For Users**
- ✅ **Simple Setup**: Select standard → auto-configures everything
- ✅ **Guided Configuration**: Progressive disclosure prevents overwhelm
- ✅ **Validation**: Automatic validation prevents configuration errors
- ✅ **Flexibility**: Custom mode for non-standard requirements

### **For Developers**
- ✅ **Standards Compliance**: Built-in global barcode standards
- ✅ **Extensible**: Easy to add new standards
- ✅ **Type Safety**: Clear field definitions and validation
- ✅ **API Ready**: Clean data structure for frontend consumption

### **For Implementation**
- ✅ **Zero Migration**: New doctype, doesn't affect existing data
- ✅ **Backward Compatible**: Can coexist with current weight scale settings
- ✅ **Future Proof**: Extensible design for new barcode standards

This design provides a professional, standards-based solution that guides users through proper configuration while maintaining flexibility for custom requirements. Ready to implement?