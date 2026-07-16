class RegisterResponseModel {
  final UserData? data;

  RegisterResponseModel({
    this.data,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      data: json['data'] != null
          ? UserData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': data?.toJson(),
    };
  }
}

class UserData {
  final String? id;
  final String? name;
  final String? email;
  final String? role;
  final String? area;

  UserData({
    this.id,
    this.name,
    this.email,
    this.role,
    this.area,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['_id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      area: json['area'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'area': area,
    };
  }
}