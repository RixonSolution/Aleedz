class MarketActivityList {
  int? activityID;
  int? teamMemberID;
  String? mySingleID;
  String? teamMemberName;
  String? teamTypeName;
  String? activityDateTime;
  int? activityTypeID;
  String? cityName;
  int? cityID;
  String? regionName;
  int? regionID;
  String? channelName;
  int? channelID;
  int? channelTypeID;
  String? activityTypeName;
  int? activityCategoryID;
  String? activityCategoryName;
  int? brandID;
  String? brandName;
  String? activityDescription;
  int? statusID;
  String? quantity;
  int? storeID;
  String? storeCode;
  String? storeName;
  Null isEmailSent;
  String? imageActivity;
  String? imageActivity2;

  MarketActivityList({
    this.activityID,
    this.teamMemberID,
    this.mySingleID,
    this.teamMemberName,
    this.teamTypeName,
    this.activityDateTime,
    this.activityTypeID,
    this.cityName,
    this.cityID,
    this.regionName,
    this.regionID,
    this.channelName,
    this.channelID,
    this.channelTypeID,
    this.activityTypeName,
    this.activityCategoryID,
    this.activityCategoryName,
    this.brandID,
    this.brandName,
    this.activityDescription,
    this.statusID,
    this.quantity,
    this.storeID,
    this.storeCode,
    this.storeName,
    this.isEmailSent,
    this.imageActivity,
    this.imageActivity2,
  });

  MarketActivityList.fromJson(Map<String, dynamic> json) {
    activityID = json['ActivityID'];
    teamMemberID = json['TeamMemberID'];
    mySingleID = json['mySingleID'];
    teamMemberName = json['TeamMemberName'];
    teamTypeName = json['TeamTypeName'];
    activityDateTime = json['ActivityDateTime'];
    activityTypeID = json['ActivityTypeID'];
    cityName = json['CityName'];
    cityID = json['CityID'];
    regionName = json['RegionName'];
    regionID = json['RegionID'];
    channelName = json['ChannelName'];
    channelID = json['ChannelID'];
    channelTypeID = json['ChannelTypeID'];
    activityTypeName = json['ActivityTypeName'];
    activityCategoryID = json['ActivityCategoryID'];
    activityCategoryName = json['ActivityCategoryName'];
    brandID = json['BrandID'];
    brandName = json['BrandName'];
    activityDescription = json['ActivityDescription'];
    statusID = json['StatusID'];
    quantity = json['Quantity'];
    storeID = json['StoreID'];
    storeCode = json['StoreCode'];
    storeName = json['StoreName'];
    isEmailSent = json['IsEmailSent'];
    imageActivity = json['ImageActivity'];
    imageActivity2 = json['ImageActivity2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ActivityID'] = this.activityID;
    data['TeamMemberID'] = this.teamMemberID;
    data['mySingleID'] = this.mySingleID;
    data['TeamMemberName'] = this.teamMemberName;
    data['TeamTypeName'] = this.teamTypeName;
    data['ActivityDateTime'] = this.activityDateTime;
    data['ActivityTypeID'] = this.activityTypeID;
    data['CityName'] = this.cityName;
    data['CityID'] = this.cityID;
    data['RegionName'] = this.regionName;
    data['RegionID'] = this.regionID;
    data['ChannelName'] = this.channelName;
    data['ChannelID'] = this.channelID;
    data['ChannelTypeID'] = this.channelTypeID;
    data['ActivityTypeName'] = this.activityTypeName;
    data['ActivityCategoryID'] = this.activityCategoryID;
    data['ActivityCategoryName'] = this.activityCategoryName;
    data['BrandID'] = this.brandID;
    data['BrandName'] = this.brandName;
    data['ActivityDescription'] = this.activityDescription;
    data['StatusID'] = this.statusID;
    data['Quantity'] = this.quantity;
    data['StoreID'] = this.storeID;
    data['StoreCode'] = this.storeCode;
    data['StoreName'] = this.storeName;
    data['IsEmailSent'] = this.isEmailSent;
    data['ImageActivity'] = this.imageActivity;
    data['ImageActivity2'] = this.imageActivity2;
    return data;
  }
}
