class TargetAchievementModel {
  final String teamMemberName;
  final int month;
  final int year;
  final String brandName;
  final double target;
  final double achieved;
  final String targetDescription;
  final int brandId;
  final int teamMemberId;

  TargetAchievementModel({
    required this.teamMemberName,
    required this.month,
    required this.year,
    required this.brandName,
    required this.target,
    required this.achieved,
    required this.targetDescription,
    required this.brandId,
    required this.teamMemberId,
  });

  factory TargetAchievementModel.fromJson(Map<String, dynamic> json) {
    return TargetAchievementModel(
      teamMemberName: (json['TeamMemberName'] ?? '').toString(),
      month: json['Month'] is int
          ? json['Month']
          : int.tryParse(json['Month'].toString()) ?? 0,
      year: json['Year'] is int
          ? json['Year']
          : int.tryParse(json['Year'].toString()) ?? 0,
      brandName: (json['BrandName'] ?? '').toString(),
      target: (json['Target'] is num)
          ? (json['Target'] as num).toDouble()
          : double.tryParse(json['Target'].toString()) ?? 0.0,
      achieved: (json['Achieved'] is num)
          ? (json['Achieved'] as num).toDouble()
          : double.tryParse(json['Achieved'].toString()) ?? 0.0,
      targetDescription: (json['TagetDescription'] ?? json['TargetDescription'] ?? '')
          .toString(),
      brandId: json['BrandID'] is int
          ? json['BrandID']
          : int.tryParse(json['BrandID'].toString()) ?? 0,
      teamMemberId: json['TeamMemberID'] is int
          ? json['TeamMemberID']
          : int.tryParse(json['TeamMemberID'].toString()) ?? 0,
    );
  }

  double get percentage {
    if (target <= 0) return 0;
    return (achieved / target) * 100;
  }
}
