import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../model/AllMeetingModel.dart';


class MeetingService {
  static const String baseUrl =
      'https://call-logs-backend.vercel.app/api/meetings';

  Future<ApiResponse> fetchMeetings(String token) async {
    final url = Uri.parse(baseUrl);

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return ApiResponse.fromJson(jsonData);
    } else {
      throw Exception('Failed to fetch meetings: ${response.body}');
    }
  }
}
