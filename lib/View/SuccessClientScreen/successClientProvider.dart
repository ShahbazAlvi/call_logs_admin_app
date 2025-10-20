import 'package:flutter/material.dart';
import '../../Provider/successClient/SuccessClientProvider.dart';
import '../../model/SuccessClient.dart';

class SuccessClientScreen extends StatefulWidget {
  const SuccessClientScreen({Key? key}) : super(key: key);

  @override
  State<SuccessClientScreen> createState() => _SuccessClientScreenState();
}

class _SuccessClientScreenState extends State<SuccessClientScreen> {
  late Future<SuccessClientModel?> _futureClients;
  final _service = SuccessClientService();

  @override
  void initState() {
    super.initState();
    _futureClients = _service.fetchSuccessClients();
  }

  Future<void> _deleteClient(String id) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Client"),
        content: const Text("Are you sure you want to delete this client?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
        ],
      ),
    );

    if (confirm != true) return;

    final success = await _service.deleteClient(id);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Client deleted successfully")),
      );
      setState(() {
        _futureClients = _service.fetchSuccessClients(); // refresh list
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ Failed to delete client")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Success Clients',
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
      body: FutureBuilder<SuccessClientModel?>(
        future: _futureClients,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data found.'));
          }

          final clients = snapshot.data!.data;

          return ListView.builder(
            itemCount: clients.length,
            itemBuilder: (context, index) {
              final client = clients[index];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(client.companyName),
                  subtitle: Text('${client.designation} • ${client.status}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(client.product?.name ?? 'No Product'),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteClient(client.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
