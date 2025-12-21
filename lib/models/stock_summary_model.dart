class Brand {
  final int brandId;
  final String brandName;
  final List<ProductCategory> products;

  Brand({
    required this.brandId,
    required this.brandName,
    required this.products,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      brandId: json['BrandID'],
      brandName: json['BrandName'],
      products: List<ProductCategory>.from(
        json['Products'].map((x) => ProductCategory.fromJson(x)),
      ),
    );
  }
}

class ProductCategory {
  final String productCategoryName;
  final int productCategoryId;
  final String lastUpdate;
  final String updateBy;
  final int noOfProducts;
  final int modelCount;
  final int displayCheckCount;

  ProductCategory({
    required this.productCategoryName,
    required this.productCategoryId,
    required this.lastUpdate,
    required this.updateBy,
    required this.noOfProducts,
    required this.modelCount,
    required this.displayCheckCount,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      productCategoryName: json['ProductCategoryName'] ?? '',
      productCategoryId: json['ProductCategoryID'] ?? '',
      lastUpdate: json['LastUpdate'] ?? '',
      updateBy: json['UpdatedBy'] ?? '',
      noOfProducts: json['NoOfProducts'] ?? 0,
      modelCount: json['ModelCount'] ?? (json['NoOfProducts'] ?? 0),
      displayCheckCount: json['DisplayCheckCount'] ?? 0,
    );
  }
}
