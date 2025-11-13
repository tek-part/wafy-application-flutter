class ApiConstants {
  static const String baseUrl = 'http://151.236.164.137:1002';

  // Auth endpoints
  static const String getUsers = '/api/GetUser';
  static const String getCompInfo = '/api/Getcompinfo';

  // Home endpoints
  static const String getFloors = '/api/GetFloors';
  static const String getTablesByFloorId = '/api/GetTablesByFloorIDAndUserID';
  static const String getTablesStatusByFloorId =
      '/api/ArSalesInvoiceMains/GetTablesByFloorId';
  static const String updateTableStatus =
      '/api/ArSalesInvoiceMains/UpdateTableStatus';

  // Menu endpoints
  static const String getGroups = '/api/GetGroup';
  static const String getItemsByGroup = '/api/GetItemWGroup';
  static const String getItemSizes = '/api/GetSC_ItemSizeAPI'; //GetItemSize
  static const String getAllItemsGroup = '/api/GETALLItemGroupSAPI';
  static const String getAddtition = '/api/GetAPIRSAddtition';

  // Invoice endpoints
  static const String createInvoice =
      '/api/ArSalesInvoiceMains/SalesInvoiceCreate';
  static const String getLastInvoiceByTableId =
      '/api/ArSalesInvoiceMains/GetLastInvoiceByRstableId';
  static const String updateInvoice =
      '/api/ArSalesInvoiceMains/SalesInvoiceUpdate';

  // Timeouts
  static const int connectTimeout = 30000; // 30 seconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 30000; // 30 seconds
}
