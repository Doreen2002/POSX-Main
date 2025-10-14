class ApiEndpoints{
  // static const String login = '/api/method/login';
  static const String fetchUserAPI = '/api/method/offline_pos_erpnext.api.get_offline_pos_users_with_tokens';
  static const String userTokenAPI = '/api/method/offline_pos_erpnext.api.get_user_token?email=';
  static const String login = '/api/method/offline_pos_erpnext.api.custom_login';

  static const String stockForAllItem = '/api/method/offline_pos_erpnext.api.get_available_stock_for_all_items?pos_profile=';
  static const String stockForSingleItem = '/api/method/offline_pos_erpnext.api.get_available_stock?item_code=laptop&pos_profile=';

  static const String getAppPermissionURL = '/api/resource/User/';

  static const String editItemURL = '/api/resource/Item';

  static const String getItemList ='/api/method/offline_pos_erpnext.API.v14.item_list.get_all_item_list_with_pos_profile?pos_profile=';
  // static const String getItemList = '/api/method/offline_pos_erpnext.API.v14.item_list.get_all_item_list';
  static const String getSingleItemList = '/api/resource/Item';
  static const String getItemGroupList = '/api/method/offline_pos_erpnext.API.v14.item_group.get_all_item_group';
  static const String getCustomerList = '/api/method/offline_pos_erpnext.api.get_customer_list';
  static const String getSalesInvoiceList = '/api/resource/Sales Invoice?fields=["*"]';
  static const String uploadAttachment ='/api/method/brass_industries.brass_mobile_api.attach_file';
  static const String salesInvoice ='/api/resource/Sales Invoice';
  static const String posInvoice ='/api/resource/POS Invoice?fields=["*"]&limit_page_length=15000&order_by=name%20desc';
  static const String batchURL ='/api/resource/Batch?fields=["*"]&limit_page_length=15000';
  static const String serialURL ='/api/resource/Serial No?fields=["*"]&limit_page_length=15000&order_by=name%20desc';
  static const String customerGroupURL ='/api/resource/Customer Group';
  static const String customerURL ='/api/resource/Customer';
  static const String territoryURL ='/api/resource/Territory';
  static const String posProfileURL ='/api/resource/POS Profile?fields=["*"]';
  static const String paymentModeURL ='/api/resource/Mode of Payment';
  static const String getLatestSerialNoURL ='/api/method/offline_pos_erpnext.api.get_fifo_serial_no?item_code=';
  static const String getOpeningEntryCheckURL ='/api/method/offline_pos_erpnext.api.check_opening_entry?user=';
  static const String getCreateOpeningEntryURL ='/api/resource/POS Opening Entry';
  static const String getCreateClosingEntryURL ='/api/resource/POS Closing Entry';
  static const String getPosSettingURL ='/api/method/offline_pos_erpnext.api.get_setting';
  static const String getProfilePasswordURL ='/api/method/offline_pos_erpnext.api.get_pos_profile_password';
}