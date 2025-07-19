class OpenIssueModel {
  int? activityID;
  int? activityTypeID;
  int? activityCategoryID;
  int? storeID;
  String? activityDescription;
  String? activityDateTime;
  String? storeCode;
  String? storeName;
  String? regionName;
  String? cityName;
  String? activityCategoryName;
  String? activityTypeName;

  OpenIssueModel({
    this.activityID,
    this.activityTypeID,
    this.activityCategoryID,
    this.storeID,
    this.activityDescription,
    this.activityDateTime,
    this.storeCode,
    this.storeName,
    this.regionName,
    this.cityName,
    this.activityCategoryName,
    this.activityTypeName,
  });

  OpenIssueModel.fromJson(Map<String, dynamic> json) {
    activityID = json['ActivityID'];
    activityTypeID = json['ActivityTypeID'];
    activityCategoryID = json['ActivityCategoryID'];
    storeID = json['StoreID'];
    activityDescription = json['ActivityDescription'];
    activityDateTime = json['ActivityDateTime'];
    storeCode = json['StoreCode'];
    storeName = json['StoreName'];
    regionName = json['RegionName'];
    cityName = json['CityName'];
    activityCategoryName = json['ActivityCategoryName'];
    activityTypeName = json['ActivityTypeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ActivityID'] = this.activityID;
    data['ActivityTypeID'] = this.activityTypeID;
    data['ActivityCategoryID'] = this.activityCategoryID;
    data['StoreID'] = this.storeID;
    data['ActivityDescription'] = this.activityDescription;
    data['ActivityDateTime'] = this.activityDateTime;
    data['StoreCode'] = this.storeCode;
    data['StoreName'] = this.storeName;
    data['RegionName'] = this.regionName;
    data['CityName'] = this.cityName;
    data['ActivityCategoryName'] = this.activityCategoryName;
    data['ActivityTypeName'] = this.activityTypeName;
    return data;
  }
}
