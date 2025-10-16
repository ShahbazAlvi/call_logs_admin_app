import 'package:flutter/material.dart';
import 'package:infinity/Provider/login_provider.dart';
import 'package:infinity/View/Auths/Login_screen.dart';
import 'package:infinity/View/home/dashboard_screen.dart';
import 'package:provider/provider.dart';

import 'Provider/FollowUp/FollowupProvider.dart';
import 'Provider/MeetingProvider/AllMeetingProvider.dart';
import 'Provider/MeetingProvider/Meeting_provider.dart';
import 'Provider/customer/customer_provider.dart';
import 'Provider/dashboard_provider.dart';
import 'Provider/product/product_provider.dart';
import 'Provider/staff/StaffProvider.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_)=>ProductProvider()),
      ChangeNotifierProvider(create: (_)=>LoginProvider()),
      ChangeNotifierProvider(create: (_)=>DashBoardProvider()),
      ChangeNotifierProvider(create: (_) => StaffProvider()),
      ChangeNotifierProvider(create: (_) => CompanyProvider()),
      ChangeNotifierProvider(create: (_) => MeetingProvider()),
      ChangeNotifierProvider(create: (_) => AllMeetingProvider()),
      ChangeNotifierProvider(create: (_) => FollowUpProvider()),
    ],
    child: MyApp(),)
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: LoginScreen()
    );
  }
}

