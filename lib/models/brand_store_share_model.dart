class BrandStoreShareModel {
  int? levelID;
  int? brandID;
  String? brandName;
  int? count;
  String? code;
  String? picture;

  BrandStoreShareModel({
    this.levelID,
    this.brandID,
    this.brandName,
    this.count,
    this.code,
    this.picture,
  });

  BrandStoreShareModel.fromJson(Map<String, dynamic> json) {
    levelID = json['LevelID'];
    brandID = json['BrandID'];
    brandName = json['BrandName'];
    count = json['Count'];
    code = json['Code'];
    picture = json['Picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['LevelID'] = this.levelID;
    data['BrandID'] = this.brandID;
    data['BrandName'] = this.brandName;
    data['Count'] = this.count;
    data['Code'] = this.code;
    data['Picture'] = this.picture;
    return data;
  }
}
