class BrandListModel {
  final int brandId;
  final String brandName;
  final String planogramPicture1;
  final String planogramPicture2;
  final String planogramPicture3;

  BrandListModel({
    required this.brandId,
    required this.brandName,
    this.planogramPicture1 = '',
    this.planogramPicture2 = '',
    this.planogramPicture3 = '',
  });

  factory BrandListModel.fromJson(Map<String, dynamic> json) {
    return BrandListModel(
      brandId: json['BrandID'] ?? 0,
      brandName: json['BrandName'] ?? '',
      planogramPicture1: (json['Planogram_Picture1'] ?? '').toString(),
      planogramPicture2: (json['Planogram_Picture2'] ?? '').toString(),
      planogramPicture3: (json['Planogram_Picture3'] ?? '').toString(),
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

class CategoryIssueModel {
  final int categoryId;
  final String categoryName;
  final int activeStatus;

  CategoryIssueModel({
    required this.categoryId,
    required this.categoryName,
    required this.activeStatus,
  });

  factory CategoryIssueModel.fromJson(Map<String, dynamic> json) {
    return CategoryIssueModel(
      categoryId: json['IssueCategoryID'] ?? 0,
      categoryName: json['IssueCategory'] ?? '',
      activeStatus: json['ActiveStatus'] ?? 0,
    );
  }

  @override
  String toString() => categoryName; // For UI display
}
