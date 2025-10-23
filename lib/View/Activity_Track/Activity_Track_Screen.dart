import 'package:flutter/material.dart';

import 'CustomersTrackScreen.dart';

class ActivityTrackScreen extends StatefulWidget {
  const ActivityTrackScreen({super.key});

  @override
  State<ActivityTrackScreen> createState() => _ActivityTrackScreenState();
}

class _ActivityTrackScreenState extends State<ActivityTrackScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(


        title: Center(child: Text( "Activity Tracker",
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
      body:SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8,16, 8,16),
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>CustomersTrackScreen()));
                  },
                    child: containerBuilder(icon: Icons.people, title:'Customers Track', details: 'Monitor Customer Create, Update and assignments')),
                SizedBox(height: 10,),
                GestureDetector(
                    onTap: (){},
                    child: containerBuilder(icon: Icons.handshake, title:'Meeting Track', details: 'Track meeting schedules and progress')),
                SizedBox(height: 10,),
                GestureDetector(
                    onTap: (){},
                    child: containerBuilder(icon: Icons.note_alt, title:'Follow Up Track', details: 'See recent follow-ups and status')),
                SizedBox(height: 10,),
                GestureDetector(
                    onTap: (){},
                    child: containerBuilder(icon: Icons.person, title:'Staff Track', details: 'Monitor staff activity and engagement'))
              ],
            ),
          ),
          
        ),
      ) ,
    );
  }
  Widget containerBuilder({
    required IconData icon,
    required String title,
    required String details,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40, color: Colors.black),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 4),
            Text(
              details,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

}
