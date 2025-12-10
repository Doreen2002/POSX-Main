
class PrefKeys {
  PrefKeys._();
  static const String baseUrl = "baseUrl";
  static const String enableWeightScale = "enableWeightScale";
  static const String barcodeType = "barcodeType";
  static const String barcodeLength = "barcodeLength";
  static const String validateCheckDigit = "validateCheckDigit";
  static const String valueType = "valueType";
  static const String pluStartPosition = "pluStartPosition";
  static const String pluLength = "pluLength";
  static const String valueStartPosition = "valueStartPosition";
  static const String valueLength = "valueLength";
   static const String weightScalePrefixes = "weightScalePrefixes";
   static const String pluMaxLength = "pluMaxLength";
   static const String scalePluLength = "scalePluLength";
   static const String vfdWelcomeText = "vfdWelcomeText";
   static const String scaleValueLength = "scaleValueLength";
   static const String enableBelowCostValidation = "enableBelowCostValidation";
   static const String weightScalePrefix = "weightScalePrefix";
  static const String actualPluDigits = "actualPluDigits";
  static const String databaseHostUrl = "databaseHostUrl";
 static const String httpType = "httpType";
  static const String userName = "userName";
  static const String fullName = "fullName";
  static const String password = "password";
  static const String cookies = "cookies";
  static const String deviceID = "deviceID";
  static const String licenseKey = "licenseKey";
  static const String allowNegativeStock = "allowNegativeStock";
  static const String openingEntry = "openingEntry";
  static const String openingAmount = "openingAmount";
  static const String closeEntry = "closeEntry";
  static const String posProfileName = "posProfileName";
  static const String maxSyncMin = "maxSyncMin";
    static const String syncInterval = "syncInterval";
static const String companyEmail = "companyEmail";
static const String isVatEnabled = "isVatEnabled";
  //<-------------Setting Value------------->
  static const String adminUserToken = "adminUserToken";
  static const String loggedInUserToken = "loggedInUserToken";
  static const String activePosProfile = "activePosProfile";
  static const String internetStatus = "internetStatus";
  static const String syncStatus = "syncStatus";
  static const String isOfflinePOSSetup = 'isOfflinePOSSetup';
  static const String licenseActivated = 'licenseActivated';

  //Item scan settings
  static const String autoPressEnterOnScan = 'autoPressEnterOnScan';
  static const String disableBeep = 'disableBeep';
  static const String delayMilliSecondsScan = 'delayMilliSecondsScan';
  static const String scanBarcodeLength = 'scanBarcodeLength';
  static const String loginInternet = "1";
  static const String defaultPrinter = "defaultPrinter";
  static const String defaultPrinterUrl = "defaultPrinterUrl";
  //backupsettings 
  static const String backupFolder = "backupFolder";
  static const String backupRetentionDays = "backupRetentionDays";
  static const String backupRunsPerDay = "backupRunsPerDay";
  static const String backupFirstRunHour = "backupFirstRunHour";
  static const String backupFirstRunMinute = "backupFirstRunMinute";



  static const String customerName = "customerName";
  static const String customer = "customer";
  static const String defaultCompany = "defaultCompany";
  static const String currency = "currency";
    static const String  currencyPrecision = 'currencyPrecision';
  static const String companyName = "companyName";
  static const String taxID = "taxID";
  static const String crNO = "crNO";
  static const String  companyAddress = "companyAddress";
  static const String walkInCustomer = "walkInCustomer";
  static const String originalWalkInCustomer = "originalWalkInCustomer";
  static const String posProfileWarehouse = "posProfileWarehouse";
  static const String posProfileTaxCharges = "posProfileTaxCharges";
  static const String salesPerson = "salesPerson";
  static const String branchID = "branchID";
  static const String country = "country";
  static const String applyDiscountOn = "applyDiscountOn";
  static const String maxDiscountAllowed = "maxDiscountAllowed";

  static const String openingCounter = "openingCounter";
  static const String closeCounter = "closeCounter";

  static const String closingCounterAmount = "closingCounterAmount";

  static const String databaseUser = "databaseUser";
  static const String databaseName = "databaseName";
  static const String databasePassword = "databasePassword";
  static const String databasePort = "databasePort";


  static const String profilePassword = "profilePassword";
  static const String statusMessage = "statusMessage";
  static const String startStatusMessage = "startStatusMessage";
  static const String endStatusMessage = "endStatusMessage";

  static const String batchQty = "batchQty";

  // Hardware / printing / display prefs
  static const String receiptPrinterUrl = 'receiptPrinterUrl';
  static const String silentPrintEnabled = 'silentPrintEnabled';
  static const String autoPrintReceipt = 'autoPrintReceipt';
  static const String receiptPhoneNumber = 'receiptPhoneNumber';
  static const String receiptFooterText = 'receiptFooterText';

  // VFD display prefs
  static const String vfdEnabled = 'vfdEnabled';
  static const String vfdComPort = 'vfdComPort';
  static const String vfdBaudRate = 'vfdBaudRate';
  static const String vfdDataBits = 'vfdDataBits';
  static const String vfdStopBits = 'vfdStopBits';
  static const String vfdParity = 'vfdParity';

  // Cash drawer prefs
  static const String openCashDrawer = 'openCashDrawer';
  static const String cashDrawerConnectionType = 'cashDrawerConnectionType';

  static const String paymentMode = "paymentMode";
  static const String paidAmount = "paidAmount";
  static const String totalDiscountPrice = "totalDiscountPrice";
  static const String totalGrandDiscountPrice = "totalGrandDiscountPrice";
  static const String totalPrice = "totalPrice";
  static const String netTotalPrice = "netTotalPrice";
  static const String totalGrandPrice = "totalGrandPrice";

  static const String vatAmount = "vatAmount";
  static const String vatAmountTotal = "vatAmountTotal";
  static const String totalDiscountVATPrice = "totalDiscountVATPrice";

  static const String outstandingValue = "outstandingValue";
  static const String paidValue = "paidValue";
  static const String changeValue = "changeValue";

  static const String latitude = "latitude";
  static const String longitude = "longitude";
  static const String fcmToken = "fcmToken";
  static const String appPermissions = "appPermissions";
  static const String so_check = "so_check";
  static const String wo_check = "wo_check";
  static const String po_check = "po_check";
  static const String pr_check = "pr_check";
  static const String bom_check = "bom_check";
  static const String jc_check = "jc_check";
  static const String se_check = "se_check";
  static const String dn_check = "dn_check";
  static const String jwout_check = "jwout_check";
  static const String jwin_check = "jwin_check";
  static const String item_check = "item_check";
  static const String rm_transfer = "rm_tranfer";
  static const String machine_with_production= "machine_with_production";
  static const String user_check= "user_check";

  static const String stock_balance_by_warehouse = "stock_balance_by_warehouse" ;
  static const String wo_with_operation = "wo_with_operation" ;
  static const String delivery_schedule_report = "delivery_schedule_report" ;
  static const String po_pending_rec_qty = "po_pending_rec_qty" ;
  static const String item_report = "item_report" ;
  static const String so_report_by_customer = "so_report_by_customer" ;
  static const String end_tracebility_report = "end_tracebility_report" ;
  static const String workorder_summary_report = "workorder_summary_report";
  static const String machine_availability_report = "machine_availability_report";

  static const String customerInterval = "customerInterval";
  static const String invoiceInterval = "invoiceInterval";
  static const String itemAndInventoryInterval = "itemAndInventoryInterval";

}
