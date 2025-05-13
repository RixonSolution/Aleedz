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

class PictureListModel {
  final int pictureElementId;
  final String pictureElementName;

  PictureListModel({
    required this.pictureElementId,
    required this.pictureElementName,
  });

  factory PictureListModel.fromJson(Map<String, dynamic> json) {
    return PictureListModel(
      pictureElementId: json['StorePictureElementID'] ?? 0,
      pictureElementName: json['StorePictureElementName'] ?? '',
    );
  }

  @override
  String toString() => pictureElementName; // For UI display
}
