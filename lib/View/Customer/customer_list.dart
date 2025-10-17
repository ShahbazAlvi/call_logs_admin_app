// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../Provider/customer/customer_provider.dart';
// import 'customer detail.dart';
//
// class CompanyListScreen extends StatefulWidget {
//   const CompanyListScreen({super.key});
//
//   @override
//   State<CompanyListScreen> createState() => _CompanyListScreenState();
// }
//
// class _CompanyListScreenState extends State<CompanyListScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<CompanyProvider>(context, listen: false).fetchCompanies();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CompanyProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Company List'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.refresh),
//             onPressed: provider.fetchCompanies,
//           )
//         ],
//       ),
//       body: provider.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : provider.errorMessage.isNotEmpty
//           ? Center(child: Text(provider.errorMessage))
//           : ListView.builder(
//         itemCount: provider.companies.length,
//         itemBuilder: (context, index) {
//           final c = provider.companies[index];
//           return ListTile(
//             leading: c.companyLogo != null
//                 ? Image.network(
//               c.companyLogo!.url,
//               width: 50,
//               height: 50,
//               fit: BoxFit.cover,
//             )
//                 : const Icon(Icons.business),
//             title: Text(c.companyName),
//             subtitle: Text('${c.businessType} • ${c.city}'),
//             trailing: const Icon(Icons.arrow_forward_ios),
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) =>
//                       CompanyDetailScreen(company: c),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CompanyProvider>(context, listen: false).fetchCompanies();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CompanyProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Center(child: const Text('Customers List',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: (){
              Navigator.push(context,MaterialPageRoute(builder:(context)=>AddCustomerScreen()));
            }
          )
        ],
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.errorMessage.isNotEmpty
          ? Center(child: Text(provider.errorMessage))
          : ListView.builder(
        itemCount: provider.companies.length,
        itemBuilder: (context, index) {
          final c = provider.companies[index];
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
                leading: c.companyLogo != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    c.companyLogo!.url,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
                    : const Icon(Icons.business, size: 40),
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

                    // 🔴 Delete Button
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
    );
  }
}
