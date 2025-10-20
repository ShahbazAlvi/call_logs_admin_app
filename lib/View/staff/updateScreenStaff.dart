import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinity/compoents/AppButton.dart';
import 'package:infinity/compoents/AppTextfield.dart';
import 'package:provider/provider.dart';
import 'package:infinity/model/staffModel.dart';
import 'package:infinity/Provider/staff/StaffProvider.dart';

class EditStaffScreen extends StatefulWidget {
  final Data staff;
  const EditStaffScreen({super.key, required this.staff});

  @override
  State<EditStaffScreen> createState() => _EditStaffScreenState();
}

class _EditStaffScreenState extends State<EditStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final picker = ImagePicker();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _numberController;
  late TextEditingController _departmentController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.staff.username ?? '');
    _emailController = TextEditingController(text: widget.staff.email ?? '');
    _numberController = TextEditingController(text: widget.staff.number ?? '');
    _departmentController =
        TextEditingController(text: widget.staff.department ?? '');
    _addressController = TextEditingController(text: widget.staff.address ?? '');
  }

  Future<void> pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StaffProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Edit Staff',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
              letterSpacing: 1.2,
            )),
        ),
        centerTitle: true,
        elevation: 6,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF5B86E5), Color(0xFF36D1DC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : NetworkImage(widget.staff.image?.url ?? '') as ImageProvider,
                  child: const Align(
                    alignment: Alignment.bottomRight,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.indigo,
                      child: Icon(Icons.edit, size: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AppTextField(controller:_nameController, label:"Name",validator: (v) => v!.isEmpty ? 'Enter name' : null,),
              const SizedBox(height: 10),
              AppTextField(controller: _emailController, label:"Email", validator: (v) => v!.isEmpty ? 'Enter email' : null,),
              const SizedBox(height: 10),
              AppTextField(controller:_numberController, label: "Number", validator: (v) => v!.isEmpty ? 'Enter number' : null,),
              const SizedBox(height: 10),
              AppTextField(controller: _departmentController, label: "Department",validator: (v) => v!.isEmpty ? 'Enter department' : null,),
              const SizedBox(height: 10),
              AppTextField(controller: _addressController,label: "Address",validator: (v) => v!.isEmpty ? 'Enter address' : null,),

              const SizedBox(height: 20),
              AppButton(title: "Update Staff", press: ()async{
                if (_formKey.currentState!.validate()) {
                  await provider.updateStaff(
                    id: widget.staff.sId!,
                    username: _nameController.text,
                    email: _emailController.text,
                    number: _numberController.text,
                    department: _departmentController.text,
                    address: _addressController.text,
                    image: _image,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Staff updated successfully!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
                  width: double.infinity),
            ],
          ),
        ),
      ),
    );
  }
}
