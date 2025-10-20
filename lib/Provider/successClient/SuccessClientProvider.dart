import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/SuccessClient.dart';



class SuccessClientService {
  Future<SuccessClientModel?> fetchSuccessClients() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("❌ No token found in SharedPreferences!");
      return null;
    }

    final url = Uri.parse('https://call-logs-backend.onrender.com/api/meetings/success-client');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("📡 API Response Code: ${response.statusCode}");
      print("📦 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return SuccessClientModel.fromJson(jsonData);
      } else {
        print("⚠️ Failed to fetch success clients: ${response.reasonPhrase}");
        return null;
      }
    } catch (e) {
      print("❌ Error: $e");
      return null;
    }
  }
  Future<bool> deleteClient(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("❌ No token found!");
      return false;
    }

    final url = Uri.parse('https://call-logs-backend.onrender.com/api/meetings/$id');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print("🗑️ Delete response: ${response.statusCode} -> ${response.body}");

      if (response.statusCode == 200) {
        return true;
      } else {
        print("⚠️ Failed to delete: ${response.reasonPhrase}");
        return false;
      }
    } catch (e) {
      print("❌ Error deleting client: $e");
      return false;
    }
  }
}
