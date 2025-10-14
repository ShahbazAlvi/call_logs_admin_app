import 'package:flutter/material.dart';
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
        title: const Text('Staff Members'),
        centerTitle: true,
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
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage:
                NetworkImage(staff.image?.url ?? ''),
                backgroundColor: Colors.grey[200],
              ),
              title: Text(
                staff.username ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(staff.department ?? '',
                      style: const TextStyle(color: Colors.black54)),
                  Text(staff.email ?? '',
                      style: const TextStyle(color: Colors.black54)),
                  Text(staff.number ?? '',
                      style: const TextStyle(color: Colors.black54)),
                ],
              ),
              trailing: Column(
                children: [
                  IconButton(onPressed: (){}, icon: Icon(Icons.delete,color: Colors.red,)),
                  IconButton(onPressed: (){}, icon: Icon(Icons.edit,color: Colors.blue,)),

                ],
              )
            ),
          );
        },
      ),
    );
  }
}
