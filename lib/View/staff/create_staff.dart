import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/staff/StaffProvider.dart';

class StaffCreateScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final deptController = TextEditingController();
  final desigController = TextEditingController();
  final addressController = TextEditingController();
  final numberController = TextEditingController();
  final passwordController = TextEditingController();
  final roleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final staffProvider = Provider.of<StaffProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Staff')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: usernameController, decoration: const InputDecoration(labelText: 'Username')),
              TextFormField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
              TextFormField(controller: deptController, decoration: const InputDecoration(labelText: 'Department')),
              TextFormField(controller: desigController, decoration: const InputDecoration(labelText: 'Designation')),
              TextFormField(controller: addressController, decoration: const InputDecoration(labelText: 'Address')),
              TextFormField(controller: numberController, decoration: const InputDecoration(labelText: 'Number')),
              TextFormField(controller: passwordController, decoration: const InputDecoration(labelText: 'Password')),
              TextFormField(controller: roleController, decoration: const InputDecoration(labelText: 'Role')),

              const SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  await staffProvider.pickImage();
                },
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: staffProvider.selectedImage == null
                      ? const Center(child: Text('Tap to pick image from gallery'))
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      staffProvider.selectedImage!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              staffProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await staffProvider.uploadStaff(
                      username: usernameController.text,
                      email: emailController.text,
                      department: deptController.text,
                      designation: desigController.text,
                      address: addressController.text,
                      number: numberController.text,
                      password: passwordController.text,
                      role: roleController.text,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(staffProvider.message)),
                    );
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
