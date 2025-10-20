import 'package:flutter/material.dart';
import 'package:infinity/compoents/AppButton.dart';
import 'package:infinity/compoents/AppTextfield.dart';
import 'package:provider/provider.dart';

import '../../Provider/SignUpProvider.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    final provider=Provider.of<SignUpProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [

              AppTextField(controller: provider.fullnameController, label: 'FullName', validator: (value) => value!.isEmpty ? 'Enter PassWord' : null,icon: Icons.person,),
              AppTextField(controller: provider.usernameController, label: 'UserName', validator: (value) => value!.isEmpty ? 'Enter PassWord' : null,icon: Icons.person,),
              AppTextField(controller: provider.emailController, label: 'Email', validator: (value) => value!.isEmpty ? 'Enter PassWord' : null,icon: Icons.email,),
              AppTextField(controller: provider.passwordController, label: "Password", validator: (value) => value!.isEmpty ? 'Enter PassWord' : null,icon: Icons.password,),
              AppTextField(controller: provider.cpasswordController, label: 'Confirm Password', validator: (value) => value!.isEmpty ? 'Enter PassWord' : null,icon: Icons.password,),
              AppButton(title:'SignUp', press: ()async{
                final result = await provider.signUp();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(provider.message)),
                );
                if (result['success']) {
                  Navigator.pop(context); // Navigate to login or home
                }
              }, width: double.infinity)
            ],
          ),
        ),
      ),
    );
  }
}
