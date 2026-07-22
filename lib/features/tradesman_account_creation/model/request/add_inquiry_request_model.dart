class AddInquiryRequestModel {
  final String businessName;
  final String whatsappPhone;
  final List<String> tradesToAdvertiseTo;

  AddInquiryRequestModel({
    required this.businessName,
    required this.whatsappPhone,
    required this.tradesToAdvertiseTo,
  });

  Map<String, dynamic> toJson() {
    return {
      'businessName': businessName,
      'whatsappPhone': whatsappPhone,
      'tradesToAdvertiseTo': tradesToAdvertiseTo,
    };
  }
}