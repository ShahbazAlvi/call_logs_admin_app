import 'package:flutter/material.dart';

import '../Customer/customer_list.dart';
import '../home/dashboard_screen.dart';
import '../products/product_screen.dart';
import '../staff/staffListScreen.dart';

class BottombarScreen extends StatefulWidget {
  const BottombarScreen({super.key});

  @override
  State<BottombarScreen> createState() => _BottombarScreenState();
}

class _BottombarScreenState extends State<BottombarScreen> {
  int _selectedIndex = 0;

  // Example pages for each tab
  final List<Widget> _screens = [
    DashboardScreen(),
    ProductScreen(),
    StaffScreen(),
    CompanyListScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Show current screen

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed, // prevents shifting

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: "Product",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_rounded),
            label: "staff",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline_outlined),
            label: "Customer",
          ),
        ],
      ),
    );
  }
}
