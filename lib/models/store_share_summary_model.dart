class StoreShareSummaryModel {
  int? brandId;
  String? brandName;
  int? storeShareElementId;
  int? storeShareElementTypeId;
  String? storeShareElementTypeName;
  String? storeShareElementName;
  String? storeShareDate;
  int? quantity;
  String? image1;
  String? image2;

  StoreShareSummaryModel({
    this.brandId,
    this.brandName,
    this.storeShareElementId,
    this.storeShareElementTypeId,
    this.storeShareElementTypeName,
    this.storeShareElementName,
    this.storeShareDate,
    this.quantity,
    this.image1,
    this.image2,
  });

  StoreShareSummaryModel.fromJson(Map<String, dynamic> json) {
    brandId = int.tryParse(json['BrandID']?.toString() ?? '');
    brandName = json['BrandName'];
    storeShareElementId = int.tryParse(
      (json['StoreShareElementID'] ?? json['StoreShare_ElementID'])
              ?.toString() ??
          '',
    );
    storeShareElementTypeId =
        int.tryParse(json['StoreShare_ElementTypeID']?.toString() ?? '');
    storeShareElementTypeName = json['StoreShare_ElementTypeName'];
    storeShareElementName = json['StoreShare_ElementName'];
    storeShareDate = json['StoreShareDate']?.toString();
    quantity = int.tryParse(json['Quantity']?.toString() ?? '');
    image1 = json['Image_1']?.toString();
    image2 = json['Image_2']?.toString();
  }
}
