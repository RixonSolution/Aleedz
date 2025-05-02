class ApiConstants {
  static const String baseUrl = "https://ffm.aleedz.com";
  static const String login = "${baseUrl}/WebService.asmx/ROSAppUserLogin";
  static const String requestPermission =
      "${baseUrl}/WebService.asmx/TeamMemberPermissions";
  static const String coverageCount =
      "${baseUrl}/WebService.asmx/MyCoverageStoresCount";

  static const String coverageList =
      "${baseUrl}/Storelist.asmx/TeamMemberStoreList";

  static const String coverageDropDown =
      "${baseUrl}/WebService.asmx/ChannelList";
}
