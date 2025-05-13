class PictureViewModel {
  int? pictureID;
  int? storeID;
  int? teamMembeID;
  int? brandID;
  int? pictureElementID;
  String? remarks;
  String? creationDateTime;
  String? storePictureElementName;
  String? brandName;
  String? pictureName;
  String? column1;

  PictureViewModel({
    this.pictureID,
    this.storeID,
    this.teamMembeID,
    this.brandID,
    this.pictureElementID,
    this.remarks,
    this.creationDateTime,
    this.storePictureElementName,
    this.brandName,
    this.pictureName,
    this.column1,
  });

  PictureViewModel.fromJson(Map<String, dynamic> json) {
    pictureID = json['PictureID'];
    storeID = json['StoreID'];
    teamMembeID = json['TeamMembeID'];
    brandID = json['BrandID'];
    pictureElementID = json['PictureElementID'];
    remarks = json['Remarks'];
    creationDateTime = json['CreationDateTime'];
    storePictureElementName = json['StorePictureElementName'];
    brandName = json['BrandName'];
    pictureName = json['PictureName'];
    column1 = json['Column1'];
  }

  Map<String, dynamic> toJson() {
    return {
      "PictureID": this.pictureID,
      "StoreID": this.storeID,
      "TeamMembeID": this.teamMembeID,
      "BrandID": this.brandID,
      "StoreID": this.storeID,
      "PictureElementID": this.pictureElementID,
      "Remarks": this.remarks,
      "CreationDateTime": this.creationDateTime,
      "BrandName": this.brandName,
      "PictureName": this.pictureName,
      "Column1": this.column1,
    };
  }
}
