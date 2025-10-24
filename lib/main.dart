import 'package:flutter/material.dart';
import 'package:infinity/Provider/CustomersTrackProvider/FollowUpTrackProvider.dart';
import 'package:infinity/Provider/CustomersTrackProvider/StaffTrackProvider.dart';
import 'package:infinity/Provider/login_provider.dart';
import 'package:infinity/View/Auths/Login_screen.dart';
import 'package:infinity/View/home/dashboard_screen.dart';
import 'package:provider/provider.dart';

import 'Provider/AssignCustomerProvider/AssignProvider.dart';
import 'Provider/CustomersTrackProvider/CustomerTrackProvider.dart';
import 'Provider/CustomersTrackProvider/MeetingTrackProvider.dart';
import 'Provider/FollowUp/FollowupProvider.dart';
import 'Provider/MeetingProvider/NoDateMeetingProvider.dart';
import 'Provider/MeetingProvider/Meeting_provider.dart';
import 'Provider/SignUpProvider.dart';
import 'Provider/callLogsProvider/callLogsProvider.dart';
import 'Provider/customer/customer_provider.dart';
import 'Provider/dashboard_provider.dart';
import 'Provider/product/product_provider.dart';
import 'Provider/staff/StaffProvider.dart';
import 'View/splashScreen.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_)=>ProductProvider()),
      ChangeNotifierProvider(create: (_)=>LoginProvider()),
      ChangeNotifierProvider(create: (_)=>DashBoardProvider()),
      ChangeNotifierProvider(create: (_) => StaffProvider()),
      ChangeNotifierProvider(create: (_) => CompanyProvider()),
      ChangeNotifierProvider(create: (_) => MeetingProvider()),
      ChangeNotifierProvider(create: (_) => NoDateMeetingProvider()),
      ChangeNotifierProvider(create: (_) => FollowUpProvider()),
      ChangeNotifierProvider(create: (_) => UnassignCustomerProvider()),
      ChangeNotifierProvider(create: (_) => CallLogsProvider()),
      ChangeNotifierProvider(create: (_) => SignUpProvider()),
      ChangeNotifierProvider(create: (_) => CustomersTrackProvider()),
      ChangeNotifierProvider(create: (_) => MeetingTrackProvider()),
      ChangeNotifierProvider(create: (_) => FollowUpTrackProvider()),
      ChangeNotifierProvider(create: (_) => StaffTrackProvider()),

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

        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF5B86E5),),
      ),
      home: Splashscreen()
    );
  }
}

