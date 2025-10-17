// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../Provider/MeetingProvider/NoDateMeetingProvider.dart';
// import 'NotdateMeetingUpdate.dart';
//
//
// class NoDateMeetingScreen extends StatefulWidget {
//
//   const NoDateMeetingScreen({super.key,});
//
//   @override
//   State<NoDateMeetingScreen> createState() => _NoDateMeetingScreenState();
// }
//
// class _NoDateMeetingScreenState extends State<NoDateMeetingScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       Provider.of<NoDateMeetingProvider>(context, listen: false)
//           .fetchMeetings();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<NoDateMeetingProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.indigo,
//         iconTheme: IconThemeData(color: Colors.white),
//         title: const Text('Meetings Without FollowUp',style: TextStyle(color: Colors.white),),
//       ),
//       body: provider.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : provider.meetings.isEmpty
//           ? const Center(child: Text('No meetings found'))
//           : ListView.builder(
//         padding: const EdgeInsets.all(12),
//         itemCount: provider.meetings.length,
//         itemBuilder: (context, index) {
//           final item = provider.meetings[index];
//           final personName = (item.person?.persons.isNotEmpty ?? false)
//               ? item.person!.persons.first.fullName ?? "Unknown"
//               : "Unknown";
//           final productName = item.product?.name ?? "N/A";
//           final staffName = item.person?.assignedStaff?.username ?? "Unassigned";
//
//           return Card(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//             elevation: 2,
//             margin: const EdgeInsets.symmetric(vertical: 6),
//             child: ListTile(
//               contentPadding: const EdgeInsets.all(10),
//               title: Text(
//                 item.companyName ?? "Unknown Company",
//                 style: const TextStyle(
//                     fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("👤 Person: $personName"),
//                   Text("📦 Product: $productName"),
//                   Text("🧑‍💼 Assigned Staff: $staffName"),
//                 ],
//               ),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     icon: const Icon(Icons.edit, color: Colors.indigo),
//                     onPressed: () {
//                       Navigator.push(context,MaterialPageRoute(builder: (context)=>EditMeetingScreen( meeting: item)));
//                       // TODO: Navigate to update screen
//                     },
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.delete, color: Colors.red),
//                     onPressed: () async {
//                       await provider.deleteMeeting(
//                           item.id ?? ''
//                       );
//                     },
//                   ),
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
import '../../Provider/MeetingProvider/NoDateMeetingProvider.dart';
import 'NotdateMeetingUpdate.dart';

class NoDateMeetingScreen extends StatefulWidget {
  const NoDateMeetingScreen({super.key});

  @override
  State<NoDateMeetingScreen> createState() => _NoDateMeetingScreenState();
}

class _NoDateMeetingScreenState extends State<NoDateMeetingScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<NoDateMeetingProvider>(context, listen: false)
          .fetchMeetings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<NoDateMeetingProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Meetings Without Follow-Up',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.meetings.isEmpty
          ? const Center(child: Text('No meetings found'))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: provider.meetings.length,
        itemBuilder: (context, index) {
          final item = provider.meetings[index];
          final personName = (item.person?.persons.isNotEmpty ?? false)
              ? item.person!.persons.first.fullName ?? "Unknown"
              : "Unknown";
          final productName = item.product?.name ?? "N/A";
          final staffName =
              item.person?.assignedStaff?.username ?? "Unassigned";

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              title: Text(
                item.companyName ?? "Unknown Company",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("👤 Person: $personName"),
                  Text("📦 Product: $productName"),
                  Text("🧑‍💼 Staff: $staffName"),
                  Text("📅 Status: ${item.status ?? 'N/A'}"),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon:
                    const Icon(Icons.edit, color: Colors.indigo),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditMeetingScreen(meeting: item),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await provider.deleteMeeting(item.id ?? '');
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
}

