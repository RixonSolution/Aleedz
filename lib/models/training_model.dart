class TrainingListModel {
  int? trainingID;
  int? storeID;
  String? regionName;
  String? cityName;
  String? channelName;
  String? channelTypeName;
  String? storeTypeName;
  String? storeCode;
  String? storeName;
  String? description;
  String? trainingDateTime;
  String? trainingModelFeatureTitle;
  String? trainingModelTitle;
  int? attendese;
  int? additionalAttendese;
  String? teamMemberName;
  String? mySingleID;

  TrainingListModel({
    this.trainingID,
    this.storeID,
    this.regionName,
    this.cityName,
    this.channelName,
    this.channelTypeName,
    this.storeTypeName,
    this.storeCode,
    this.storeName,
    this.description,
    this.trainingDateTime,
    this.trainingModelFeatureTitle,
    this.trainingModelTitle,
    this.attendese,
    this.additionalAttendese,
    this.teamMemberName,
    this.mySingleID,
  });

  TrainingListModel.fromJson(Map<String, dynamic> json) {
    trainingID = json['TrainingID'];
    storeID = json['StoreID'];
    regionName = json['RegionName'];
    cityName = json['CityName'];
    channelName = json['ChannelName'];
    channelTypeName = json['ChannelTypeName'];
    storeTypeName = json['StoreTypeName'];
    storeCode = json['StoreCode'];
    storeName = json['StoreName'];
    description = json['Description'];
    trainingDateTime = json['TrainingDateTime'];
    trainingModelFeatureTitle = json['TrainingModelFeatureTitle'];
    trainingModelTitle = json['TrainingModelTitle'];
    attendese = json['Attendese'];
    additionalAttendese = json['AdditionalAttendese'];
    teamMemberName = json['TeamMemberName'];
    mySingleID = json['mySingleID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TrainingID'] = this.trainingID;
    data['StoreID'] = this.storeID;
    data['RegionName'] = this.regionName;
    data['CityName'] = this.cityName;
    data['ChannelName'] = this.channelName;
    data['ChannelTypeName'] = this.channelTypeName;
    data['StoreTypeName'] = this.storeTypeName;
    data['StoreCode'] = this.storeCode;
    data['StoreName'] = this.storeName;
    data['Description'] = this.description;
    data['TrainingDateTime'] = this.trainingDateTime;
    data['TrainingModelFeatureTitle'] = this.trainingModelFeatureTitle;
    data['TrainingModelTitle'] = this.trainingModelTitle;
    data['Attendese'] = this.attendese;
    data['AdditionalAttendese'] = this.additionalAttendese;
    data['TeamMemberName'] = this.teamMemberName;
    data['mySingleID'] = this.mySingleID;
    return data;
  }
}
