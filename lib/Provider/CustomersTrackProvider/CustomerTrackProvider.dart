import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/CustomersTrackModel.dart';

class CustomersTrackProvider extends ChangeNotifier {
  bool isLoading = false;
  List<CustomerData> allCustomers = [];
  List<CustomerData> filteredCustomers = [];

  // Filters
  String? selectedStaffName;
  String? selectedProductName;
  String? selectedDateRange; // e.g. today, 1week, 14day, all
  String searchQuery = '';

  String? token;

  /// 🔹 Load token from SharedPreferences
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    debugPrint('🔑 Loaded token: $token');
  }

  /// 🔹 Fetch customers with optional filters
  Future<void> fetchCustomers({
    String? staff,
    String? product,
    String? date,
  }) async {
    try {
      isLoading = true;
      notifyListeners();

      if (token == null) {
        await _loadToken();
      }

      if (token == null || token!.isEmpty) {
        throw Exception('No token found in SharedPreferences');
      }

      String url =
          'https://call-logs-backend.onrender.com/api/history/customers-track';

      // Build dynamic query
      List<String> params = [];
      if (staff != null && staff.isNotEmpty) params.add('staff=$staff');
      if (product != null && product.isNotEmpty) params.add('product=$product');
      if (date != null && date.isNotEmpty && date != 'all') {
        params.add('date=$date');
      }
      if (params.isNotEmpty) url += '?${params.join('&')}';

      debugPrint('🌍 Fetching URL: $url');

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      debugPrint('📡 Status: ${response.statusCode}');
      debugPrint('📦 Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final model = CustomersTrackModel.fromJson(jsonData);
        allCustomers = model.data;
        filteredCustomers = model.data;
      } else {
        throw Exception('Failed: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error fetching customers: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 Apply local search filters
  void applyFilters() {
    filteredCustomers = allCustomers.where((c) {
      final matchesStaff =
          selectedStaffName == null || c.staff == selectedStaffName;
      final matchesProduct =
          selectedProductName == null || c.product == selectedProductName;
      final matchesSearch = c.company
          .toLowerCase()
          .contains(searchQuery.toLowerCase()) ||
          c.city.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesStaff && matchesProduct && matchesSearch;
    }).toList();
    notifyListeners();
  }

  void setSearch(String value) {
    searchQuery = value;
    applyFilters();
  }

  void setStaff(String? value) {
    selectedStaffName = value;
    fetchCustomers(
      staff: selectedStaffName,
      product: selectedProductName,
      date: selectedDateRange,
    );
  }

  void setProduct(String? value) {
    selectedProductName = value;
    fetchCustomers(
      staff: selectedStaffName,
      product: selectedProductName,
      date: selectedDateRange,
    );
  }

  void setDateRange(String? value) {
    selectedDateRange = value;
    fetchCustomers(
      staff: selectedStaffName,
      product: selectedProductName,
      date: selectedDateRange,
    );
  }
}
