import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/CustomersTrackProvider/MeetingTrackProvider.dart';
import '../../Provider/product/product_provider.dart';
import '../../Provider/staff/StaffProvider.dart';
import 'package:intl/intl.dart';

class MeetingTrackScreen extends StatefulWidget {
  const MeetingTrackScreen({super.key});

  @override
  State<MeetingTrackScreen> createState() => _MeetingTrackScreenState();
}

class _MeetingTrackScreenState extends State<MeetingTrackScreen> {
  final List<String> dateOptions = ['today', '1week', '14days', 'all'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StaffProvider>(context, listen: false).fetchStaff();
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
      Provider.of<MeetingTrackProvider>(context, listen: false).fetchMeetings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meeting Tracking',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
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
      body: Consumer<MeetingTrackProvider>(
        builder: (context, provider, _) {
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // 🔍 Search bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search by company or person name...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: provider.setSearch,
                ),
                const SizedBox(height: 12),

                // 🔽 Filters Row
                SingleChildScrollView(
                 // scrollDirection: Axis.horizontal,
                 child:  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      // Staff dropdown
                      Consumer<StaffProvider>(
                        builder: (context, staffProvider, _) {
                          final staffList = staffProvider.staffs;
                          return _buildDropdown(
                            label: 'Assigned Staff',
                            value: provider.selectedStaffName,
                            items: [
                              const DropdownMenuItem(value: null, child: Text('All Staff')),
                              ...staffList.map((s) => DropdownMenuItem(
                                value: s.username,
                                child: Text(s.username ?? 'Unnamed'),
                                onTap: () => provider.setStaff(s.sId, s.username),
                              )),
                            ],
                            onChanged: (value) {
                              if (value == null) provider.setStaff(null, null);
                            },
                          );
                        },
                      ),

                     // const SizedBox(height: 5,),

                      // Product dropdown
                      Consumer<ProductProvider>(
                        builder: (context, productProvider, _) {
                          final productList = productProvider.products;
                          return _buildDropdown(
                            label: 'Assigned Product',
                            value: provider.selectedProductName,
                            items: [
                              const DropdownMenuItem(value: null, child: Text('All Products')),
                              ...productList.map((p) => DropdownMenuItem(
                                value: p.name,
                                child: Text(p.name ?? 'Unnamed Product'),
                                onTap: () => provider.setProduct(p.sId, p.name),
                              )),
                            ],
                            onChanged: (value) {
                              if (value == null) provider.setProduct(null, null);
                            },
                          );
                        },
                      ),

                      //const SizedBox(width: 8),

                      // Date range dropdown
                      _buildDropdown(
                        label: 'Date Range',
                        value: provider.selectedDateRange,
                        items: dateOptions
                            .map((d) =>
                            DropdownMenuItem(value: d, child: Text(d.toUpperCase())))
                            .toList(),
                        onChanged: provider.setDateRange,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // 📋 Meeting list
                Expanded(
                  child: provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : provider.filteredMeetings.isEmpty
                      ? const Center(child: Text('No meetings found'))
                      : ListView.builder(
                    itemCount: provider.filteredMeetings.length,
                    itemBuilder: (context, index) {
                      final meeting = provider.filteredMeetings[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        elevation: 3,
                        margin:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                        child: ListTile(
                          title: Text(
                            meeting.companyName,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (meeting.persons.isNotEmpty)
                                Text(
                                    "👥 ${meeting.persons.map((p) => p.fullName ?? '').join(', ')}"),
                              if (meeting.assignedStaff?.username != null)
                                Text("👤 Staff: ${meeting.assignedStaff?.username}"),
                              if (meeting.assignedProducts?.name != null)
                                Text("📦 Product: ${meeting.assignedProducts?.name}"),
                              if (meeting.status != null)
                                Text("📊 Status: ${meeting.status}"),
                              if (meeting.timeline != null)
                                Text("⏱️ Timeline: ${meeting.timeline}"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 🔹 Reusable dropdown widget
  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<DropdownMenuItem<String?>> items,
    required void Function(String?)? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: SizedBox(
        width: double.infinity,
        child: DropdownButtonFormField<String?>(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          value: value,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
