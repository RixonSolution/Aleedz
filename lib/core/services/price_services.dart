import 'dart:convert';
import 'dart:io';
import 'package:aleedz/core/constants/api_constants.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class PriceServices {
  Future<Map<String, dynamic>?> getBrandDropDown({
    required String token,
  }) async {
    final encodedToken = Uri.encodeComponent(token);

    final url = Uri.parse('${ApiConstants.brandDropDown}?_token=$encodedToken');

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      final data = json.decode(response.body);
      return {"status": response.statusCode, "data": data};
    } catch (e) {
      print('Unhandled error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> pricePromotion({
    required String storeId,
    required String brandId,
    required String token,
    required String visiteId,
  }) async {
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedBrandId = Uri.encodeComponent(brandId);
    final encodedToken = Uri.encodeComponent(token);
    final encodedVisitId = Uri.encodeComponent(visiteId);

    final url = Uri.parse(
      '${ApiConstants.pricePromotion}?_token=$encodedToken&StoreID=$encodedStoreId&BrandID=$encodedBrandId&VisitID=$encodedVisitId',
    );

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      final data = json.decode(response.body);
      return {"status": response.statusCode, "data": data};
    } catch (e) {
      print('Unhandled error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> priceList({
    required String token,
    required String brandId,
    required String productCategoryId,
    required String storeId,
    required String visiteId,
  }) async {
    final encodedStoreId = Uri.encodeComponent(storeId);
    final encodedBrandId = Uri.encodeComponent(brandId);
    final encodedToken = Uri.encodeComponent(token);
    final encodedVisitStatus = Uri.encodeComponent(visiteId);
    final encodedProductCategoryId = Uri.encodeComponent(productCategoryId);

    final url = Uri.parse(
      '${ApiConstants.priceList}?_token=$encodedToken&BrandID=$encodedBrandId&ProductCategoryID=$encodedProductCategoryId&StoreID=$encodedStoreId&VisitID=$encodedVisitStatus',
    );

    try {
      final response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      final data = json.decode(response.body);
      return {"status": response.statusCode, "data": data};
    } catch (e) {
      print('Unhandled error: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> priceSubmit({
    required String token,
    required String productId,
    required String storeID,
    required String price,
    required String promotion,
    required String priceTagPictureId,
    required String teamMemberId,
    required String netPrice,
    required String installment3Month,
    required String installment6Month,
    required String installment12Month,
    required String isOutOfStock,
    required String visitId,
    File? checkInImgFile,
  }) async {
    try {
      // Compress image before upload
      Future<File?> compressImage(File file) async {
        final dir = await getTemporaryDirectory();
        final targetPath = path.join(
          dir.path,
          '${DateTime.now().millisecondsSinceEpoch}.jpg',
        );

        final result = await FlutterImageCompress.compressAndGetFile(
          file.absolute.path,
          targetPath,
          quality: 30,
        );

        return result != null ? File(result.path) : null;
      }

      File? compressedImage;
      if (checkInImgFile != null && checkInImgFile.path != '') {
        compressedImage = await compressImage(checkInImgFile);
      }
      final url = Uri.parse(
        '${ApiConstants.priceSubmit}?'
        '_token=${Uri.encodeComponent(token)}&'
        'ProductID=${Uri.encodeComponent(productId)}&'
        'StoreID=${Uri.encodeComponent(storeID)}&'
        'Price=${Uri.encodeComponent(price)}&'
        'Promotion=${Uri.encodeComponent(promotion)}&'
        'PiceTagPictureID=${Uri.encodeComponent(priceTagPictureId)}&'
        'TeamMemberID=${Uri.encodeComponent(teamMemberId)}&'
        'NetPrice=${Uri.encodeComponent(netPrice)}&'
        'Installment_3Month=${Uri.encodeComponent(installment3Month)}&'
        'Installment_6Month=${Uri.encodeComponent(installment6Month)}&'
        'Installment_12Month=${Uri.encodeComponent(installment12Month)}&'
        'IsOutOFStock=${Uri.encodeComponent(isOutOfStock)}&'
        'VisitID=${Uri.encodeComponent(visitId)}',
      );

      var request = http.MultipartRequest('POST', url);

      if (compressedImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath('PricesImg', compressedImage.path),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final data = json.decode(response.body);
      return {"status": response.statusCode, "data": data};
    } catch (e) {
      print('Error during check-in: $e');
      return null;
    }
  }
}
