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
    return ChangeNotifierProvider(
      create: (_) => SignUpProvider(),
      builder: (context, _) {
        final provider = Provider.of<SignUpProvider>(context);

        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    "Call Logs SignUp",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    controller: provider.fullnameController,
                    label: 'Full Name',
                    validator: (value) =>
                    value!.isEmpty ? 'Enter your name' : null,
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    controller: provider.usernameController,
                    label: 'User Name',
                    validator: (value) =>
                    value!.isEmpty ? 'Enter username' : null,
                    icon: Icons.person,
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    controller: provider.emailController,
                    label: 'Email',
                    validator: (value) =>
                    value!.isEmpty ? 'Enter email' : null,
                    icon: Icons.email,
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    controller: provider.passwordController,
                    label: "Password",
                    validator: (value) =>
                    value!.isEmpty ? 'Enter password' : null,
                    icon: Icons.password,
                  ),
                  const SizedBox(height: 10),
                  AppTextField(
                    controller: provider.cpasswordController,
                    label: 'Confirm Password',
                    validator: (value) =>
                    value!.isEmpty ? 'Enter confirm password' : null,
                    icon: Icons.password,
                  ),
                  const SizedBox(height: 20),
                  AppButton(
                    title: provider.isLoading ? 'Loading...' : 'Sign Up',
                    press: () async {
                      final result = await provider.signUp(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(provider.message)),
                      );
                    },
                    width: double.infinity,
                  )

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

