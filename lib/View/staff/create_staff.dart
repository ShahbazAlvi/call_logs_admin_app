import 'package:flutter/material.dart';
import 'package:infinity/compoents/AppButton.dart';
import 'package:infinity/compoents/AppTextfield.dart';
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
      appBar: AppBar(
        title: Center(child: const Text('Add Staff',
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
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                AppTextField(controller: usernameController, label:'Username',validator: (value) => value!.isEmpty ? 'Enter Username' : null,),
                const SizedBox(height: 10),
                AppTextField(controller: emailController, label: 'Email', validator: (value) => value!.isEmpty ? 'Enter Email' : null,),
                const SizedBox(height: 10),
                AppTextField(controller: deptController, label: 'Department', validator: (value) => value!.isEmpty ? 'Enter Department' : null,),
                const SizedBox(height: 10),
                AppTextField(controller: desigController, label: 'Designation', validator: (value) => value!.isEmpty ? 'Enter Designation' : null,),
                const SizedBox(height: 10),
                AppTextField(controller: addressController, label: 'Address', validator: (value) => value!.isEmpty ? 'Enter Address' : null,),
                const SizedBox(height: 10),
                AppTextField(controller: numberController, label:'Number', validator: (value) => value!.isEmpty ? 'Enter Number' : null,),
                const SizedBox(height: 10),
                AppTextField(controller: passwordController, label: 'Password', validator: (value) => value!.isEmpty ? 'Enter Password' : null,),
                const SizedBox(height: 10),
                AppTextField(controller: roleController, label: 'Role', validator: (value) => value!.isEmpty ? 'Enter Role' : null,),

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
                    : AppButton(title: 'Submit', press: ()async {
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
                    width: double.infinity)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
