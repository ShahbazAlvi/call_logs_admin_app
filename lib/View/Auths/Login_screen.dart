import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:infinity/Provider/login_provider.dart';
import 'package:infinity/View/Auths/Sign_up.dart';
import 'package:infinity/compoents/AppButton.dart';
import 'package:infinity/compoents/AppTextfield.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final screenHeight=MediaQuery.of(context).size.height;
    final screenWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height:screenHeight*0.07),
              Text('Admin Login',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              Text("Login to continue"),
              SizedBox(height: screenHeight*0.02,),
              AppTextField(controller: loginProvider.emailController, label: 'Email',icon: Icons.email,
                validator: (value) => value!.isEmpty ? 'Enter Email' : null,),
              SizedBox(height: screenHeight*0.02,),
              AppTextField(controller: loginProvider.passwordController, label: 'password',icon: Icons.password,icons: Icons.visibility_off,
                validator: (value) => value!.isEmpty ? 'Enter PassWord' : null,),
              SizedBox(height: screenHeight*0.02,),
              loginProvider.isLoading?
                  Center(
                    child: CircularProgressIndicator(),
                  ):
              AppButton(title: 'Login', press: (){
                loginProvider.login(context);
              }, width: double.infinity),
              SizedBox(height: screenHeight * 0.02),
              if(loginProvider.message.isNotEmpty)
                Center(child: Text(loginProvider.message,style: TextStyle(color: Colors.red),),),
              RichText(text: TextSpan(
                text: "Don't have an account? ",
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: 'Sign up',
                    style: const TextStyle(
                      color: Colors.blue, // clickable text color
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // 👇 navigate to your sign-up screen
                        Navigator.pushReplacement(context,MaterialPageRoute(builder:(context)=>SignUp()));
                      },
                  ),
                ],
              ))

            ],
          ),
        ),
      ),
    );
  }
}
