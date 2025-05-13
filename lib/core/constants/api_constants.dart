class ApiConstants {
  static const String baseUrl = "https://ffm.aleedz.com";
  static const String login = "${baseUrl}/WebService.asmx/ROSAppUserLogin";
  static const String language = "${baseUrl}/WebService.asmx/AppSettings";

  static const String requestPermission =
      "${baseUrl}/WebService.asmx/TeamMemberPermissions";
  static const String coverageCount =
      "${baseUrl}/WebService.asmx/MyCoverageStoresCount";

  static const String coverageList =
      "${baseUrl}/Storelist.asmx/TeamMemberStoreList";

  static const String coverageDropDown =
      "${baseUrl}/WebService.asmx/ChannelList";

  static const String brandDropDown =
      "${baseUrl}/WebService.asmx/BrandList_General";

  static const String checkIn =
      "${baseUrl}/StoreVisit.asmx/TeamMemberCheckInDirect";

  static const String checkOut = "${baseUrl}/CheckOut.asmx/CheckOutImg";

  static const String displayCheckSummary =
      "${baseUrl}/DisplayCount.asmx/DisplayCheckSummary";

  static const String checkAudit =
      "${baseUrl}/DisplayCount.asmx/DisplayCheckProductListByStore";

  static const String checkDisplayAdd =
      "${baseUrl}/DisplayCount.asmx/DisplayCheckAdd";

  static const String cancelVisite = "${baseUrl}/JourneyPlan.asmx/CancelVisit";

  static const String checkDisplayAddMedia =
      "${baseUrl}/DisplayCount.asmx/DisplayCheckMasterAdd";

  static const String pictureDropDown =
      "${baseUrl}/WebService.asmx/StorePicture_GeneralElement";

  static const String submitDisplayPicture =
      "${baseUrl}/WebService.asmx/GeneralPictureAdd";

  static const String pictureApiView =
      "${baseUrl}/WebService.asmx/GeneralPictureView";

  static const String deleteDisplayPicture =
      "${baseUrl}/WebService.asmx/RemoveGeneralPicture";

  static const String checkMasterDisplay =
      "${baseUrl}/DisplayCount.asmx/DisplayCheckMasterView";
}
