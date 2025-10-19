# Real-World Barcode Analysis - 4-Digit PLU Samples

## Barcode Samples from 3 Supermarkets

### Sample Data:
```
2150079004503 → Price: BD 0.450
2141983004352 → Price: BD 0.435  
0283638045920 → Price: BD 4.592
9013438021708 → Price: BD 2.170
0235870003428 → Price: BD 0.342
9018026004705 → Price: BD 0.470
0291074001509 → Price: BD 0.150
```

## Analysis Results

### Pattern Detection:

#### **Supermarket 1 (European Standard - Prefix "2")**
```
2150079004503 → Price: BD 0.450
├─ Prefix: 2
├─ PLU: 1500 (4-digit)
├─ Price: 79004 → BD 0.450
├─ Check: 5
└─ Issue: Price encoding doesn't match standard

2141983004352 → Price: BD 0.435
├─ Prefix: 2  
├─ PLU: 1419 (4-digit)
├─ Price: 83004 → BD 0.435
├─ Check: 3
└─ Issue: Price encoding doesn't match standard
```

#### **Supermarket 2 (Custom Format - Prefix "0")**
```
0283638045920 → Price: BD 4.592
├─ Prefix: 0
├─ Data: 283638045920
├─ Possible PLU: 2836 (4-digit)
├─ Possible Price: 38045 → BD 4.592
└─ Non-standard format

0235870003428 → Price: BD 0.342
├─ Prefix: 0
├─ Possible PLU: 2358 (4-digit)  
├─ Possible Price: 70003 → BD 0.342
└─ Non-standard format

0291074001509 → Price: BD 0.150
├─ Prefix: 0
├─ Possible PLU: 2910 (4-digit)
├─ Possible Price: 74001 → BD 0.150
└─ Non-standard format
```

#### **Supermarket 3 (Custom Format - Prefix "9")**
```
9013438021708 → Price: BD 2.170
├─ Prefix: 9
├─ Possible PLU: 0134 (4-digit)
├─ Possible Price: 38021 → BD 2.170
└─ Non-standard format

9018026004705 → Price: BD 0.470
├─ Prefix: 9
├─ Possible PLU: 0180 (4-digit)
├─ Possible Price: 26004 → BD 0.470
└─ Non-standard format
```

## Critical Findings

### 1. **Non-Standard Price Encoding**
The price encoding doesn't follow standard patterns:
- Standard: 5 digits = price in cents/fils (e.g., 00450 = BD 0.450)
- Reality: Variable encoding that doesn't match the mathematical relationship

### 2. **Multiple Prefix Patterns**
Three different prefixes used:
- **Prefix "2"**: 2 barcodes (European-style but non-standard encoding)
- **Prefix "0"**: 3 barcodes (Non-standard format)
- **Prefix "9"**: 2 barcodes (Store-specific format)

### 3. **4-Digit PLU Confirmation**
All samples confirm 4-digit PLUs are standard in this market, not 5-digit.

### 4. **Price Precision**
Prices are in Bahraini Dinars with 3 decimal places (fils), not 2 decimal places assumed in standards.

## Reverse Engineering Analysis

### Attempting to decode the actual format:

#### **For Prefix "2" barcodes:**
```
2150079004503 → BD 0.450
Position analysis:
- Positions 1: "2" (prefix)
- Positions 2-5: "1500" (likely PLU)
- Positions 6-10: "79004" 
- Position 13: "3" (check digit)

Price calculation attempts:
- 79004 ÷ 1000 = 79.004 (too high)
- 450 exists in "79004503" - possible embedded encoding
```

#### **For Prefix "0" barcodes:**
```
0283638045920 → BD 4.592
- Could be non-weight-scale barcode
- Might be regular EAN-13 with embedded price logic
```

#### **For Prefix "9" barcodes:**
```
9013438021708 → BD 2.170
- Store-specific encoding
- Different algorithm than standard weight scale format
```

## Proposed Solution for Real-World Compatibility

### 1. **Flexible PLU Length Support**
```dart
// Support both 4-digit and 5-digit PLUs
class WeightScaleConfig {
  final int pluLength;  // 4 or 5 digits
  final int valueLength; // Variable based on remaining digits
  final String prefix;
  final PriceEncodingType encodingType;
}

enum PriceEncodingType {
  standard,     // Direct cents/fils
  embedded,     // Complex encoding
  custom        // Store-specific algorithm
}
```

### 2. **Multiple Parsing Strategies**
```dart
class WeightScaleBarcodeParser {
  static TempItem? parseBarcode(String barcode) {
    // Try multiple parsing strategies
    for (var strategy in parsingStrategies) {
      final result = strategy.parse(barcode);
      if (result != null && result.isValid()) {
        return result;
      }
    }
    return null;
  }
}
```

### 3. **Price Encoding Detection**
```dart
bool detectPriceEncoding(String barcode, double expectedPrice) {
  // Try different price extraction methods
  final methods = [
    extractStandardPrice,
    extractEmbeddedPrice,
    extractCustomPrice
  ];
  
  for (var method in methods) {
    final extractedPrice = method(barcode);
    if (isCloseToExpected(extractedPrice, expectedPrice)) {
      return true;
    }
  }
  return false;
}
```

## Recommendations

### **Immediate Actions:**
1. **Update PLU length to 4 digits** as default for Middle East markets
2. **Support 3 decimal places** for Bahraini Dinar/Kuwaiti Dinar
3. **Add multiple prefix support** (0, 2, 9)
4. **Implement flexible price encoding** detection

### **Configuration Changes:**
```json
{
  "region": "middle_east",
  "currency_decimals": 3,
  "plu_length": 4,
  "supported_prefixes": ["0", "2", "9"],
  "price_encoding": "auto_detect",
  "fallback_to_manual": true
}
```

### **Testing Requirements:**
Test with actual hardware from these supermarkets to validate parsing logic and ensure compatibility with their weight scale systems.

This analysis shows that real-world implementations vary significantly from international standards, requiring a more flexible and adaptive approach to barcode parsing.