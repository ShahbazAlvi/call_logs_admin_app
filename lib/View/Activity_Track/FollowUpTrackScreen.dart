import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/CustomersTrackProvider/FollowUpTrackProvider.dart';
import '../../Provider/product/product_provider.dart';
import '../../Provider/staff/StaffProvider.dart';

class FollowUpTrackScreen extends StatefulWidget {
  const FollowUpTrackScreen({super.key});

  @override
  State<FollowUpTrackScreen> createState() => _FollowUpTrackScreenState();
}

class _FollowUpTrackScreenState extends State<FollowUpTrackScreen> {
  final List<String> dateOptions = ['today', '1week', '14days', 'all'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StaffProvider>(context, listen: false).fetchStaff();
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
      Provider.of<FollowUpTrackProvider>(context, listen: false).fetchFollowUps();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Follow-Up Tracking',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF5B86E5),Color(0xFF36D1DC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Consumer<FollowUpTrackProvider>(
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

                // 🔽 Filters
                SingleChildScrollView(
                 // scrollDirection: Axis.horizontal,
                  child: Column(
                    children: [
                      // Staff dropdown
                      Consumer<StaffProvider>(
                        builder: (context, staffProvider, _) {
                          return _buildDropdown(
                            label: 'Assigned Staff',
                            value: provider.selectedStaffName,
                            items: [
                              const DropdownMenuItem(value: null, child: Text('All Staff')),
                              ...staffProvider.staffs.map(
                                    (s) => DropdownMenuItem(
                                  value: s.username,
                                  child: Text(s.username ?? 'Unnamed'),
                                  onTap: () => provider.setStaff(s.sId, s.username),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              if (value == null) provider.setStaff(null, null);
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 8),

                      // Product dropdown
                      Consumer<ProductProvider>(
                        builder: (context, productProvider, _) {
                          return _buildDropdown(
                            label: 'Product',
                            value: provider.selectedProductName,
                            items: [
                              const DropdownMenuItem(value: null, child: Text('All Products')),
                              ...productProvider.products.map(
                                    (p) => DropdownMenuItem(
                                  value: p.name,
                                  child: Text(p.name ?? 'Unnamed Product'),
                                  onTap: () => provider.setProduct(p.sId, p.name),
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              if (value == null) provider.setProduct(null, null);
                            },
                          );
                        },
                      ),
                      const SizedBox(width: 8),

                      // Date range
                      _buildDropdown(
                        label: 'Date Range',
                        value: provider.selectedDateRange,
                        items: dateOptions
                            .map((d) => DropdownMenuItem(value: d, child: Text(d.toUpperCase())))
                            .toList(),
                        onChanged: provider.setDateRange,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // 📋 Follow-up list
                Expanded(
                  child: provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : provider.filteredFollowUps.isEmpty
                      ? const Center(child: Text('No follow-ups found'))
                      : ListView.builder(
                    itemCount: provider.filteredFollowUps.length,
                    itemBuilder: (context, index) {
                      final followUp = provider.filteredFollowUps[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                        child: ListTile(
                          title: Text(
                            followUp.companyName ?? 'Unknown Company',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (followUp.persons != null &&
                                  followUp.persons!.isNotEmpty)
                                Text(
                                    "👥 ${followUp.persons!.map((p) => p.fullName ?? '').join(', ')}"),
                              if (followUp.assignedStaff?.username != null)
                                Text("👤 Staff: ${followUp.assignedStaff?.username}"),
                              if (followUp.product?.name != null)
                                Text("📦 Product: ${followUp.product?.name}"),
                              if (followUp.status != null)
                                Text("📊 Status: ${followUp.status}"),
                              if (followUp.timeline != null)
                                Text("⏱️ Timeline: ${followUp.timeline}"),
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

  // 🔹 Reusable dropdown
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
       // width: 200,
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
