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
  final int noOfProducts;

  ProductCategory({
    required this.productCategoryName,
    required this.productCategoryId,
    required this.lastUpdate,
    required this.noOfProducts,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      productCategoryName: json['ProductCategoryName'] ?? '',
      productCategoryId: json['ProductCategoryID'] ?? '',
      lastUpdate: json['LastUpdate'] ?? '',
      noOfProducts: json['NoOfProducts'] ?? 0,
    );
  }
}
