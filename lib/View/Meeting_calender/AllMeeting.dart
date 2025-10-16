//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../Provider/MeetingProvider/AllMeetingProvider.dart';
//
// class AllMeetingScreen extends StatefulWidget {
//   const AllMeetingScreen({super.key});
//
//   @override
//   State<AllMeetingScreen> createState() => _AllMeetingScreenState();
// }
//
// class _AllMeetingScreenState extends State<AllMeetingScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() =>
//         Provider.of<AllMeetingProvider>(context, listen: false).fetchMeetings());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<AllMeetingProvider>(context);
//     final meetings = provider.meetings;
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Meetings"),
//         backgroundColor: Colors.indigo,
//         foregroundColor: Colors.white,
//       ),
//       body: provider.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : meetings.isEmpty
//           ? const Center(child: Text("No meetings found"))
//           : ListView.builder(
//         padding: const EdgeInsets.all(8),
//         itemCount: meetings.length,
//         itemBuilder: (context, index) {
//           final meeting = meetings[index];
//           final personName =
//           meeting.person?.persons.isNotEmpty == true
//               ? meeting.person!.persons.first.fullName
//               : 'Unknown Person';
//           final dateList = meeting.followDates.join(", ");
//           final timeList = meeting.followTimes.join(", ");
//
//           return Card(
//             margin: const EdgeInsets.symmetric(vertical: 6),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: ListTile(
//               leading: const Icon(Icons.business,
//                   color: Colors.indigoAccent),
//               title: Text(
//                 meeting.companyName,
//                 style: const TextStyle(
//                     fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               subtitle: Text(
//                 "Person: $personName\nDate: $dateList\nTime: $timeList",
//               ),
//               trailing: IconButton(
//                 icon: const Icon(Icons.edit, color: Colors.indigo),
//                 onPressed: () => _showEditDialog(context, meeting),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//
//
//   void _showEditDialog(BuildContext context, dynamic meeting) {
//     String selectedStatus = 'Follow Up';
//     TextEditingController detailController = TextEditingController();
//     TextEditingController timeController = TextEditingController();
//     TextEditingController dateController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(
//                   maxHeight: MediaQuery.of(context).size.height * 0.85,
//                 ),
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Center(
//                         child: Text(
//                           "Meeting Details",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 18),
//                         ),
//                       ),
//                       const SizedBox(height: 12),
//                       _buildInfoRow("🏢 Company:", meeting.companyName),
//                       const SizedBox(height: 6),
//                       _buildInfoRow(
//                         "👤 Person:",
//                         meeting.person?.persons.isNotEmpty == true
//                             ? meeting.person!.persons.first.fullName
//                             : "Unknown Person",
//                       ),
//                       const SizedBox(height: 12),
//                       Row(
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.call, color: Colors.green),
//                             onPressed: () {
//                               // TODO: Add call logic
//                             },
//                           ),
//                           IconButton(
//                             icon:Image.asset("assets/images/whatsapp.jpeg",width: 30,height: 30,),
//
//                             onPressed: () {
//                               // TODO: Add WhatsApp logic
//                             },
//                           ),
//                         ],
//                       ),
//                       const Divider(),
//                       const Text(
//                         "Meeting Type",
//                         style: TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 6),
//                       RadioListTile<String>(
//                         title: const Text("Follow Up"),
//                         value: "Follow Up",
//                         groupValue: selectedStatus,
//                         onChanged: (value) =>
//                             setState(() => selectedStatus = value!),
//                       ),
//                       RadioListTile<String>(
//                         title: const Text("Already"),
//                         value: "Already",
//                         groupValue: selectedStatus,
//                         onChanged: (value) =>
//                             setState(() => selectedStatus = value!),
//                       ),
//                       RadioListTile<String>(
//                         title: const Text("Not Interested"),
//                         value: "Not Interested",
//                         groupValue: selectedStatus,
//                         onChanged: (value) =>
//                             setState(() => selectedStatus = value!),
//                       ),
//                       RadioListTile<String>(
//                         title: const Text("Phone Response"),
//                         value: "Phone Response",
//                         groupValue: selectedStatus,
//                         onChanged: (value) =>
//                             setState(() => selectedStatus = value!),
//                       ),
//                       if (selectedStatus == "Follow Up") ...[
//                         const SizedBox(height: 10),
//                         TextField(
//                           controller: dateController,
//                           readOnly: true,
//                           decoration: const InputDecoration(
//                             labelText: "Follow-up Date",
//                             border: OutlineInputBorder(),
//                           ),
//                           onTap: () async {
//                             FocusScope.of(context).requestFocus(FocusNode());
//                             final picked = await showDatePicker(
//                               context: context,
//                               initialDate: DateTime.now(),
//                               firstDate: DateTime(2024),
//                               lastDate: DateTime(2030),
//                             );
//                             if (picked != null) {
//                               setState(() {
//                                 dateController.text =
//                                 "${picked.day}-${picked.month}-${picked.year}";
//                               });
//                             }
//                           },
//                         ),
//                         const SizedBox(height: 10),
//                         TextField(
//                           controller: timeController,
//                           readOnly: true,
//                           decoration: const InputDecoration(
//                             labelText: "Follow-up Time",
//                             border: OutlineInputBorder(),
//                           ),
//                           onTap: () async {
//                             FocusScope.of(context).requestFocus(FocusNode());
//                             final picked = await showTimePicker(
//                               context: context,
//                               initialTime: TimeOfDay.now(),
//                             );
//                             if (picked != null) {
//                               setState(() {
//                                 timeController.text = picked.format(context);
//                               });
//                             }
//                           },
//                         ),
//                         const SizedBox(height: 10),
//                         TextField(
//                           controller: detailController,
//                           decoration: const InputDecoration(
//                             labelText: "Detail",
//                             border: OutlineInputBorder(),
//                           ),
//                           maxLines: 3,
//                         ),
//                       ],
//                       const SizedBox(height: 16),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context),
//                             child: const Text("Cancel"),
//                           ),
//                           const SizedBox(width: 8),
//                           ElevatedButton(
//                             onPressed: () {
//                               // TODO: Save API call here
//                               Navigator.pop(context);
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.indigo,
//                             ),
//                             child: const Text(
//                               "Save",
//                               style: TextStyle(color: Colors.white),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//
//   Widget _buildInfoRow(String label, String value) {
//     return Row(
//       children: [
//         Text(label,
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
//         const SizedBox(width: 4),
//         Expanded(
//           child: Text(value, style: const TextStyle(fontSize: 14)),
//         ),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/MeetingProvider/AllMeetingProvider.dart';

class AllMeetingScreen extends StatefulWidget {
  const AllMeetingScreen({super.key});

  @override
  State<AllMeetingScreen> createState() => _AllMeetingScreenState();
}

class _AllMeetingScreenState extends State<AllMeetingScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<AllMeetingProvider>(context, listen: false).fetchMeetings());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AllMeetingProvider>(context);
    final meetings = provider.meetings;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Meetings"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : meetings.isEmpty
          ? const Center(child: Text("No meetings found"))
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: meetings.length,
        itemBuilder: (context, index) {
          final meeting = meetings[index];
          final personName = meeting.person?.persons.isNotEmpty == true
              ? meeting.person!.persons.first.fullName
              : 'Unknown Person';
          final productName =
              meeting.product?.name ?? "Unknown Product";
          final staffName =
              meeting.referToStaff?.username ?? "Unassigned";
          final dateList = meeting.followDates.join(", ");
          final timeList = meeting.followTimes.join(", ");

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: const Icon(Icons.business,
                  color: Colors.indigoAccent),
              title: Text(
                meeting.companyName,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Text(
                "👤 $personName\n🧩 Product: $productName\n🧑‍💼 Staff: $staffName\n📅 Date: $dateList\n⏰ Time: $timeList",
                style: const TextStyle(height: 1.4),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.indigo),
                onPressed: () => _showEditDialog(context, meeting),
              ),
            ),
          );
        },
      ),
    );
  }

  // ✅ Edit Dialog
  void _showEditDialog(BuildContext context, dynamic meeting) {
    String selectedStatus = 'Follow Up';
    TextEditingController detailController = TextEditingController();
    TextEditingController timeController = TextEditingController();
    TextEditingController dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final personName = meeting.person?.persons.isNotEmpty == true
                ? meeting.person!.persons.first.fullName
                : "Unknown Person";
            final productName = meeting.product?.name ?? "Unknown Product";
            final staffName = meeting.referToStaff?.username ?? "Unassigned";

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              insetPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.85,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          "Meeting Details",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow("🏢 Company:", meeting.companyName),
                      _buildInfoRow("👤 Person:", personName),
                      _buildInfoRow("🧩 Product:", productName),
                      _buildInfoRow("🧑‍💼 Staff:", staffName),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.call, color: Colors.green),
                            onPressed: () {
                              // TODO: Add call logic
                            },
                          ),
                          IconButton(
                            icon: Image.asset(
                              "assets/images/whatsapp.jpeg",
                              width: 30,
                              height: 30,
                            ),
                            onPressed: () {
                              // TODO: Add WhatsApp logic
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                      const Text(
                        "Meeting Type",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      ...["Follow Up", "Already", "Not Interested", "Phone Response"]
                          .map(
                            (type) => RadioListTile<String>(
                          title: Text(type),
                          value: type,
                          groupValue: selectedStatus,
                          onChanged: (value) =>
                              setState(() => selectedStatus = value!),
                        ),
                      )
                          .toList(),
                      if (selectedStatus == "Follow Up") ...[
                        const SizedBox(height: 10),
                        TextField(
                          controller: dateController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: "Follow-up Date",
                            border: OutlineInputBorder(),
                          ),
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2024),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) {
                              setState(() {
                                dateController.text =
                                "${picked.day}-${picked.month}-${picked.year}";
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: timeController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: "Follow-up Time",
                            border: OutlineInputBorder(),
                          ),
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null) {
                              setState(() {
                                timeController.text = picked.format(context);
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: detailController,
                          decoration: const InputDecoration(
                            labelText: "Detail",
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 3,
                        ),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              // TODO: Save API call here
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                            ),
                            child: const Text(
                              "Save",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(label,
              style:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(width: 4),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}
