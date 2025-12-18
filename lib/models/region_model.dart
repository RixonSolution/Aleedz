class RegionModel {
  final int id;
  final String name;

  RegionModel({
    required this.id,
    required this.name,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      id: (json['RegionID'] as num?)?.toInt() ?? 0,
      name: (json['RegionName'] as String?)?.trim() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'RegionID': id,
      'RegionName': name,
    };
  }
}
