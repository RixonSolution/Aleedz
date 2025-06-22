import 'package:aleedz/core/services/transfer_services.dart';
import 'package:aleedz/models/product_transfer_model.dart';

class TransferController {
  final TransferServices _apiService = TransferServices();

  Future<Map<String, dynamic>?> transferList({
    required String teamMemberId,
    required String visiteId,
    required String chanelId,
    required String searchKeyWord,
    required String chanelTypeId,
    required String token,
  }) async {
    return await _apiService.getTtransferList(
      teamMemberId: teamMemberId,
      chanelId: chanelId,
      searchKeyWord: searchKeyWord,
      chanelTypeId: chanelTypeId,
      token: token,
      visiteId: visiteId,
    );
  }

  Future<Map<String, dynamic>?> transferDropDown({
    required String token,
  }) async {
    return await _apiService.getTransferDropDown(token: token);
  }

  Future<Map<String, dynamic>?> brandDropDown({required String token}) async {
    return await _apiService.getBrandDropDown(token: token);
  }

  Future<Map<String, dynamic>?> transferBrandView({
    required String storeId,
    required String brandId,
    required String visiteId,
    required String token,
  }) async {
    return await _apiService.transferBrandView(
      storeId: storeId,
      brandId: brandId,
      token: token,
      visiteId: visiteId,
    );
  }

  Future<Map<String, dynamic>?> transferCheckBrand({
    required String storeId,
    required String brandId,
    required String visiteId,
    required String token,
  }) async {
    return await _apiService.transferCheckBrand(
      storeId: storeId,
      brandId: brandId,
      token: token,
      visiteId: visiteId,
    );
  }

  Future<Map<String, dynamic>?> transferSubmitList({
    required String storeId,
    required String categoryId,
    required String visiteStatus,
    required String token,
  }) async {
    return await _apiService.transferSubmitList(
      storeId: storeId,
      token: token,
      categoryId: categoryId,
      visiteStatus: visiteStatus,
    );
  }

  Future<Map<String, dynamic>?> transferSubmit({
    required List<ProductTransferModel> transferModel,
  }) async {
    return await _apiService.transferSubmit(transferModelList: transferModel);
  }
}
