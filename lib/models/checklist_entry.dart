class ChecklistEntry {
  final String token;
  final dynamic checklistAuditID;
  final String checkListID;
  final String storeID;
  final String? checkListStatus;
  final String teamMemberID;
  final String visitID;
  final String? description;

  final String? imagePath;

  ChecklistEntry({
    required this.token,
    required this.checklistAuditID,
    required this.checkListID,
    required this.storeID,
    this.checkListStatus,
    required this.teamMemberID,
    required this.visitID,
    this.description,

    this.imagePath,
  });

  ChecklistEntry copyWith({
    String? token,
    dynamic checklistAuditID,
    String? checkListID,
    String? storeID,
    String? checkListStatus,
    String? teamMemberID,
    String? visitID,
    String? description,

    String? imagePath,
  }) {
    return ChecklistEntry(
      token: token ?? this.token,
      checklistAuditID: checklistAuditID ?? this.checklistAuditID,
      checkListID: checkListID ?? this.checkListID,
      storeID: storeID ?? this.storeID,
      checkListStatus: checkListStatus ?? this.checkListStatus,
      teamMemberID: teamMemberID ?? this.teamMemberID,
      visitID: visitID ?? this.visitID,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_token': token,
      'Checklist_Audit_ID': checklistAuditID,
      'CheckListID': checkListID,
      'StoreID': storeID,
      'CheckListStatus': checkListStatus,
      'TeamMemberID': teamMemberID,
      'VisitID': visitID,
      'Checklist_Description': description,
      'CheckList_Img': imagePath,
    };
  }
}
