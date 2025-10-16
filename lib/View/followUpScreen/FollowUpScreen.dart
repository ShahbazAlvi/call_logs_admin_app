// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../Provider/FollowUp/FollowupProvider.dart';
//
//
// class FollowUpScreen extends StatefulWidget {
//   const FollowUpScreen({super.key});
//
//   @override
//   State<FollowUpScreen> createState() => _FollowUpScreenState();
// }
//
// class _FollowUpScreenState extends State<FollowUpScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Fetch API data when screen loads
//     Future.microtask(() {
//       final provider = Provider.of<FollowUpProvider>(context, listen: false);
//       provider.fetchFollowUps(); // 🔹 Replace with actual token
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<FollowUpProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: Center(child: const Text('Follow Ups',style: TextStyle(color: Colors.white),)),
//         backgroundColor: Colors.indigo,
//       ),
//       body: provider.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : provider.errorMessage != null
//           ? Center(child: Text(provider.errorMessage!))
//           : provider.followUps.isEmpty
//           ? const Center(child: Text('No follow-ups found'))
//           : ListView.builder(
//         itemCount: provider.followUps.length,
//         itemBuilder: (context, index) {
//           final item = provider.followUps[index];
//           final staff = item.person?.assignedStaff?.username ?? 'Unassigned';
//           final date = item.followDates.isNotEmpty
//               ? item.followDates.first.split('T').first
//               : '-';
//           final time = item.followTimes.isNotEmpty
//               ? item.followTimes.first
//               : '-';
//           final phoneNumber = (item.person?.persons.isNotEmpty ?? false)
//               ? item.person!.persons.first.phoneNumber
//               : '-';
//
//           return Card(
//             margin: const EdgeInsets.symmetric(
//                 horizontal: 12, vertical: 8),
//             elevation: 3,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12)),
//             child: ListTile(
//               leading: const Icon(Icons.business, color: Colors.indigo),
//               title: Text(
//                 item.companyName,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text('Staff: $staff'),
//                   Text('Phone: $phoneNumber'),
//                   Text('Date: $date • Time: $time'),
//                   Text('Status: ${item.status}'),
//                   Text('Action: ${item.action ?? "-"}'),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
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
    Future.microtask(() {
      final provider = Provider.of<FollowUpProvider>(context, listen: false);
      provider.fetchFollowUps();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FollowUpProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Center(
          child: Text('Follow Ups', style: TextStyle(color: Colors.white)),
        ),
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
          final staff =
              item.person?.assignedStaff?.username ?? 'Unassigned';
          final date = item.followDates.isNotEmpty
              ? item.followDates.first.split('T').first
              : '-';
          final time = item.followTimes.isNotEmpty
              ? item.followTimes.first
              : '-';
          final phoneNumber =
          (item.person?.persons.isNotEmpty ?? false)
              ? item.person!.persons.first.phoneNumber
              : '-';

          return Card(
            margin: const EdgeInsets.symmetric(
                horizontal: 12, vertical: 8),
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading:
              const Icon(Icons.business, color: Colors.indigo),
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
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 🔹 Update Button
                  IconButton(
                    icon: const Icon(Icons.edit,
                        color: Colors.green),
                    onPressed: () {
                      _showUpdateDialog(context, item, provider);
                    },
                  ),
                  // 🔹 Delete Button
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final confirm = await showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text('Delete Confirmation'),
                          content: const Text('Are you sure you want to delete this meeting?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        await provider.deleteFollowUp(item.id);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showUpdateDialog(
      BuildContext context, dynamic item, FollowUpProvider provider) {
    final companyController =
    TextEditingController(text: item.companyName ?? '');
    final phoneController =
    TextEditingController(text: item.person?.persons.first.phoneNumber ?? '');
    final dateController = TextEditingController(
        text: item.followDates.isNotEmpty
            ? item.followDates.first.split('T').first
            : '');
    final timeController = TextEditingController(
        text: item.followTimes.isNotEmpty ? item.followTimes.first : '');
    final remarkController = TextEditingController(text: item.action ?? '');

    // ✅ Declare this BEFORE the Dropdown widget
    final validStatuses = ['Complete', 'Hold', 'Close'];
    if (item.status != null && !validStatuses.contains(item.status)) {
      validStatuses.add(item.status!);
    }
    String status = item.status ?? 'Hold';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Follow-Up'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: companyController,
                  decoration: const InputDecoration(
                      labelText: 'Company Name', border: OutlineInputBorder()),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                      labelText: 'Phone Number', border: OutlineInputBorder()),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.tryParse(dateController.text) ??
                              DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          dateController.text =
                              picked.toIso8601String().split('T').first;
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: timeController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Time',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.access_time),
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (picked != null) {
                          timeController.text = picked.format(context).toString();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: remarkController,
                  decoration: const InputDecoration(
                      labelText: 'Customer Remark',
                      border: OutlineInputBorder()),
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                // ✅ Now use it here safely
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  value: status,
                  items: validStatuses
                      .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) status = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              onPressed: () {
                provider.updateFollowUp(
                  id: item.id,
                  companyName: companyController.text,
                  phone: phoneController.text,
                  date: dateController.text,
                  time: timeController.text,
                  remark: remarkController.text,
                  status: status,
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }


}
