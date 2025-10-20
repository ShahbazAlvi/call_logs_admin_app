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
import 'package:shared_preferences/shared_preferences.dart';
import '../../Provider/FollowUp/FollowupProvider.dart';
import '../../model/FollowUpModel.dart';

class FollowUpScreen extends StatefulWidget {
  const FollowUpScreen({super.key});

  @override
  State<FollowUpScreen> createState() => _FollowUpScreenState();
}

class _FollowUpScreenState extends State<FollowUpScreen> {
  String? userRole;
  @override
  void initState() {
    super.initState();
    _loadUserRole();
    Future.microtask(() {
      final provider = Provider.of<FollowUpProvider>(context, listen: false);
      provider.fetchFollowUps();
    });
  }
  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getString('role') ?? 'user'; // default = user
    });

  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FollowUpProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Follow Up',
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
              const Icon(Icons.business, color: Color(0xFF5B86E5)),
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
                  IconButton(
                    icon: const Icon(Icons.remove_red_eye, color: Colors.teal),
                    onPressed: () {
                      _showDetailsDialog(context, item);
                    },
                  ),
                  // 🔹 Update Button
                  IconButton(
                    icon: const Icon(Icons.edit,
                        color: Color(0xFF5B86E5)),
                    onPressed: () {
                      _showUpdateDialog(context, item, provider);
                    },
                  ),
                  // 🔹 Delete Button
                  if (userRole == 'admin')
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
                    labelText: 'Next Follow Up Date',
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
                    labelText: 'Next Follow Up Time',
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
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF5B86E5)),
              child: const Text('Update',style: TextStyle(color:Colors.white),),
            ),
          ],
        );
      },
    );
  }





  void _showDetailsDialog(BuildContext context, FollowUpData item) {
    showDialog(
      context: context,
      builder: (context) {
        final productName = item.product?.name ?? '-';
        final price = item.product?.price?.toString() ?? '-';
        final staffName = item.person?.assignedStaff?.username ?? 'Unassigned';
        final contactMethod = item.contactMethod ?? '-';
        final designation = item.designation ?? '-';
        final referToStaff = item.referToStaff ?? '-';
        final reference = item.reference ?? '-';

        final persons = item.person?.persons ?? [];
        final dates = item.followDates.join(', ');
        final times = item.followTimes.join(', ');
        final details = item.details.join('\n');

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Row(
            children: const [
              Icon(Icons.business, color: Color(0xFF5B86E5)),
              SizedBox(width: 8),
              Text(
                'Company Details',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),

          // 👇 Add height constraint + scroll
          content: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoRow('🏢 Company', item.companyName),
                  _infoRow('🧑‍💼 Staff', staffName),
                  _infoRow('📦 Product', productName),
                  _infoRow('💰 Price', price),
                  _infoRow('📞 Contact Method', contactMethod),
                  _infoRow('🎯 Status', item.status),
                  _infoRow('🕓 Follow Dates', dates),
                  _infoRow('⏰ Follow Times', times),
                  _infoRow('📝 Action', item.action ?? '-'),
                  _infoRow('📋 Details', details.isNotEmpty ? details : '-'),

                  const Divider(),

                  const Text(
                    '👥 Person Details:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 6),

                  // 👇 List of persons
                  ...persons.map((p) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      '• ${p.fullName} (${p.phoneNumber})',
                      style: const TextStyle(fontSize: 14),
                    ),
                  )),

                  if (persons.isEmpty)
                    const Text('No person details available',
                        style: TextStyle(color: Colors.grey)),

                  const Divider(),

                  _infoRow('🏷️ Designation', designation),
                  _infoRow('👨‍💻 Refer to Staff', referToStaff),
                  _infoRow('🔗 Reference', reference),
                ],
              ),
            ),
          ),

          actions: [
            TextButton(
              child: const Text('Close', style: TextStyle(color: Colors.indigo)),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }


}
