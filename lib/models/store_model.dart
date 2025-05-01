class StoreModel {
  final int storeId;
  final String storeCode;
  final String storeTypeName;
  final String storeName;
  final int channelId;
  final String channelName;
  final String regionName;
  final String districtName;
  final String mallName;
  final String address;
  final String latitude;
  final String longitude;
  final String lastVisitedDate;
  final String visitedBy;
  final int channelTypeId;
  final String channelTypeName;
  final String isOtherLocation;
  final int visitStatusId;
  final String checkInTime;

  StoreModel({
    required this.storeId,
    required this.storeCode,
    required this.storeTypeName,
    required this.storeName,
    required this.channelId,
    required this.channelName,
    required this.regionName,
    required this.districtName,
    required this.mallName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.lastVisitedDate,
    required this.visitedBy,
    required this.channelTypeId,
    required this.channelTypeName,
    required this.isOtherLocation,
    required this.visitStatusId,
    required this.checkInTime,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json) {
    return StoreModel(
      storeId: json["StoreID"] ?? 0,
      storeCode: json["StoreCode"] ?? "",
      storeTypeName: json["StoreTypeName"] ?? "",
      storeName: json["StoreName"] ?? "",
      channelId: json["ChannelID"] ?? 0,
      channelName: json["ChannelName"] ?? "",
      regionName: json["RegionName"] ?? "",
      districtName: json["DistrcitName"] ?? "",
      mallName: json["MallName"] ?? "",
      address: json["Address"] ?? "",
      latitude: json["Latitude"] ?? "",
      longitude: json["Longitude"] ?? "",
      lastVisitedDate: json["LastVisitedDate"] ?? "",
      visitedBy: json["VistedBy"] ?? "",
      channelTypeId: json["ChannelTypeID"] ?? 0,
      channelTypeName: json["ChannelTypeName"] ?? "",
      isOtherLocation: json["isOtherLocation"] ?? "",
      visitStatusId: json["VisitStatusID"] ?? 0,
      checkInTime: json["CheckInTime"] ?? "",
    );
  }
}
