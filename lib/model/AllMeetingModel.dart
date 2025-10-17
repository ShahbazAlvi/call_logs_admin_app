// class NoDateMeetingModel {
//   final bool success;
//   final int count;
//   final List<MeetingData> data;
//
//   NoDateMeetingModel({
//     required this.success,
//     required this.count,
//     required this.data,
//   });
//
//   factory NoDateMeetingModel.fromJson(Map<String, dynamic> json) {
//     return NoDateMeetingModel(
//       success: json['success'] ?? false,
//       count: json['count'] ?? 0,
//       data: (json['data'] as List<dynamic>?)
//           ?.map((item) => MeetingData.fromJson(item))
//           .toList() ??
//           [],
//     );
//   }
// }
//
// class MeetingData {
//   final String? id;
//   final String? companyName;
//   final Person? person;
//   final Product? product;
//   final String? status;
//   final List<String> followDates;
//   final List<String> followTimes;
//   final List<dynamic> details;
//   final String? timeline;
//   final String? createdAt;
//   final String? updatedAt;
//
//   MeetingData({
//     this.id,
//     this.companyName,
//     this.person,
//     this.product,
//     this.status,
//     this.followDates = const [],
//     this.followTimes = const [],
//     this.details = const [],
//     this.timeline,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   factory MeetingData.fromJson(Map<String, dynamic> json) {
//     return MeetingData(
//       id: json['_id'],
//       companyName: json['companyName'],
//       person:
//       json['person'] != null ? Person.fromJson(json['person']) : null,
//       product:
//       json['product'] != null ? Product.fromJson(json['product']) : null,
//       status: json['status'],
//       followDates: List<String>.from(json['followDates'] ?? []),
//       followTimes: List<String>.from(json['followTimes'] ?? []),
//       details: List<dynamic>.from(json['details'] ?? []),
//       timeline: json['Timeline'],
//       createdAt: json['createdAt'],
//       updatedAt: json['updatedAt'],
//     );
//   }
// }
//
// class Person {
//   final String? id;
//   final String? companyName;
//   final List<PersonInfo> persons;
//   final AssignedProduct? assignedProducts;
//   final AssignedStaff? assignedStaff;
//
//   Person({
//     this.id,
//     this.companyName,
//     this.persons = const [],
//     this.assignedProducts,
//     this.assignedStaff,
//   });
//
//   factory Person.fromJson(Map<String, dynamic> json) {
//     return Person(
//       id: json['_id'],
//       companyName: json['companyName'],
//       persons: (json['persons'] as List<dynamic>?)
//           ?.map((e) => PersonInfo.fromJson(e))
//           .toList() ??
//           [],
//       assignedProducts: json['assignedProducts'] != null
//           ? AssignedProduct.fromJson(json['assignedProducts'])
//           : null,
//       assignedStaff: json['assignedStaff'] != null
//           ? AssignedStaff.fromJson(json['assignedStaff'])
//           : null,
//     );
//   }
// }
//
// class PersonInfo {
//   final String? fullName;
//   final String? phoneNumber;
//
//   PersonInfo({this.fullName, this.phoneNumber});
//
//   factory PersonInfo.fromJson(Map<String, dynamic> json) {
//     return PersonInfo(
//       fullName: json['fullName'],
//       phoneNumber: json['phoneNumber'],
//     );
//   }
// }
//
// class Product {
//   final String? id;
//   final String? name;
//   final int? price;
//
//   Product({this.id, this.name, this.price});
//
//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['_id'],
//       name: json['name'],
//       price: json['price'] is int ? json['price'] : int.tryParse("${json['price']}"),
//     );
//   }
// }
//
// class AssignedProduct {
//   final String? id;
//   final String? name;
//   final int? price;
//
//   AssignedProduct({this.id, this.name, this.price});
//
//   factory AssignedProduct.fromJson(Map<String, dynamic> json) {
//     return AssignedProduct(
//       id: json['_id'],
//       name: json['name'],
//       price: json['price'] is int ? json['price'] : int.tryParse("${json['price']}"),
//     );
//   }
// }
//
// class AssignedStaff {
//   final String? id;
//   final String? username;
//   final String? email;
//
//   AssignedStaff({this.id, this.username, this.email});
//
//   factory AssignedStaff.fromJson(Map<String, dynamic> json) {
//     return AssignedStaff(
//       id: json['_id'],
//       username: json['username'],
//       email: json['email'],
//     );
//   }
// }
class NoDateMeetingModel {
  final bool success;
  final int count;
  final List<MeetingData> data;

  NoDateMeetingModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory NoDateMeetingModel.fromJson(Map<String, dynamic> json) {
    return NoDateMeetingModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((item) => MeetingData.fromJson(item))
          .toList(),
    );
  }
}

class MeetingData {
  final String? id;
  final String? companyName;
  final Person? person;
  final Product? product;
  final String? status;
  final List<String> followDates;
  final List<String> followTimes;
  final List<dynamic> details;
  final String? timeline;
  final String? createdAt;
  final String? updatedAt;

  MeetingData({
    this.id,
    this.companyName,
    this.person,
    this.product,
    this.status,
    this.followDates = const [],
    this.followTimes = const [],
    this.details = const [],
    this.timeline,
    this.createdAt,
    this.updatedAt,
  });

  factory MeetingData.fromJson(Map<String, dynamic> json) {
    return MeetingData(
      id: json['_id'],
      companyName: json['companyName'],
      person:
      json['person'] != null ? Person.fromJson(json['person']) : null,
      product:
      json['product'] != null ? Product.fromJson(json['product']) : null,
      status: json['status'],
      followDates: List<String>.from(json['followDates'] ?? []),
      followTimes: List<String>.from(json['followTimes'] ?? []),
      details: List<dynamic>.from(json['details'] ?? []),
      timeline: json['Timeline'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }
}

class Person {
  final String? id;
  final String? companyName;
  final List<PersonInfo> persons;
  final AssignedProduct? assignedProducts;
  final AssignedStaff? assignedStaff;

  Person({
    this.id,
    this.companyName,
    this.persons = const [],
    this.assignedProducts,
    this.assignedStaff,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    // Handle both String and Map types for assignedProducts
    AssignedProduct? product;
    if (json['assignedProducts'] is Map<String, dynamic>) {
      product = AssignedProduct.fromJson(json['assignedProducts']);
    }

    return Person(
      id: json['_id'],
      companyName: json['companyName'],
      persons: (json['persons'] as List<dynamic>? ?? [])
          .map((e) => PersonInfo.fromJson(e))
          .toList(),
      assignedProducts: product,
      assignedStaff: json['assignedStaff'] != null
          ? AssignedStaff.fromJson(json['assignedStaff'])
          : null,
    );
  }
}

class PersonInfo {
  final String? fullName;
  final String? phoneNumber;

  PersonInfo({this.fullName, this.phoneNumber});

  factory PersonInfo.fromJson(Map<String, dynamic> json) {
    return PersonInfo(
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
    );
  }
}

class Product {
  final String? id;
  final String? name;
  final int? price;

  Product({this.id, this.name, this.price});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'],
      price: json['price'] is int
          ? json['price']
          : int.tryParse("${json['price']}"),
    );
  }
}

class AssignedProduct {
  final String? id;
  final String? name;
  final int? price;

  AssignedProduct({this.id, this.name, this.price});

  factory AssignedProduct.fromJson(Map<String, dynamic> json) {
    return AssignedProduct(
      id: json['_id'],
      name: json['name'],
      price: json['price'] is int
          ? json['price']
          : int.tryParse("${json['price']}"),
    );
  }
}

class AssignedStaff {
  final String? id;
  final String? username;
  final String? email;

  AssignedStaff({this.id, this.username, this.email});

  factory AssignedStaff.fromJson(Map<String, dynamic> json) {
    return AssignedStaff(
      id: json['_id'],
      username: json['username'],
      email: json['email'],
    );
  }
}
