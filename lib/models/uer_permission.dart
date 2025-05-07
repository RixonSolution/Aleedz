class UserPermission {
  List<Permission>? data;

  UserPermission({this.data});

  UserPermission.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null && json['data'] is List) {
      data =
          (json['data'] as List)
              .map((item) => Permission.fromJson(item))
              .toList();
    }
  }

  Map<String, dynamic> toJson() {
    return {'data': data?.map((e) => e.toJson()).toList()};
  }

  String getPermissionValue(String permissionName) {
    final permissionItem = data?.firstWhere(
      (item) => item.permissionName == permissionName,
      orElse: () => Permission(permission: "N"),
    );
    return permissionItem?.permission?.toString() ?? "N";
  }
}

class Permission {
  int? permissionID;
  String? permissionName;
  dynamic permission; // Can be String or Number

  Permission({this.permissionID, this.permissionName, this.permission});

  Permission.fromJson(Map<String, dynamic> json) {
    permissionID = json['PermissionID'];
    permissionName = json['PermissionName'];
    permission = json['Permission'];
  }

  Map<String, dynamic> toJson() {
    return {
      'PermissionID': permissionID,
      'PermissionName': permissionName,
      'Permission': permission,
    };
  }
}
