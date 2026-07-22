class AddInquiryResponseModel {
  final String? user;
  final String? businessName;
  final String? whatsappPhone;
  final List<String>? tradesToAdvertiseTo;
  final String? status;
  final String? id;
  final String? createdAt;
  final String? updatedAt;
  final int? v;

  AddInquiryResponseModel({
    this.user,
    this.businessName,
    this.whatsappPhone,
    this.tradesToAdvertiseTo,
    this.status,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory AddInquiryResponseModel.fromJson(Map<String, dynamic> json) {
    return AddInquiryResponseModel(
      user: json['user'],
      businessName: json['businessName'],
      whatsappPhone: json['whatsappPhone'],
      tradesToAdvertiseTo: json['tradesToAdvertiseTo'] != null
          ? List<String>.from(json['tradesToAdvertiseTo'])
          : [],
      status: json['status'],
      id: json['_id'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'businessName': businessName,
      'whatsappPhone': whatsappPhone,
      'tradesToAdvertiseTo': tradesToAdvertiseTo,
      'status': status,
      '_id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': v,
    };
  }
}