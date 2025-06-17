class ChecklistEntry {
  final String token;
  final dynamic checklistAuditID;
  final String checkListID;
  final String storeID;
  final String? checkListStatus;
  final String teamMemberID;
  final String visitID;
  String? imagePath;

  ChecklistEntry({
    required this.token,
    required this.checklistAuditID,
    required this.checkListID,
    required this.storeID,
    this.checkListStatus,
    required this.teamMemberID,
    required this.visitID,
    this.imagePath,
  });

  // Optional: toJson for sending to API
  Map<String, dynamic> toJson() {
    return {
      '_token': token,
      'Checklist_Audit_ID': checklistAuditID,
      'CheckListID': checkListID,
      'StoreID': storeID,
      'CheckListStatus': checkListStatus,
      'TeamMemberID': teamMemberID,
      'VisitID': visitID,
      'CheckList_Img': imagePath,
    };
  }
}
