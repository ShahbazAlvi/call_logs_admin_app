
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Provider/customer/customer_provider.dart';
import 'add_customer.dart';
import 'customer detail.dart';
import 'customerUpdate.dart';

class CompanyListScreen extends StatefulWidget {
  const CompanyListScreen({super.key});

  @override
  State<CompanyListScreen> createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> {
  String? userRole;
  TextEditingController searchController = TextEditingController();
  String searchQuery = "";
  int currentPage = 0;
  final int itemsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CompanyProvider>(context, listen: false).fetchCompanies();
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
    final provider = Provider.of<CompanyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Customers",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            letterSpacing: 1.2,
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
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder:(context)=>AddCustomerScreen()));
              },
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              label: const Text(
                "Add",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),

      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.errorMessage.isNotEmpty
          ? Center(child: Text(provider.errorMessage))
          : Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.toLowerCase();
                    });
                  },
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Search by Company Name",
                    hintStyle: const TextStyle(color: Colors.black),
                    prefixIcon: const Icon(Icons.search, color: Colors.black),
                   // filled: true,
                   // fillColor: Colors.black.withOpacity(0.2),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    final filteredList = provider.companies.where((company) {
                      return company.companyName
                          .toLowerCase()
                          .contains(searchQuery);
                    }).toList();
                    final totalPages =
                    (filteredList.length / itemsPerPage).ceil();

                    final startIndex = currentPage * itemsPerPage;
                    final endIndex =
                    (startIndex + itemsPerPage > filteredList.length)
                        ? filteredList.length
                        : startIndex + itemsPerPage;

                    final paginatedList =
                    filteredList.sublist(startIndex, endIndex);
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(


                            itemCount: paginatedList.length,
                            itemBuilder: (context, index) {
                              final c = paginatedList[index];

                              // itemCount: provider.companies.length,
                                  // itemBuilder: (context, index) {
                                  //   final c = provider.companies[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            child: GestureDetector(
                              onTap:(){
                               // Navigate to detail/edit screen
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        CompanyDetailScreen(company: c),
                                  ),
                                );
                              } ,
                              child: ListTile(
                                leading: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    c.companyLogo?.url ?? "",
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.business, size: 40, color: Colors.grey);
                                    },
                                  ),
                                ),

                                title: Text(
                                  c.companyName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                subtitle: Text('${c.businessType} • ${c.city}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // 🟢 Edit Button
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => UpdateCustomerScreen(customerId: c.id),
                                          ),
                                        );
                                      },

                                    ),

                                    //
                                    // 🔴 Delete Button
                                    if (userRole == 'admin')
                                      IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Delete Company'),
                                            content: Text(
                                                'Are you sure you want to delete "${c.companyName}"?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context, false),
                                                child: const Text('Cancel'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () =>
                                                    Navigator.pop(context, true),
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirm == true) {
                                          provider.deleteCompany(c.id);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                                  },
                                ),
                        ),
                        if (totalPages > 1)
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                // Previous
                                ElevatedButton(
                                  onPressed: currentPage > 0
                                      ? () {
                                    setState(() {
                                      currentPage--;
                                    });
                                  }
                                      : null,
                                  child: const Text("Previous"),
                                ),

                                Text(
                                  "Page ${currentPage + 1} / $totalPages",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),

                                // Next
                                ElevatedButton(
                                  onPressed: currentPage < totalPages - 1
                                      ? () {
                                    setState(() {
                                      currentPage++;
                                    });
                                  }
                                      : null,
                                  child: const Text("Next"),
                                ),
                              ],
                            ),
                          ),

                      ],
                    );
                  }
                ),
              ),
            ],
          ),

    );
  }
}
