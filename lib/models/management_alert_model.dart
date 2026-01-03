class ManagementAlertModel {
  int? activityId;
  int? teamMemberId;
  String? mySingleId;
  String? teamMemberName;
  String? teamTypeName;
  String? activityDateTime;
  int? activityTypeId;
  String? cityName;
  int? cityId;
  String? regionName;
  int? regionId;
  String? channelName;
  int? channelId;
  int? channelTypeId;
  String? activityTypeName;
  int? activityCategoryId;
  String? activityCategoryName;
  int? brandId;
  String? brandName;
  String? activityDescription;
  int? statusId;
  String? quantity;
  int? storeId;
  String? storeCode;
  String? storeName;
  dynamic isEmailSent;
  String? imageActivity;
  String? imageActivity2;

  ManagementAlertModel({
    this.activityId,
    this.teamMemberId,
    this.mySingleId,
    this.teamMemberName,
    this.teamTypeName,
    this.activityDateTime,
    this.activityTypeId,
    this.cityName,
    this.cityId,
    this.regionName,
    this.regionId,
    this.channelName,
    this.channelId,
    this.channelTypeId,
    this.activityTypeName,
    this.activityCategoryId,
    this.activityCategoryName,
    this.brandId,
    this.brandName,
    this.activityDescription,
    this.statusId,
    this.quantity,
    this.storeId,
    this.storeCode,
    this.storeName,
    this.isEmailSent,
    this.imageActivity,
    this.imageActivity2,
  });

  ManagementAlertModel.fromJson(Map<String, dynamic> json) {
    activityId = json['ActivityID'];
    teamMemberId = json['TeamMemberID'];
    mySingleId = json['mySingleID'];
    teamMemberName = json['TeamMemberName'];
    teamTypeName = json['TeamTypeName'];
    activityDateTime = json['ActivityDateTime'];
    activityTypeId = json['ActivityTypeID'];
    cityName = json['CityName'];
    cityId = json['CityID'];
    regionName = json['RegionName'];
    regionId = json['RegionID'];
    channelName = json['ChannelName'];
    channelId = json['ChannelID'];
    channelTypeId = json['ChannelTypeID'];
    activityTypeName = json['ActivityTypeName'];
    activityCategoryId = json['ActivityCategoryID'];
    activityCategoryName = json['ActivityCategoryName'];
    brandId = json['BrandID'];
    brandName = json['BrandName'];
    activityDescription = json['ActivityDescription'];
    statusId = json['StatusID'];
    quantity = json['Quantity']?.toString();
    storeId = json['StoreID'];
    storeCode = json['StoreCode'];
    storeName = json['StoreName'];
    isEmailSent = json['IsEmailSent'];
    imageActivity = json['ImageActivity'];
    imageActivity2 = json['ImageActivity2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ActivityID'] = activityId;
    data['TeamMemberID'] = teamMemberId;
    data['mySingleID'] = mySingleId;
    data['TeamMemberName'] = teamMemberName;
    data['TeamTypeName'] = teamTypeName;
    data['ActivityDateTime'] = activityDateTime;
    data['ActivityTypeID'] = activityTypeId;
    data['CityName'] = cityName;
    data['CityID'] = cityId;
    data['RegionName'] = regionName;
    data['RegionID'] = regionId;
    data['ChannelName'] = channelName;
    data['ChannelID'] = channelId;
    data['ChannelTypeID'] = channelTypeId;
    data['ActivityTypeName'] = activityTypeName;
    data['ActivityCategoryID'] = activityCategoryId;
    data['ActivityCategoryName'] = activityCategoryName;
    data['BrandID'] = brandId;
    data['BrandName'] = brandName;
    data['ActivityDescription'] = activityDescription;
    data['StatusID'] = statusId;
    data['Quantity'] = quantity;
    data['StoreID'] = storeId;
    data['StoreCode'] = storeCode;
    data['StoreName'] = storeName;
    data['IsEmailSent'] = isEmailSent;
    data['ImageActivity'] = imageActivity;
    data['ImageActivity2'] = imageActivity2;
    return data;
  }
}
