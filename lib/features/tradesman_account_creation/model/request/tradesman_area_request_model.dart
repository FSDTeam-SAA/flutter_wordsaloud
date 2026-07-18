class TradesmanAreaRequestModel {
  final String homeArea;
  final String travelRange;

  TradesmanAreaRequestModel({
    required this.homeArea,
    required this.travelRange,
  });

  Map<String, dynamic> toJson() {
    return {
      'homeArea': homeArea,
      'travelRange': travelRange,
    };
  }
}