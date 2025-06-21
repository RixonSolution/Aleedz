class DashboardModel {
  final int visitId;
  final int storeId;
  final int teamMemberId;
  final String planDate;
  final int day;
  final int month;
  final int year;
  final int weekNo;
  final String checkInTime;
  final String checkOutTime;
  final String address;
  final String visitRemarks;
  final String checkInRemarks;
  final String checkOutRemarks;
  final int visitStatusId;
  final String visitStatus;
  final String storeCode;
  final String storeName;
  final String longitude;
  final String latitude;
  final String storeTypeName;
  final String imageLocation;
  final int visitTypeId;
  final String gradeName;

  DashboardModel({
    required this.visitId,
    required this.storeId,
    required this.teamMemberId,
    required this.planDate,
    required this.day,
    required this.month,
    required this.year,
    required this.weekNo,
    required this.checkInTime,
    required this.checkOutTime,
    required this.address,
    required this.visitRemarks,
    required this.checkInRemarks,
    required this.checkOutRemarks,
    required this.visitStatusId,
    required this.visitStatus,
    required this.storeCode,
    required this.storeName,
    required this.longitude,
    required this.latitude,
    required this.storeTypeName,
    required this.imageLocation,
    required this.visitTypeId,
    required this.gradeName,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      visitId: json['VisitID'],
      storeId: json['StoreID'],
      teamMemberId: json['TeamMemberID'],
      planDate: json['PlanDate'],
      day: json['Day'],
      month: json['Month'],
      year: json['Year'],
      weekNo: json['WeekNo'],
      checkInTime: json['CheckInTime'],
      checkOutTime: json['CheckOutTime'],
      address: json['Address'],
      visitRemarks: json['VisitRemarks'],
      checkInRemarks: json['CheckInRemarks'],
      checkOutRemarks: json['CheckOutRemarks'],
      visitStatusId: json['VisitStatusID'],
      visitStatus: json['VisitStatus'],
      storeCode: json['StoreCode'],
      storeName: json['StoreName'],
      longitude: json['Longitude'],
      latitude: json['Latitude'],
      storeTypeName: json['StoreTypeName'],
      imageLocation: json['ImageLocation'],
      visitTypeId: json['VisitTypeID'],
      gradeName: json['GradeName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'VisitID': visitId,
      'StoreID': storeId,
      'TeamMemberID': teamMemberId,
      'PlanDate': planDate,
      'Day': day,
      'Month': month,
      'Year': year,
      'WeekNo': weekNo,
      'CheckInTime': checkInTime,
      'CheckOutTime': checkOutTime,
      'Address': address,
      'VisitRemarks': visitRemarks,
      'CheckInRemarks': checkInRemarks,
      'CheckOutRemarks': checkOutRemarks,
      'VisitStatusID': visitStatusId,
      'VisitStatus': visitStatus,
      'StoreCode': storeCode,
      'StoreName': storeName,
      'Longitude': longitude,
      'Latitude': latitude,
      'StoreTypeName': storeTypeName,
      'ImageLocation': imageLocation,
      'VisitTypeID': visitTypeId,
      'GradeName': gradeName,
    };
  }
}
