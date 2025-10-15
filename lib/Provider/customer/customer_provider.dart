import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/Customer_model.dart';

class CompanyProvider with ChangeNotifier {
  bool isLoading = false;
  String errorMessage = '';
  List<Datum> companies = [];
  String message='';
  File? companyLogo;
  String? selectedStaffId;
  String? selectedProductId;


  // inside CompanyProvider

  List<Map<String, TextEditingController>> personsList = [
    {
      'fullName': TextEditingController(),
      'designation': TextEditingController(),
      'department': TextEditingController(),
      'phoneNumber': TextEditingController(),
      'email': TextEditingController(),
    }
  ];

  void addPerson() {
    personsList.add({
      'fullName': TextEditingController(),
      'designation': TextEditingController(),
      'department': TextEditingController(),
      'phoneNumber': TextEditingController(),
      'email': TextEditingController(),
    });
    notifyListeners();
  }

  void removePerson(int index) {
    personsList.removeAt(index);
    notifyListeners();
  }

  // Company-level fields
  final businessTypeController = TextEditingController();
  final companyNameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final assignedStaffController = TextEditingController();
  final assignedProductsController = TextEditingController();

  final String baseUrl = 'https://call-logs-backend.vercel.app/api/customers';



  // Form controllers
  // 👈 change for your setup

  Future<void> fetchCompanies() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("❌ No token found for calendar meetings");
      return;
    }
    print('api call     ===================');
    try {


      isLoading = true;
      errorMessage = '';
      notifyListeners();

      final response = await http.get(Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },);

      if (response.statusCode == 200) {
        print('api call success    ===================');
        final data = json.decode(response.body);
        Welcome welcome = Welcome.fromJson(data);
        companies = welcome.data;
      } else {
        errorMessage = 'Server Error: ${response.statusCode}';
      }
    } catch (e) {
      errorMessage = 'Error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
  Future<void> deleteCompany(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print("❌ No token found for calendar meetings");
      return;
    }
    try {
      isLoading = true;
      notifyListeners();

      final response = await http.delete(
        Uri.parse('https://call-logs-backend.vercel.app/api/customers/$id'),
        headers: {
          'Authorization': 'Bearer $token', // add your token
        },
      );

      if (response.statusCode == 200) {
        companies.removeWhere((c) => c.id == id);
        notifyListeners();
      } else {
        errorMessage = 'Failed to delete company';
        notifyListeners();
      }
    } catch (e) {
      errorMessage = 'Error deleting company: $e';
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  final String apiUrl = 'https://call-logs-backend.vercel.app/api/customers';
  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      companyLogo = File(picked.path);
      notifyListeners();
    }
  }

  Future<void> createCustomer() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      message = "❌ No token found";
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      message = '';
      notifyListeners();

      final uri = Uri.parse(baseUrl);
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';

      // Basic company details
      request.fields['businessType'] = businessTypeController.text;
      request.fields['companyName'] = companyNameController.text;
      request.fields['address'] = addressController.text;
      request.fields['city'] = cityController.text;
      request.fields['email'] = emailController.text;
      request.fields['phoneNumber'] = phoneController.text;
      request.fields['assignedStaff'] = selectedStaffId ?? '';

      //request.fields['assignedStaff'] = assignedStaffController.text;
      //request.fields['assignedProducts'] = assignedProductsController.text;
      request.fields['assignedProducts'] = selectedProductId ?? '';


      // Add multiple persons dynamically
      for (int i = 0; i < personsList.length; i++) {
        final person = personsList[i];
        request.fields['persons[$i][fullName]'] =
            person['fullName']!.text.trim();
        request.fields['persons[$i][designation]'] =
            person['designation']!.text.trim();
        request.fields['persons[$i][department]'] =
            person['department']!.text.trim();
        request.fields['persons[$i][phoneNumber]'] =
            person['phoneNumber']!.text.trim();
        request.fields['persons[$i][email]'] =
            person['email']!.text.trim();
      }

      // Company logo
      if (companyLogo != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'companyLogo',
          companyLogo!.path,
        ));
      }

      final response = await request.send();
      final respStr = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        message = '✅ Customer created successfully';
      } else {
        message = '❌ Failed: ${response.statusCode}\n$respStr';
      }
    } catch (e) {
      message = 'Error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearForm() {
    businessTypeController.clear();
    companyNameController.clear();
    addressController.clear();
    cityController.clear();
    emailController.clear();
    phoneController.clear();
    //assignedStaffController.clear();
    selectedStaffId = null;
   // assignedProductsController.clear();
    selectedProductId = null;

    companyLogo = null;

    // clear all person fields
    for (var p in personsList) {
      for (var c in p.values) {
        c.clear();
      }
    }
    notifyListeners();
  }
}
