class CustomersTrackModel {
  final bool success;
  final int count;
  final List<CustomerData> data;

  CustomersTrackModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory CustomersTrackModel.fromJson(Map<String, dynamic> json) {
    return CustomersTrackModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => CustomerData.fromJson(item))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'count': count,
      'data': data.map((x) => x.toJson()).toList(),
    };
  }
}

class CustomerData {
  final String businessType;
  final String company;
  final String city;
  final String phoneNumber;
  final String person;
  final String designation;
  final String department;
  final String staff;
  final String product;
  final String action;
  final DateTime date;

  CustomerData({
    required this.businessType,
    required this.company,
    required this.city,
    required this.phoneNumber,
    required this.person,
    required this.designation,
    required this.department,
    required this.staff,
    required this.product,
    required this.action,
    required this.date,
  });

  factory CustomerData.fromJson(Map<String, dynamic> json) {
    return CustomerData(
      businessType: json['businessType']?.toString().trim() ?? '',
      company: json['company']?.toString().trim() ?? '',
      city: json['city']?.toString().trim() ?? '',
      phoneNumber: json['phoneNumber']?.toString().trim() ?? '',
      person: json['person']?.toString().trim() ?? '',
      designation: json['designation']?.toString().trim() ?? '',
      department: json['department']?.toString().trim() ?? '',
      staff: json['staff']?.toString().trim() ?? '',
      product: json['product']?.toString().trim() ?? '',
      action: json['action']?.toString().trim() ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'businessType': businessType,
      'company': company,
      'city': city,
      'phoneNumber': phoneNumber,
      'person': person,
      'designation': designation,
      'department': department,
      'staff': staff,
      'product': product,
      'action': action,
      'date': date.toIso8601String(),
    };
  }
}
