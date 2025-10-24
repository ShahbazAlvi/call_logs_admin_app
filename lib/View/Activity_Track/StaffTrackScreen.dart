import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Provider/CustomersTrackProvider/StaffTrackProvider.dart';


class StaffTrackScreen extends StatefulWidget {
  const StaffTrackScreen({super.key});

  @override
  State<StaffTrackScreen> createState() => _StaffTrackScreenState();
}

class _StaffTrackScreenState extends State<StaffTrackScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StaffTrackProvider>(context, listen: false).fetchStaffTrack();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Staff Login Tracking',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF5B86E5),Color(0xFF36D1DC), ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Consumer<StaffTrackProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.staffList.isEmpty) {
            return const Center(child: Text('No staff data available.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: provider.staffList.length,
            itemBuilder: (context, index) {
              final staff = provider.staffList[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        staff.username ?? 'Unknown',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Chip(
                        label: Text(
                          (staff.status ?? '').toUpperCase(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: staff.status == 'active'
                            ? Colors.green
                            : Colors.grey,
                      ),
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('📞 Phone: ${staff.phone ?? 'N/A'}'),
                        Text('⏱️ Last Login: ${staff.lastLoginAt ?? '-'}'),
                        Text('🚪 Last Logout: ${staff.lastLogoutAt?.isNotEmpty == true ? staff.lastLogoutAt! : '-'}'),
                        Text('🔢 Total Logins: ${staff.totalLogins ?? 0}'),
                      ],
                    ),
                  ),
                  children: [
                    if (staff.loginHistory != null &&
                        staff.loginHistory!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.all(8),
                        color: Colors.grey[50],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Login History:',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            const SizedBox(height: 6),
                            ...staff.loginHistory!.map((history) => ListTile(
                              dense: true,
                              title: Text(
                                  'Login: ${history.loginAt ?? 'N/A'}'),
                              subtitle: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text('Logout: ${history.logoutAt ?? '-'}'),
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
