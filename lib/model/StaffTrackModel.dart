class StaffTrackModel {
  final bool? success;
  final int? count;
  final List<User>? users;

  StaffTrackModel({
    this.success,
    this.count,
    this.users,
  });

  factory StaffTrackModel.fromJson(Map<String, dynamic> json) {
    return StaffTrackModel(
      success: json['success'] as bool?,
      count: json['count'] as int?,
      users: (json['users'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'count': count,
      'users': users?.map((e) => e.toJson()).toList(),
    };
  }
}

class User {
  final String? username;
  final String? phone;
  final String? status;
  final String? lastLoginAt;
  final String? lastLogoutAt;
  final int? totalLogins;
  final List<LoginHistory>? loginHistory;

  User({
    this.username,
    this.phone,
    this.status,
    this.lastLoginAt,
    this.lastLogoutAt,
    this.totalLogins,
    this.loginHistory,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] as String?,
      phone: json['phone'] as String?,
      status: json['status'] as String?,
      lastLoginAt: json['lastLoginAt'] as String?,
      lastLogoutAt: json['lastLogoutAt'] as String?,
      totalLogins: json['totalLogins'] as int?,
      loginHistory: (json['loginHistory'] as List<dynamic>?)
          ?.map((e) => LoginHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'phone': phone,
      'status': status,
      'lastLoginAt': lastLoginAt,
      'lastLogoutAt': lastLogoutAt,
      'totalLogins': totalLogins,
      'loginHistory': loginHistory?.map((e) => e.toJson()).toList(),
    };
  }
}

class LoginHistory {
  final String? loginAt;
  final String? logoutAt;
  final String? ipAddress;
  final String? userAgent;

  LoginHistory({
    this.loginAt,
    this.logoutAt,
    this.ipAddress,
    this.userAgent,
  });

  factory LoginHistory.fromJson(Map<String, dynamic> json) {
    return LoginHistory(
      loginAt: json['loginAt'] as String?,
      logoutAt: json['logoutAt'] as String?,
      ipAddress: json['ipAddress'] as String?,
      userAgent: json['userAgent'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'loginAt': loginAt,
      'logoutAt': logoutAt,
      'ipAddress': ipAddress,
      'userAgent': userAgent,
    };
  }
}
