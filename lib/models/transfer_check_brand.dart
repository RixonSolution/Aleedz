class TransferCheckBrand {
  int? brandID;
  String? brandName;
  int? productCategoryID;
  String? productCategoryName;
  int? storeID;
  int? transferModelCount;
  String? lastUpdateDate;
  String? updatedBy;

  TransferCheckBrand({
    this.brandID,
    this.brandName,
    this.productCategoryID,
    this.productCategoryName,
    this.storeID,
    this.transferModelCount,
    this.lastUpdateDate,
    this.updatedBy,
  });

  TransferCheckBrand.fromJson(Map<String, dynamic> json) {
    brandID = json['BrandID'];
    brandName = json['BrandName'];
    productCategoryID = json['ProductCategoryID'];
    productCategoryName = json['ProductCategoryName'];
    storeID = json['StoreID'];
    transferModelCount = json['TransferModelCount'];
    lastUpdateDate = json['LastUpdateDate'];
    updatedBy = json['UpdatedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['BrandID'] = this.brandID;
    data['BrandName'] = this.brandName;
    data['ProductCategoryID'] = this.productCategoryID;
    data['ProductCategoryName'] = this.productCategoryName;
    data['StoreID'] = this.storeID;
    data['TransferModelCount'] = this.transferModelCount;
    data['LastUpdateDate'] = this.lastUpdateDate;
    data['UpdatedBy'] = this.updatedBy;
    return data;
  }
}
