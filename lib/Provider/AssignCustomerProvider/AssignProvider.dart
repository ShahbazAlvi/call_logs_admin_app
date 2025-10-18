// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../model/UnAssignCustomerModel.dart';
//
//
// class UnassignCustomerProvider with ChangeNotifier {
//   List<CustomerData> _customers = [];
//   List<CustomerData> get customers => _filteredCustomers;
//   List<CustomerData> _filteredCustomers = [];
//   bool _isLoading = false;
//   bool get isLoading => _isLoading;
//   final List<String> _selectedIds = [];
//   List<String> get selectedIds => _selectedIds;
//
//
//
//
//
//   Future<void> fetchUnassignedCustomers() async {
//     _isLoading = true;
//     notifyListeners();
//
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token') ?? '';
//
//       final response = await http.get(
//         Uri.parse('https://call-logs-backend.onrender.com/api/customers/unassigned'),
//         headers: {'Authorization': 'Bearer $token'},
//       );
//
//       if (response.statusCode == 200) {
//         final data = UnassignCustomerModel.fromJson(json.decode(response.body));
//         _customers = data.data ?? [];
//         _filteredCustomers = _customers;
//       } else {
//         debugPrint('❌ Failed to fetch customers: ${response.body}');
//       }
//     } catch (e) {
//       debugPrint('⚠️ Error: $e');
//     } finally {
//       _isLoading = false;
//       notifyListeners();
//     }
//   }
//
//   void toggleSelection(String id) {
//     if (_selectedIds.contains(id)) {
//       _selectedIds.remove(id);
//     } else {
//       _selectedIds.add(id);
//     }
//     notifyListeners();
//   }
//
//   void searchCustomer(String query) {
//     if (query.isEmpty) {
//       _filteredCustomers = _customers;
//     } else {
//       _filteredCustomers = _customers
//           .where((c) => c.companyName!.toLowerCase().contains(query.toLowerCase()))
//           .toList();
//     }
//     notifyListeners();
//   }
//
//   // Example Assign function (You can modify API call)
//   Future<void> assignSelectedCustomers() async {
//     // API call to assign customers
//     debugPrint('✅ Assigned customers: $_selectedIds');
//     _selectedIds.clear();
//     notifyListeners();
//   }
//   Future<void> assignSelectedCustomers({
//     required String staffId,
//     required String productId,
//   }) async {
//     if (selectedIds.isEmpty) {
//       debugPrint("⚠️ No customers selected");
//       return;
//     }
//
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('token') ?? '';
//
//       final body = jsonEncode({
//         "customerIds": selectedIds,
//         "assignedStaff": staffId,
//         "assignedProducts": productId,
//       });
//
//       final response = await http.patch(
//         Uri.parse('https://call-logs-backend.onrender.com/api/customers/assign'),
//         headers: {
//           'Content-Type': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//         body: body,
//       );
//
//       if (response.statusCode == 200) {
//         debugPrint("✅ Assigned successfully: ${response.body}");
//         await fetchUnassignedCustomers();
//         _selectedIds.clear();
//       } else {
//         debugPrint("❌ Failed to assign: ${response.body}");
//       }
//     } catch (e) {
//       debugPrint("⚠️ Error assigning customers: $e");
//     }
//
//     notifyListeners();
//   }
//
//
// }
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/UnAssignCustomerModel.dart';

class UnassignCustomerProvider with ChangeNotifier {
  List<CustomerData> _customers = [];
  List<CustomerData> _filteredCustomers = [];
  bool _isLoading = false;
  final List<String> _selectedIds = [];

  List<CustomerData> get customers => _filteredCustomers;
  bool get isLoading => _isLoading;
  List<String> get selectedIds => _selectedIds;

  // Fetch unassigned customers
  Future<void> fetchUnassignedCustomers() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse('https://call-logs-backend.onrender.com/api/customers/unassigned'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = UnassignCustomerModel.fromJson(json.decode(response.body));
        _customers = data.data ?? [];
        _filteredCustomers = _customers;
      } else {
        debugPrint('❌ Failed to fetch customers: ${response.body}');
      }
    } catch (e) {
      debugPrint('⚠️ Error fetching unassigned customers: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleSelection(String id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
    } else {
      _selectedIds.add(id);
    }
    notifyListeners();
  }

  void searchCustomer(String query) {
    if (query.isEmpty) {
      _filteredCustomers = _customers;
    } else {
      _filteredCustomers = _customers
          .where((c) => (c.companyName ?? '').toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }

  // Assign selected customers to staff & product
  Future<void> assignSelectedCustomers({
    required String staffId,
    required String productId,
  }) async {
    if (selectedIds.isEmpty) {
      debugPrint("⚠️ No customers selected");
      return;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      final body = jsonEncode({
        "customerIds": selectedIds,
        "assignedStaff": staffId,
        "assignedProducts": productId,
      });

      final response = await http.patch(
        Uri.parse('https://call-logs-backend.onrender.com/api/customers/assign'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        debugPrint("✅ Assigned successfully: ${response.body}");
        await fetchUnassignedCustomers();
        _selectedIds.clear();
      } else {
        debugPrint("❌ Failed to assign: ${response.body}");
      }
    } catch (e) {
      debugPrint("⚠️ Error assigning customers: $e");
    }

    notifyListeners();
  }
}
