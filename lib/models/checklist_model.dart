class ChecklistModel {
  int? checklistCategoryID;
  String? checklist;

  ChecklistModel({this.checklistCategoryID, this.checklist});

  ChecklistModel.fromJson(Map<String, dynamic> json) {
    checklistCategoryID = json['ChecklistCategoryID'];
    checklist = json['Checklist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ChecklistCategoryID'] = this.checklistCategoryID;
    data['Checklist'] = this.checklist;
    return data;
  }
}
