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
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Staff Members',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
        centerTitle: true,
        actions: [IconButton(onPressed: (){
          Navigator.push(context,MaterialPageRoute(builder: (context)=>StaffCreateScreen()));
        }, icon:Icon(Icons.add))],
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
                    backgroundImage: NetworkImage(staff.image?.url ?? ''),
                    backgroundColor: Colors.grey[200],
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
