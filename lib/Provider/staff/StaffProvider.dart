import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart'as http;
import 'package:image_picker/image_picker.dart';
import 'package:infinity/model/staffModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaffProvider with ChangeNotifier{
  bool isLoading =false;
  List<Data> staffs = [];
  String message = '';
  File? selectedImage;

  final picker = ImagePicker();

  // ✅ Pick image from gallery
  Future<void> pickImage() async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedImage = File(picked.path);
      notifyListeners();
    }
  }

  Future<void>fetchStaff()async{
    const url='https://call-logs-backend.vercel.app/api/staff';
    isLoading=true;
    notifyListeners();
    try{
      final response= await http.get(Uri.parse(url));
      if(response.statusCode==200){
        final JsonResponse=jsonDecode(response.body);
        final staffModel=StaffModel.fromJson(JsonResponse);
        staffs=staffModel.data??[];
        if (kDebugMode) {
          print("✅ Loaded ${staffs.length} products");
        }
      } else {
        if (kDebugMode) {
          print("❌ Failed to load products: ${response.statusCode}");
        }
      }

    }catch(e){
      if (kDebugMode) {
        print("⚠️ Error fetching products: $e");
      }
    }
    isLoading = false;
    notifyListeners();

  }
  
  
  // delete the staff form list 
Future<void>DeleteStaff(String staffId)async{
    final prefs=await SharedPreferences.getInstance();
    final token=prefs.getString('token');
    if(token==null){
      print("❌ No token found for delete staff");
      return;
    }
    isLoading=true;
    notifyListeners();
    try{

    final response=await http.delete(Uri.parse('https://call-logs-backend.vercel.app/api/staff/$staffId'),
      headers: {
        'Authorization': "Bearer $token",
        'Accept': "application/json",
      },);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      fetchStaff();
      print('✅ staff deleted successfully: $data');
    } else {
      print('❌ Failed to delete staff. Status: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
} catch (e) {
  print('⚠️ Error deleting staff: $e');
  }
  isLoading = false;
  notifyListeners();
}




  Future<void> uploadStaff({
    required String username,
    required String email,
    required String department,
    required String designation,
    required String address,
    required String number,
    required String password,
    required String role,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      isLoading = true;
      message = '';
      notifyListeners();

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://call-logs-backend.vercel.app/api/staff'), // your local API
      );

      // Authorization token
      request.headers['Authorization'] = 'Bearer $token';

      // Form fields
      request.fields.addAll({
        'username': username,
        'email': email,
        'department': department,
        'designation': designation,
        'address': address,
        'number': number,
        'password': password,
        'role': role,
      });

      // Attach image if selected
      if (selectedImage != null) {
        request.files.add(await http.MultipartFile.fromPath('image', selectedImage!.path));
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      var jsonData = json.decode(responseBody);

      if (response.statusCode == 201) {
        message = jsonData['message'] ?? 'Staff added successfully';
      } else {
        message = jsonData['message'] ?? 'Failed to add staff';
      }
    } catch (e) {
      message = 'Error: $e';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

}