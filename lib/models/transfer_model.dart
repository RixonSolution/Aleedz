class TransferModel {
  int? storeID;
  String? storeCode;
  String? storeTypeName;
  String? storeName;
  int? channelID;
  String? channelName;
  String? regionName;
  String? distrcitName;
  String? mallName;
  String? address;
  String? latitude;
  String? longitude;
  int? channelTypeID;
  String? channelTypeName;
  int? transferCount;

  TransferModel({
    this.storeID,
    this.storeCode,
    this.storeTypeName,
    this.storeName,
    this.channelID,
    this.channelName,
    this.regionName,
    this.distrcitName,
    this.mallName,
    this.address,
    this.latitude,
    this.longitude,
    this.channelTypeID,
    this.channelTypeName,
    this.transferCount,
  });

  TransferModel.fromJson(Map<String, dynamic> json) {
    storeID = json['StoreID'];
    storeCode = json['StoreCode'];
    storeTypeName = json['StoreTypeName'];
    storeName = json['StoreName'];
    channelID = json['ChannelID'];
    channelName = json['ChannelName'];
    regionName = json['RegionName'];
    distrcitName = json['DistrcitName'];
    mallName = json['MallName'];
    address = json['Address'];
    latitude = json['Latitude'];
    longitude = json['Longitude'];
    channelTypeID = json['ChannelTypeID'];
    channelTypeName = json['ChannelTypeName'];
    transferCount = json['Transfer_Count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['StoreID'] = this.storeID;
    data['StoreCode'] = this.storeCode;
    data['StoreTypeName'] = this.storeTypeName;
    data['StoreName'] = this.storeName;
    data['ChannelID'] = this.channelID;
    data['ChannelName'] = this.channelName;
    data['RegionName'] = this.regionName;
    data['DistrcitName'] = this.distrcitName;
    data['MallName'] = this.mallName;
    data['Address'] = this.address;
    data['Latitude'] = this.latitude;
    data['Longitude'] = this.longitude;
    data['ChannelTypeID'] = this.channelTypeID;
    data['ChannelTypeName'] = this.channelTypeName;
    data['Transfer_Count'] = this.transferCount;
    return data;
  }
}
