class DisplayLocationModel {
  int? displayLocationId;
  String? displayLocationName;
  int? activeStatus;

  DisplayLocationModel({
    this.displayLocationId,
    this.displayLocationName,
    this.activeStatus,
  });

  DisplayLocationModel.fromJson(Map<String, dynamic> json) {
    displayLocationId = json['DisplayLocationID'];
    displayLocationName = json['DisplayLocaitonName'];
    activeStatus = json['ActiveStatus'];
  }

  Map<String, dynamic> toJson() {
    return {
      'DisplayLocationID': displayLocationId,
      'DisplayLocaitonName': displayLocationName,
      'ActiveStatus': activeStatus,
    };
  }
}
