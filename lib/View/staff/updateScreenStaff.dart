import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
        title: const Text("Edit Staff"),
        backgroundColor: Colors.indigo,
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
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Name"),
                validator: (v) => v!.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (v) => v!.isEmpty ? 'Enter email' : null,
              ),
              TextFormField(
                controller: _numberController,
                decoration: const InputDecoration(labelText: "Number"),
                validator: (v) => v!.isEmpty ? 'Enter number' : null,
              ),
              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(labelText: "Department"),
                validator: (v) => v!.isEmpty ? 'Enter department' : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Address"),
                validator: (v) => v!.isEmpty ? 'Enter address' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  "Update Staff",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
