class ShelfShareDisplayLocationModel {
  int? shelfShareDisplayId;
  int? shelfShareId;
  int? shelfShareDisplayLocationId;
  String? shelfShareDisplayLocationName;
  int? isShelfShareDisplay;
  String? code;
  String? picture;

  ShelfShareDisplayLocationModel({
    this.shelfShareDisplayId,
    this.shelfShareId,
    this.shelfShareDisplayLocationId,
    this.shelfShareDisplayLocationName,
    this.isShelfShareDisplay,
    this.code,
    this.picture,
  });

  ShelfShareDisplayLocationModel.fromJson(Map<String, dynamic> json) {
    shelfShareDisplayId = int.tryParse(json['ShelfShareDisplayID']?.toString() ?? '');
    shelfShareId = int.tryParse(json['ShelfShareID']?.toString() ?? '');
    shelfShareDisplayLocationId = int.tryParse(
      json['ShelfShareDisplayLocationID']?.toString() ?? '',
    );
    shelfShareDisplayLocationName =
        json['ShelfShareDisplayLocationName'] ??
        json['DisplayLocationName'] ??
        json['ShelfShareDisplayLocation'];
    isShelfShareDisplay = int.tryParse(json['IsShelfShareDisplay']?.toString() ?? '');
    code = json['Code'];
    picture = json['ShelfShare_Image'] ?? json['Picture'];
  }
}
