import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:wafy/core/network/api_constants.dart';
import 'package:wafy/features/auth/data/models/company_model.dart';
import 'package:wafy/features/auth/data/models/user_model.dart';
import 'package:wafy/features/home/data/models/floor_model.dart';
import 'package:wafy/features/home/data/models/table_model.dart';
import 'package:wafy/features/home/data/models/table_status_response_model.dart';
import 'package:wafy/features/menu/data/models/item_size_model.dart';
import 'package:wafy/features/menu/data/models/menu_category_model.dart';
import 'package:wafy/features/menu/data/models/menu_item_model.dart';
import 'package:wafy/features/table_details/data/models/create_invoice_response_model.dart';
import 'package:wafy/features/table_details/data/models/invoice_request_model.dart';
import 'package:wafy/features/table_details/data/models/invoice_response_model.dart';
import 'package:wafy/features/table_details/data/models/update_table_status_response_model.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET(ApiConstants.getUsers)
  Future<List<UserModel>> getUsers();

  @GET(ApiConstants.getCompInfo)
  Future<List<CompanyModel>> getCompInfo();

  @GET(ApiConstants.getFloors)
  Future<List<FloorModel>> getFloors(@Query('ID') int userId);

  @GET(ApiConstants.getTablesByFloorId)
  Future<List<TableModel>> getTablesByFloorId(@Query('ID') int floorId);

  @GET('${ApiConstants.getTablesStatusByFloorId}/{floorId}')
  Future<TableStatusResponseModel> getTablesStatusByFloorId(
    @Path('floorId') int floorId,
  );

  @GET(ApiConstants.getGroups)
  Future<List<MenuCategoryModel>> getGroups();

  @GET(ApiConstants.getItemsByGroup)
  Future<List<MenuItemModel>> getItemsByGroup(@Query('ID') int categoryId);

  @GET(ApiConstants.getItemSizes)
  Future<List<ItemSizeModel>> getItemSizes(@Query('ID') int itemId);

  @POST(ApiConstants.createInvoice)
  Future<CreateInvoiceResponseModel> createInvoice(
    @Body() InvoiceRequestModel request,
  );

  @GET('${ApiConstants.getLastInvoiceByTableId}/{rstableId}')
  Future<InvoiceResponseModel> getLastInvoiceByTableId(
    @Path('rstableId') int rstableId,
  );

  @POST('${ApiConstants.updateInvoice}/{invoiceId}')
  Future<CreateInvoiceResponseModel> updateInvoice(
    @Path('invoiceId') int invoiceId,
    @Body() InvoiceRequestModel request,
  );
  @POST('${ApiConstants.updateTableStatus}/{rstableId}')
  Future<UpdateTableStatusResponseModel> updateTableStatus(
    @Path('rstableId') int rsTableId,
    @Body() Map<String, dynamic> request,
  );
}
