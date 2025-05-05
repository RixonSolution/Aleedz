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
  final int productCategoryId;
  final String productCategoryName;
  final int storeId;
  final int modelCount;
  final int displayCheckCount;

  ProductCategory({
    required this.productCategoryId,
    required this.productCategoryName,
    required this.storeId,
    required this.modelCount,
    required this.displayCheckCount,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      productCategoryId: json['ProductCategoryID'],
      productCategoryName: json['ProductCategoryName'],
      storeId: json['StoreID'],
      modelCount: json['ModelCount'],
      displayCheckCount: json['DisplayCheckCount'],
    );
  }
}
