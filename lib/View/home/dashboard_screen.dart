
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  AnimatedDashboardCard(icon: Icons.person, title:'Customer', count:'23', bcolor:Colors.green),
                  AnimatedDashboardCard(icon: Icons.shop, title:'Products', count:'23', bcolor:Colors.red),
                  AnimatedDashboardCard(icon: Icons.people_rounded, title:'Staff', count:'23', bcolor:Colors.blue),
                  AnimatedDashboardCard(icon: Icons.person, title:'Transactions', count:'23', bcolor:Colors.orange)

                ],
              )

            ],
          ),
        ),
        
        
      ),
    );
  }
}
class AnimatedDashboardCard extends StatefulWidget {
  final IconData icon;
  final  String title;
  final String count;
  final Color bcolor;
  const AnimatedDashboardCard({super.key, required this.icon, required this.title, required this.count, required this.bcolor});

  @override
  State<AnimatedDashboardCard> createState() => _AnimatedDashboardCardState();
}

class _AnimatedDashboardCardState extends State<AnimatedDashboardCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 24,
      decoration: BoxDecoration(
        color:widget.bcolor,
          borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
       children: [
         Icon(widget.icon,size: 32,color: Colors.white,),
         const SizedBox(height: 10),
    Text(widget.title,style: TextStyle(color: Colors.white),),
         const SizedBox(height: 10),
    Text(widget.count,style: TextStyle(color: Colors.white),),

        ],
      ),
    );
  }
}

