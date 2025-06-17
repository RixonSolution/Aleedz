class ChecklistSubmitModel {
  int? checklistID;
  int? checklistCategoryID;
  int? inputTypeID;
  String? question;
  int? activeStatus;
  dynamic checkListID1;
  dynamic storeID;
  dynamic checkListAuditDate;
  dynamic checkListStatus;
  dynamic creationDateTime;
  dynamic teamMemberID;
  dynamic rate;
  dynamic visitID;
  dynamic checklistAuditID;
  dynamic checklistImage;

  ChecklistSubmitModel({
    this.checklistID,
    this.checklistCategoryID,
    this.inputTypeID,
    this.question,
    this.activeStatus,
    this.checkListID1,
    this.storeID,
    this.checkListAuditDate,
    this.checkListStatus,
    this.creationDateTime,
    this.teamMemberID,
    this.rate,
    this.visitID,
    this.checklistAuditID,
    this.checklistImage,
  });

  ChecklistSubmitModel.fromJson(Map<String, dynamic> json) {
    checklistID = json['ChecklistID'];
    checklistCategoryID = json['ChecklistCategoryID'];
    inputTypeID = json['InputTypeID'];
    question = json['Question'];
    activeStatus = json['ActiveStatus'];
    checkListID1 = json['CheckListID1'];
    storeID = json['StoreID'];
    checkListAuditDate = json['CheckListAuditDate'];
    checkListStatus = json['CheckListStatus'];
    creationDateTime = json['CreationDateTime'];
    teamMemberID = json['TeamMemberID'];
    rate = json['Rate'];
    visitID = json['VisitID'];
    checklistAuditID = json['Checklist_Audit_ID'];
    checklistImage = json['Checklist_Image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ChecklistID'] = this.checklistID;
    data['ChecklistCategoryID'] = this.checklistCategoryID;
    data['InputTypeID'] = this.inputTypeID;
    data['Question'] = this.question;
    data['ActiveStatus'] = this.activeStatus;
    data['CheckListID1'] = this.checkListID1;
    data['StoreID'] = this.storeID;
    data['CheckListAuditDate'] = this.checkListAuditDate;
    data['CheckListStatus'] = this.checkListStatus;
    data['CreationDateTime'] = this.creationDateTime;
    data['TeamMemberID'] = this.teamMemberID;
    data['Rate'] = this.rate;
    data['VisitID'] = this.visitID;
    data['Checklist_Audit_ID'] = this.checklistAuditID;
    data['Checklist_Image'] = this.checklistImage;
    return data;
  }
}
