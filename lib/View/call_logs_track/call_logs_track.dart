import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/callLogsProvider/callLogsProvider.dart';

class CallLogsScreen extends StatefulWidget {
  const CallLogsScreen({Key? key}) : super(key: key);

  @override
  State<CallLogsScreen> createState() => _CallLogsScreenState();
}

class _CallLogsScreenState extends State<CallLogsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CallLogsProvider>(context, listen: false).fetchCallLogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CallLogsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Meeting Call Logs Track',
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
          : provider.callLogs.isEmpty
          ? const Center(child: Text("No call logs found."))
          : ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: provider.callLogs.length,
        itemBuilder: (context, index) {
          final log = provider.callLogs[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            child: ListTile(
              contentPadding: const EdgeInsets.all(10),
              title: Text(
                log.customerName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("📞 ${log.phoneNumber}"),
                  Text("👩‍💼 ${log.staffName}"),
                  Text("🕒 ${log.date} - ${log.time}"),
                  Text("📍 ${log.location}"),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Delete Call Log"),
                      content: const Text(
                          "Are you sure you want to delete this call log?"),
                      actions: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pop(context, true),
                          child: const Text(
                            "Delete",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    final body = {
                      "customerName": log.customerName,
                      "phoneNumber": log.phoneNumber,
                      "staffName": log.staffName,
                      "date": log.date,
                      "time": log.time,
                      "mode": log.mode,
                      "location": log.location,
                    };

                    final success = await provider.deleteCallLog(
                      id: log.id,
                      body: body,
                    );

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                          Text("✅ Call log deleted successfully"),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                          Text("❌ Failed to delete call log"),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
