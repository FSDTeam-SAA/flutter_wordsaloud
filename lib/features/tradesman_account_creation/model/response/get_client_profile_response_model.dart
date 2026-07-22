class GetClientProfileResponseModel {
  final String? id;
  final String? email;
  final String? role;
  final String? area;
  final bool? isEmailVerified;
  final bool? isProfileComplete;
  final bool? isBlocked;
  final String? createdAt;
  final String? updatedAt;
  final int? v;
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? name;
  final ProfileImage? profileImage;

  GetClientProfileResponseModel({
    this.id,
    this.email,
    this.role,
    this.area,
    this.isEmailVerified,
    this.isProfileComplete,
    this.isBlocked,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.name,
    this.profileImage,
  });

  factory GetClientProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return GetClientProfileResponseModel(
      id: json['_id'],
      email: json['email'],
      role: json['role'],
      area: json['area'],
      isEmailVerified: json['isEmailVerified'],
      isProfileComplete: json['isProfileComplete'],
      isBlocked: json['isBlocked'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      name: json['name'],
      profileImage: json['profileImage'] != null
          ? ProfileImage.fromJson(json['profileImage'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'role': role,
      'area': area,
      'isEmailVerified': isEmailVerified,
      'isProfileComplete': isProfileComplete,
      'isBlocked': isBlocked,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'name': name,
      'profileImage': profileImage?.toJson(),
    };
  }
}

class ProfileImage {
  final String? publicId;
  final String? url;

  ProfileImage({this.publicId, this.url});

  factory ProfileImage.fromJson(Map<String, dynamic> json) {
    return ProfileImage(publicId: json['public_id'], url: json['url']);
  }

  Map<String, dynamic> toJson() {
    return {'public_id': publicId, 'url': url};
  }
}
