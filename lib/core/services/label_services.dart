import 'dart:convert';
import 'package:aleedz/core/constants/api_constants.dart';
import 'package:aleedz/models/language_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LabelService {
  static final LabelService _instance = LabelService._internal();
  factory LabelService() => _instance;

  LabelService._internal();

  List<LabelModel> _labels = [];

  Future<void> loadLabels() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonList = prefs.getStringList('label_list');

    if (jsonList != null) {
      _labels =
          jsonList
              .map((jsonStr) => LabelModel.fromJson(json.decode(jsonStr)))
              .toList();
    }
  }

  Future<void> loadBaseUrl() async {
    final prefs = await SharedPreferences.getInstance();
    final savedUrl = prefs.getString('baseUrl');
    if (savedUrl != null && savedUrl.isNotEmpty) {
      ApiConstants.setBaseUrl(savedUrl);
    }
  }

  String getLabel(int id) {
    // Use firstWhere to find the label by id, if not found return a LabelModel with default values
    return _labels
        .firstWhere(
          (label) => label.id == id,
          orElse:
              () => LabelModel(
                id: id,
                label: 'Default Label',
              ), // Return a default LabelModel if not found
        )
        .label; // Access the label field of the LabelModel
  }
}
