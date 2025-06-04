class ProductCategoryDP {
  int? productCategoryID;
  String? productCategoryName;
  int? brandID;
  String? brandName;

  ProductCategoryDP({
    this.productCategoryID,
    this.productCategoryName,
    this.brandID,
    this.brandName,
  });

  ProductCategoryDP.fromJson(Map<String, dynamic> json) {
    productCategoryID = json['ProductCategoryID'];
    productCategoryName = json['ProductCategoryName'];
    brandID = json['BrandID'];
    brandName = json['BrandName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductCategoryID'] = this.productCategoryID;
    data['ProductCategoryName'] = this.productCategoryName;
    data['BrandID'] = this.brandID;
    data['BrandName'] = this.brandName;
    return data;
  }
}
