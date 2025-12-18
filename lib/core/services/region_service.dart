import 'dart:convert';

import 'package:aleedz/core/constants/api_constants.dart';
import 'package:aleedz/models/region_model.dart';
import 'package:http/http.dart' as http;

class RegionService {
  Future<List<RegionModel>> fetchRegions({
    required String token,
  }) async {
    final encodedToken = Uri.encodeComponent(token);
    final uri = Uri.parse('${ApiConstants.regionList}?_token=$encodedToken');

    final response = await http.get(
      uri,
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('RegionList failed (${response.statusCode}).');
    }

    final decoded = json.decode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw Exception('RegionList returned unexpected payload.');
    }

    final data = decoded['data'];
    final List<dynamic> rawList = data is List ? data : <dynamic>[];

    return rawList
        .map(
          (entry) => RegionModel.fromJson(
            entry as Map<String, dynamic>,
          ),
        )
        .where((region) => region.name.isNotEmpty)
        .toList();
  }
}
