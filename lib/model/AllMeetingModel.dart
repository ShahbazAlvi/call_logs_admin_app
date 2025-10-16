import 'dart:convert';

/// Top-level function to parse the API response
ApiResponse apiResponseFromJson(String str) =>
    ApiResponse.fromJson(json.decode(str));

/// ✅ Root model
class ApiResponse {
  final bool success;
  final int count;
  final List<Lead> data;

  ApiResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List?)
          ?.map((x) => Lead.fromJson(x as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    "success": success,
    "count": count,
    "data": data.map((x) => x.toJson()).toList(),
  };
}

/// ✅ Lead / Meeting model
class Lead {
  final String id;
  final String companyName;
  final Person? person;
  final Product? product;
  final String status;
  final List<String> followDates;
  final List<String> followTimes;
  final List<String> details;
  final String timeline;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int v;
  final String? action;
  final String? contactMethod;
  final String? designation;
  final Staff? referToStaff;
  final String? reference;

  Lead({
    required this.id,
    required this.companyName,
    required this.person,
    required this.product,
    required this.status,
    required this.followDates,
    required this.followTimes,
    required this.details,
    required this.timeline,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.action,
    this.contactMethod,
    this.designation,
    this.referToStaff,
    this.reference,
  });

  factory Lead.fromJson(Map<String, dynamic> json) {
    return Lead(
      id: json['_id'] ?? '',
      companyName: json['companyName'] ?? '',
      person: json['person'] != null
          ? Person.fromJson(json['person'] as Map<String, dynamic>)
          : null,
      product: json['product'] != null
          ? Product.fromJson(json['product'] as Map<String, dynamic>)
          : null,
      status: json['status'] ?? '',
      followDates: (json['followDates'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      followTimes: (json['followTimes'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      details:
      (json['details'] as List?)?.map((e) => e.toString()).toList() ?? [],
      timeline: json['Timeline'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
      v: json['__v'] ?? 0,
      action: json['action'],
      contactMethod: json['contactMethod'],
      designation: json['designation'],
      referToStaff: json['referToStaff'] != null
          ? Staff.fromJson(json['referToStaff'] as Map<String, dynamic>)
          : null,
      reference: json['reference'],
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "companyName": companyName,
    "person": person?.toJson(),
    "product": product?.toJson(),
    "status": status,
    "followDates": followDates,
    "followTimes": followTimes,
    "details": details,
    "Timeline": timeline,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "__v": v,
    "action": action,
    "contactMethod": contactMethod,
    "designation": designation,
    "referToStaff": referToStaff?.toJson(),
    "reference": reference,
  };
}

/// ✅ Person model
class Person {
  final String id;
  final String companyName;
  final List<ContactPerson> persons;
  final Product? assignedProducts;
  final Staff? assignedStaff;

  Person({
    required this.id,
    required this.companyName,
    required this.persons,
    this.assignedProducts,
    this.assignedStaff,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['_id'] ?? '',
      companyName: json['companyName'] ?? '',
      persons: (json['persons'] as List?)
          ?.map((x) => ContactPerson.fromJson(x as Map<String, dynamic>))
          .toList() ??
          [],
      assignedProducts: json['assignedProducts'] != null
          ? Product.fromJson(json['assignedProducts'] as Map<String, dynamic>)
          : null,
      assignedStaff: json['assignedStaff'] != null
          ? Staff.fromJson(json['assignedStaff'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "companyName": companyName,
    "persons": persons.map((x) => x.toJson()).toList(),
    "assignedProducts": assignedProducts?.toJson(),
    "assignedStaff": assignedStaff?.toJson(),
  };

  /// Fallback empty object to avoid null crashes
  factory Person.empty() => Person(
    id: '',
    companyName: '',
    persons: [],
    assignedProducts: null,
    assignedStaff: null,
  );
}

/// ✅ Contact Person model
class ContactPerson {
  final String fullName;
  final String phoneNumber;

  ContactPerson({
    required this.fullName,
    required this.phoneNumber,
  });

  factory ContactPerson.fromJson(Map<String, dynamic> json) {
    return ContactPerson(
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "phoneNumber": phoneNumber,
  };
}

/// ✅ Product model
class Product {
  final String id;
  final String name;
  final int price;

  Product({
    required this.id,
    required this.name,
    required this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] is int
          ? json['price']
          : int.tryParse(json['price'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "price": price,
  };
}

/// ✅ Staff model
class Staff {
  final String id;
  final String username;
  final String email;

  Staff({
    required this.id,
    required this.username,
    required this.email,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "_id": id,
    "username": username,
    "email": email,
  };
}
