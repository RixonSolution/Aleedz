class BrandListModel {
  final int brandId;
  final String brandName;

  BrandListModel({required this.brandId, required this.brandName});

  factory BrandListModel.fromJson(Map<String, dynamic> json) {
    return BrandListModel(
      brandId: json['BrandID'] ?? 0,
      brandName: json['BrandName'] ?? '',
    );
  }

  @override
  String toString() => brandName; // For UI display
}
