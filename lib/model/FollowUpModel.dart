class FollowUpResponse {
  final bool success;
  final int count;
  final List<FollowUpData> data;

  FollowUpResponse({
    required this.success,
    required this.count,
    required this.data,
  });

  factory FollowUpResponse.fromJson(Map<String, dynamic> json) {
    return FollowUpResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => FollowUpData.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'count': count,
    'data': data.map((e) => e.toJson()).toList(),
  };
}

class FollowUpData {
  final String id;
  final String companyName;
  final Person? person;
  final Product? product;
  final String status;
  final List<String> followDates;
  final List<String> followTimes;
  final List<String> details;
  final String timeline;
  final String createdAt;
  final String updatedAt;
  final String? action;
  final String? contactMethod;
  final String? designation;
  final String? referToStaff;
  final String? reference;

  FollowUpData({
    required this.id,
    required this.companyName,
    this.person,
    this.product,
    required this.status,
    required this.followDates,
    required this.followTimes,
    required this.details,
    required this.timeline,
    required this.createdAt,
    required this.updatedAt,
    this.action,
    this.contactMethod,
    this.designation,
    this.referToStaff,
    this.reference,
  });

  factory FollowUpData.fromJson(Map<String, dynamic> json) {
    return FollowUpData(
      id: json['_id'] ?? '',
      companyName: json['companyName'] ?? '',
      person: json['person'] != null ? Person.fromJson(json['person']) : null,
      product:
      json['product'] != null ? Product.fromJson(json['product']) : null,
      status: json['status'] ?? '',
      followDates:
      (json['followDates'] as List?)?.map((e) => e.toString()).toList() ??
          [],
      followTimes:
      (json['followTimes'] as List?)?.map((e) => e.toString()).toList() ??
          [],
      details:
      (json['details'] as List?)?.map((e) => e.toString()).toList() ?? [],
      timeline: json['Timeline'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      action: json['action'],
      contactMethod: json['contactMethod'],
      designation: json['designation'],
      referToStaff: json['referToStaff'],
      reference: json['reference'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'companyName': companyName,
    'person': person?.toJson(),
    'product': product?.toJson(),
    'status': status,
    'followDates': followDates,
    'followTimes': followTimes,
    'details': details,
    'Timeline': timeline,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    'action': action,
    'contactMethod': contactMethod,
    'designation': designation,
    'referToStaff': referToStaff,
    'reference': reference,
  };
}

class Person {
  final String id;
  final String companyName;
  final List<PersonDetail> persons;
  final AssignedStaff? assignedStaff;
  final Product? assignedProducts;

  Person({
    required this.id,
    required this.companyName,
    required this.persons,
    this.assignedStaff,
    this.assignedProducts,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['_id'] ?? '',
      companyName: json['companyName'] ?? '',
      persons: (json['persons'] as List?)
          ?.map((e) => PersonDetail.fromJson(e))
          .toList() ??
          [],
      assignedStaff: json['assignedStaff'] != null
          ? AssignedStaff.fromJson(json['assignedStaff'])
          : null,
      assignedProducts: json['assignedProducts'] != null
          ? Product.fromJson(json['assignedProducts'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'companyName': companyName,
    'persons': persons.map((e) => e.toJson()).toList(),
    'assignedStaff': assignedStaff?.toJson(),
    'assignedProducts': assignedProducts?.toJson(),
  };
}

class PersonDetail {
  final String fullName;
  final String phoneNumber;

  PersonDetail({
    required this.fullName,
    required this.phoneNumber,
  });

  factory PersonDetail.fromJson(Map<String, dynamic> json) {
    return PersonDetail(
      fullName: json['fullName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'fullName': fullName,
    'phoneNumber': phoneNumber,
  };
}

class AssignedStaff {
  final String id;
  final String username;
  final String email;

  AssignedStaff({
    required this.id,
    required this.username,
    required this.email,
  });

  factory AssignedStaff.fromJson(Map<String, dynamic> json) {
    return AssignedStaff(
      id: json['_id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'username': username,
    'email': email,
  };
}

class Product {
  final String id;
  final String name;
  final num? price;

  Product({
    required this.id,
    required this.name,
    this.price,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'price': price,
  };
}
