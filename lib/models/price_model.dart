class PriceModel {
  int? brandID;
  String? brandName;
  int? productCategoryID;
  String? productCategoryName;
  int? storeID;
  int? noOfModels;
  String? nofModelUpdated;
  String? updatedBy;

  PriceModel({
    this.brandID,
    this.brandName,
    this.productCategoryID,
    this.productCategoryName,
    this.storeID,
    this.noOfModels,
    this.nofModelUpdated,
    this.updatedBy,
  });

  PriceModel.fromJson(Map<String, dynamic> json) {
    brandID = json['BrandID'];
    brandName = json['BrandName'];
    productCategoryID = json['ProductCategoryID'];
    productCategoryName = json['ProductCategoryName'];
    storeID = json['StoreID'];
    noOfModels = json['NoOfModels'];
    nofModelUpdated = json['NofModelUpdated'];
    updatedBy = json['UpdatedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BrandID'] = this.brandID;
    data['BrandName'] = this.brandName;
    data['ProductCategoryID'] = this.productCategoryID;
    data['ProductCategoryName'] = this.productCategoryName;
    data['StoreID'] = this.storeID;
    data['NoOfModels'] = this.noOfModels;
    data['NofModelUpdated'] = this.nofModelUpdated;
    data['UpdatedBy'] = this.updatedBy;
    return data;
  }
}
