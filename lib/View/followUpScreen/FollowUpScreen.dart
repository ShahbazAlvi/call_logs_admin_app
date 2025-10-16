import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Provider/FollowUp/FollowupProvider.dart';


class FollowUpScreen extends StatefulWidget {
  const FollowUpScreen({super.key});

  @override
  State<FollowUpScreen> createState() => _FollowUpScreenState();
}

class _FollowUpScreenState extends State<FollowUpScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch API data when screen loads
    Future.microtask(() {
      final provider = Provider.of<FollowUpProvider>(context, listen: false);
      provider.fetchFollowUps(); // 🔹 Replace with actual token
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FollowUpProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(child: const Text('Follow Ups',style: TextStyle(color: Colors.white),)),
        backgroundColor: Colors.indigo,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.errorMessage != null
          ? Center(child: Text(provider.errorMessage!))
          : provider.followUps.isEmpty
          ? const Center(child: Text('No follow-ups found'))
          : ListView.builder(
        itemCount: provider.followUps.length,
        itemBuilder: (context, index) {
          final item = provider.followUps[index];
          final staff = item.person?.assignedStaff?.username ?? 'Unassigned';
          final date = item.followDates.isNotEmpty
              ? item.followDates.first.split('T').first
              : '-';
          final time = item.followTimes.isNotEmpty
              ? item.followTimes.first
              : '-';
          final phoneNumber = (item.person?.persons.isNotEmpty ?? false)
              ? item.person!.persons.first.phoneNumber
              : '-';

          return Card(
            margin: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 8),
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const Icon(Icons.business, color: Colors.indigo),
              title: Text(
                item.companyName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Staff: $staff'),
                  Text('Phone: $phoneNumber'),
                  Text('Date: $date • Time: $time'),
                  Text('Status: ${item.status}'),
                  Text('Action: ${item.action ?? "-"}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
