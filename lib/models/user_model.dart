class UserModel {
  int? teamMemberID;
  int? teamTypeID;
  String? teamMemberName;
  String? mySingleID;
  String? email;
  int? divisionID;
  String? divisionName;
  String? apiToken;
  String? teamTypeName;
  String? regionName;
  int? marketType;

  UserModel({
    this.teamMemberID,
    this.teamTypeID,
    this.teamMemberName,
    this.mySingleID,
    this.email,
    this.divisionID,
    this.divisionName,
    this.apiToken,
    this.teamTypeName,
    this.regionName,
    this.marketType,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    teamMemberID = json['TeamMemberID'];
    teamTypeID = json['TeamTypeID'];
    teamMemberName = json['TeamMemberName'];
    mySingleID = json['mySingleID'];
    email = json['Email'];
    divisionID = json['DivisionID'];
    divisionName = json['DivisionName'];
    apiToken = json['api_token'];
    teamTypeName = json['TeamTypeName'];
    regionName = json['RegionName'];
    marketType = json['MarketType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TeamMemberID'] = this.teamMemberID;
    data['TeamTypeID'] = this.teamTypeID;
    data['TeamMemberName'] = this.teamMemberName;
    data['mySingleID'] = this.mySingleID;
    data['Email'] = this.email;
    data['DivisionID'] = this.divisionID;
    data['DivisionName'] = this.divisionName;
    data['api_token'] = this.apiToken;
    data['TeamTypeName'] = this.teamTypeName;
    data['RegionName'] = this.regionName;
    data['MarketType'] = this.marketType;
    return data;
  }
}
