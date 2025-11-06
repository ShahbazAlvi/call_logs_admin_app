import 'package:flutter/material.dart';
import 'package:infinity/View/staff/create_staff.dart';
import 'package:infinity/View/staff/updateScreenStaff.dart';
import 'package:provider/provider.dart';

import '../../Provider/staff/StaffProvider.dart';


class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch staff data when the screen opens
    Future.microtask(() =>
        Provider.of<StaffProvider>(context, listen: false).fetchStaff());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StaffProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Staff Members",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
          ),
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
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder: (context)=>StaffCreateScreen()));
              },
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              label: const Text(
                "Add Staffs",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.staffs.isEmpty
          ? const Center(child: Text("No staff found"))
          : ListView.builder(
        itemCount: provider.staffs.length,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          final staff = provider.staffs[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: (staff.image?.url != null &&
                        staff.image!.url!.isNotEmpty)
                        ? NetworkImage(staff.image!.url!)
                        : null,
                    child: (staff.image?.url == null ||
                        staff.image!.url!.isEmpty)
                        ? const Icon(Icons.person, size: 30, color: Colors.white)
                        : null,
                  ),

                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          staff.username ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(staff.department ?? '',
                            style: const TextStyle(color: Colors.black54)),
                        Text(staff.email ?? '',
                            style: const TextStyle(color: Colors.black54)),
                        Text(staff.number ?? '',
                            style: const TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditStaffScreen(staff: staff),
                            ),
                          );
                        },
                        icon: const Icon(Icons.edit, color: Colors.blue),
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Staff'),
                              content: const Text('Are you sure you want to delete this staff?'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Yes'),
                                ),
                              ],
                            ),
                          );

                          // If user pressed "Yes"
                          if (confirm == true) {
                            provider.DeleteStaff("${staff.sId}");

                            // Optional: show success message/snackbar
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('staff deleted successfully!'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        },
                      )
                    ],
                  ),
                ],
              ),
            ),
          );

        },
      ),
    );
  }
}
