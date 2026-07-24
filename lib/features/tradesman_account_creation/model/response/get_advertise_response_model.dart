class GetAdvertiseResponseModel {
  final List<Advertisement> data;

  GetAdvertiseResponseModel({required this.data});

  factory GetAdvertiseResponseModel.fromData(dynamic json) {
    final rawData = json is Map<String, dynamic> ? json['data'] : json;
    final data = rawData is List ? rawData : const [];

    return GetAdvertiseResponseModel(
      data: data
          .whereType<Map<String, dynamic>>()
          .map(Advertisement.fromJson)
          .toList(),
    );
  }

  factory GetAdvertiseResponseModel.fromJson(List<dynamic> json) =>
      GetAdvertiseResponseModel.fromData(json);

  List<Map<String, dynamic>> toJson() {
    return data.map((e) => e.toJson()).toList();
  }
}

class Advertisement {
  final String id;
  final String title;
  final String description;
  final String createdBy;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Advertisement({
    required this.id,
    required this.title,
    required this.description,
    required this.createdBy,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Advertisement.fromJson(Map<String, dynamic> json) {
    return Advertisement(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      createdBy: json['createdBy']?.toString() ?? '',
      isActive: json['isActive'] == true,
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt:
          DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'createdBy': createdBy,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
