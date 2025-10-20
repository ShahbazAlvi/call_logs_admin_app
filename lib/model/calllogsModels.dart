class CallLogsModel {
  final bool success;
  final int count;
  final List<CallLogData> data;

  CallLogsModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory CallLogsModel.fromJson(Map<String, dynamic> json) {
    return CallLogsModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((v) => CallLogData.fromJson(v))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'success': success,
    'count': count,
    'data': data.map((v) => v.toJson()).toList(),
  };
}

class CallLogData {
  final String id;
  final String customerName;
  final String phoneNumber;
  final String staffName;
  final String date;
  final String time;
  final String mode;
  final String location;
  final String createdAt;
  final String updatedAt;
  final int v;

  CallLogData({
    required this.id,
    required this.customerName,
    required this.phoneNumber,
    required this.staffName,
    required this.date,
    required this.time,
    required this.mode,
    required this.location,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory CallLogData.fromJson(Map<String, dynamic> json) {
    return CallLogData(
      id: json['_id'] ?? '',
      customerName: json['customerName'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      staffName: json['staffName'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
      mode: json['mode'] ?? '',
      location: json['location'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      v: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'customerName': customerName,
    'phoneNumber': phoneNumber,
    'staffName': staffName,
    'date': date,
    'time': time,
    'mode': mode,
    'location': location,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
    '__v': v,
  };
}
