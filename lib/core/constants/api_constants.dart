class ApiConstants {
  static String? _baseUrl;

  static void setBaseUrl(String url) {
    _baseUrl = url;
  }

  static String get baseUrl => _baseUrl ?? "https://ffm.aleedz.com";

  static String get login => "$baseUrl/WebService.asmx/ROSAppUserLogin";
  static String get language => "$baseUrl/WebService.asmx/AppSettings";
  static String get requestPermission =>
      "$baseUrl/WebService.asmx/TeamMemberPermissions";
  static String get coverageCount =>
      "$baseUrl/WebService.asmx/MyCoverageStoresCount";

  static String get coverageList =>
      "$baseUrl/Storelist.asmx/TeamMemberStoreList";
  static String get coverageDropDown => "$baseUrl/WebService.asmx/ChannelList";

  static String get brandDropDown =>
      "$baseUrl/WebService.asmx/BrandList_General";
  static String get checkIn =>
      "$baseUrl/StoreVisit.asmx/TeamMemberCheckInDirect";
  static String get dashboardCheckIn => "$baseUrl/CheckIn.asmx/CheckInImg";
  static String get checkOut => "$baseUrl/CheckOut.asmx/CheckOutImg";
  static String get displayCheckSummary =>
      "$baseUrl/DisplayCount.asmx/DisplayCheckSummary";

  static String get checkAudit =>
      "$baseUrl/DisplayCount.asmx/DisplayCheckProductListByStore";
  static String get checkDisplayAdd =>
      "$baseUrl/DisplayCount.asmx/DisplayCheckAdd";
  static String get cancelVisite => "$baseUrl/JourneyPlan.asmx/CancelVisit";
  static String get checkDisplayAddMedia =>
      "$baseUrl/DisplayCount.asmx/DisplayCheckMasterAdd";
  static String get pictureDropDown =>
      "$baseUrl/WebService.asmx/StorePicture_GeneralElement";
  static String get issueCategoryDropDown =>
      "$baseUrl/WebService.asmx/IssueCategoryList_General";
  static String get submitDisplayPicture =>
      "$baseUrl/WebService.asmx/GeneralPictureAdd";
  static String get pictureApiView =>
      "$baseUrl/WebService.asmx/GeneralPictureView";
  static String get deleteDisplayPicture =>
      "$baseUrl/WebService.asmx/RemoveGeneralPicture";
  static String get checkMasterDisplay =>
      "$baseUrl/DisplayCount.asmx/DisplayCheckMasterView";
  static String get dashboardApi => "$baseUrl/JourneyPlan.asmx/TeamJourneyPlan";
  static String get activityTypeList =>
      "$baseUrl/Activity.asmx/ActivityTypeList";
  static String get activityCategoryId =>
      "$baseUrl/Activity.asmx/ActivityCategoryList";

  static String get removeActivity => "$baseUrl/Activity.asmx/RemoveActivity";

  static String get activityList =>
      "$baseUrl/OperMarketActivities.asmx/ViewMarketActivityList";

  static String get merketActivitySubmit =>
      "$baseUrl/OperMarketActivities.asmx/MarketActivityAdd";

  static String get transferView =>
      "$baseUrl/ProductTransfer.asmx/TeamMember_Transfer_StoreList";

  static String get transferBrandView =>
      "$baseUrl/ProductTransfer.asmx/TransferProductCategoryListByStore";

  static String get trasferSubmitList =>
      "$baseUrl/ProductTransfer.asmx/TransferProductListByStore";

  static String get getSaleProductCategory =>
      "$baseUrl/DailySales.asmx/ProductCategoryList";

  static String get getModelSearch => "$baseUrl/DailySales.asmx/ProductList";

  static String get addSale => "$baseUrl/DailySales.asmx/AddSale";
  static String get viewSale => "$baseUrl/DailySales.asmx/SaleView";

  static String get removeSale => "$baseUrl/DailySales.asmx/RemoveSale";

  static String get pricePromotion => "$baseUrl/Prices.asmx/ProductSummaryList";
  static String get priceList => "$baseUrl/Prices.asmx/ProductList";
  static String get checklist => "$baseUrl/Checklist.asmx/GetChecklistCategory";
  static String get checkListSubmitView =>
      "$baseUrl/Checklist.asmx/ViewChecklist";

  static String get priceSubmit => "$baseUrl/Prices.asmx/PricePromotionAdd";

  static String get checklistSubmit => "$baseUrl/Checklist.asmx/ChecklistAdd";

  static String get getVisiteId => "$baseUrl/WebService.asmx/GetVisitID";

  static String get addProductTrasfer =>
      "$baseUrl/ProductTransfer.asmx/TransferAdd";

  static String get trainingList => "$baseUrl/Trainings.asmx/TrainingList";

  static String get promoterList =>
      "$baseUrl/Trainings.asmx/TrainingPromoterList";

  static String get trainingModel =>
      "$baseUrl/Trainings.asmx/TrainingModelsList";

  static String get trainingSubmit => "$baseUrl/Trainings.asmx/TrainingAdd";

  static String get trainingType => "$baseUrl/Trainings.asmx/TrainingType";

  static String get pendingDeployment =>
      "$baseUrl/Deployments.asmx/PendingDeployment";

  static String get brandStoreShare =>
      "$baseUrl/StoreShare.asmx/StoreShareView_ByBrand";

  static String get categoryStoreShare =>
      "$baseUrl/StoreShare.asmx/StoreShareView_ByCategory";

  static String get productStoreShare =>
      "$baseUrl/StoreShare.asmx/StoreShareView_ByProduct";

  static String get openIssues =>
      "$baseUrl/OperMarketActivities.asmx/openIssues";

  static String get openIssueCount =>
      "$baseUrl/WebService.asmx/GetOpenIssuesCount";
}
