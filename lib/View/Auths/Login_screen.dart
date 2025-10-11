import 'package:flutter/material.dart';
import 'package:infinity/compoents/AppButton.dart';
import 'package:infinity/compoents/AppTextfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController=TextEditingController();
  TextEditingController passwordController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    final screenHeight=MediaQuery.of(context).size.height;
    final screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Admin Login',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              Text("Login to continue"),
              SizedBox(height: screenHeight*0.02,),
              AppTextField(controller: emailController, label: 'Email',icon: Icons.email,),
              SizedBox(height: screenHeight*0.02,),
              AppTextField(controller: passwordController, label: 'password',icon: Icons.password,icons: Icons.visibility_off,),
              SizedBox(height: screenHeight*0.02,),
              AppButton(title: 'Login', press: (){}, width: double.infinity)
            ],
          ),
        ),
      ),
    );
  }
}
