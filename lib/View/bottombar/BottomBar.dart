// import 'package:flutter/material.dart';
//
// import '../Customer/customer_list.dart';
// import '../home/dashboard_screen.dart';
// import '../products/product_screen.dart';
// import '../staff/staffListScreen.dart';
//
// class BottombarScreen extends StatefulWidget {
//   const BottombarScreen({super.key});
//
//   @override
//   State<BottombarScreen> createState() => _BottombarScreenState();
// }
//
//
// class _BottombarScreenState extends State<BottombarScreen> {
//   int _selectedIndex = 0;
//
//   final List<Widget> _screens = [
//     const DashboardScreen(),
//     const ProductScreen(),
//     const StaffScreen(),
//     const CompanyListScreen(),
//   ];
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   Future<bool> _onWillPop() async {
//     if (_selectedIndex != 0) {
//       // 👈 if not on Home, go to Home
//       setState(() {
//         _selectedIndex = 0;
//       });
//       return false; // prevent closing app
//     } else {
//       // 👈 if already on Home, show exit dialog
//       final shouldExit = await showDialog<bool>(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text("Exit App"),
//           content: const Text("Are you sure you want to exit the app?"),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context, false),
//               child: const Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () => Navigator.pop(context, true),
//               child: const Text("Exit"),
//             ),
//           ],
//         ),
//       );
//       return shouldExit ?? false;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: _onWillPop, // 👈 Handle Android back button
//       child: Scaffold(
//         body: _screens[_selectedIndex],
//         bottomNavigationBar: BottomNavigationBar(
//           currentIndex: _selectedIndex,
//           onTap: _onItemTapped,
//           backgroundColor: Colors.white,
//           selectedItemColor: Colors.indigo,
//           unselectedItemColor: Colors.grey,
//           type: BottomNavigationBarType.fixed,
//           items: const [
//             BottomNavigationBarItem(
//               icon: Icon(Icons.home),
//               label: "Home",
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.shop),
//               label: "Product",
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.people_rounded),
//               label: "Staff",
//             ),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.people_outline_outlined),
//               label: "Customer",
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String? userRole; // 👈 Store user role

  List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role'); // e.g. "admin" or "staff"
    setState(() {
      userRole = role;

      // 👇 If admin → show all tabs
      if (role == 'admin') {
        _screens = const [
          DashboardScreen(),
          ProductScreen(),
          StaffScreen(),
          CompanyListScreen(),
        ];
      } else {
        // 👇 Non-admin → hide Product and Staff
        _screens = const [
          DashboardScreen(),
          CompanyListScreen(),
        ];
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<bool> _onWillPop() async {
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    } else {
      final shouldExit = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Exit App"),
          content: const Text("Are you sure you want to exit the app?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Exit"),
            ),
          ],
        ),
      );
      return shouldExit ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // ⏳ While loading role
    if (userRole == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.indigo,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: userRole == 'admin'
              ? const [
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
              label: "Staff",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline_outlined),
              label: "Customer",
            ),
          ]
              : const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline_outlined),
              label: "Customer",
            ),
          ],
        ),
      ),
    );
  }
}
