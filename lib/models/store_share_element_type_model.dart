class StoreShareElementTypeModel {
  int? storeShareElementTypeId;
  int? storeShareElementId;
  String? storeShareElementTypeName;
  String? storeShareElementName;
  String? lastUpdate;
  int? quantity;

  StoreShareElementTypeModel({
    this.storeShareElementTypeId,
    this.storeShareElementId,
    this.storeShareElementTypeName,
    this.storeShareElementName,
    this.lastUpdate,
    this.quantity,
  });

  StoreShareElementTypeModel.fromJson(Map<String, dynamic> json) {
    storeShareElementTypeId =
        int.tryParse(json['StoreShare_ElementTypeID']?.toString() ?? '');
    storeShareElementId =
        int.tryParse(
          (json['StoreShare_ElementID'] ?? json['StoreShareElementID'])
                  ?.toString() ??
              '',
        );
    storeShareElementTypeName = json['StoreShare_ElementTypeName'];
    storeShareElementName = json['StoreShare_ElementName'];
    lastUpdate = json['LastUpdate'];
    quantity = int.tryParse(json['Quantity']?.toString() ?? '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['StoreShare_ElementTypeID'] = storeShareElementTypeId;
    data['StoreShare_ElementID'] = storeShareElementId;
    data['StoreShare_ElementTypeName'] = storeShareElementTypeName;
    data['StoreShare_ElementName'] = storeShareElementName;
    data['LastUpdate'] = lastUpdate;
    data['Quantity'] = quantity;
    return data;
  }
}
