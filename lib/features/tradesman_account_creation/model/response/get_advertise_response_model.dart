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
  final String mediaUrl;
  final String mediaType;
  final String createdBy;
  final List<String> categories;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  Advertisement({
    required this.id,
    required this.title,
    required this.description,
    required this.mediaUrl,
    required this.mediaType,
    required this.createdBy,
    required this.categories,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Advertisement.fromJson(Map<String, dynamic> json) {
    final media = json['media'];
    final mediaJson = media is Map<String, dynamic> ? media : null;
    final image = json['image'];
    final imageJson = image is Map<String, dynamic> ? image : null;
    final video = json['video'];
    final videoJson = video is Map<String, dynamic> ? video : null;
    final mediaUrl = _firstString([
      json['mediaUrl'],
      json['assetUrl'],
      json['fileUrl'],
      json['imageUrl'],
      json['videoUrl'],
      mediaJson?['url'],
      mediaJson?['secureUrl'],
      mediaJson?['src'],
      imageJson?['url'],
      imageJson?['secureUrl'],
      videoJson?['url'],
      videoJson?['secureUrl'],
    ]);
    final rawMediaType = _firstString([
      json['mediaType'],
      json['contentType'],
      json['mimeType'],
      mediaJson?['type'],
      mediaJson?['mimeType'],
    ]);

    return Advertisement(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      mediaUrl: mediaUrl,
      mediaType: _normalizeMediaType(rawMediaType, mediaUrl),
      createdBy: json['createdBy']?.toString() ?? '',
      categories: _stringListFromAny(json['categories']),
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
      'mediaUrl': mediaUrl,
      'mediaType': mediaType,
      'createdBy': createdBy,
      'categories': categories,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static String _firstString(List<dynamic> values) {
    for (final value in values) {
      final text = value?.toString().trim() ?? '';
      if (text.isNotEmpty) return text;
    }
    return '';
  }

  static List<String> _stringListFromAny(dynamic value) {
    if (value is List) {
      return value
          .map((item) => item?.toString().trim() ?? '')
          .where((item) => item.isNotEmpty)
          .toList();
    }

    final text = value?.toString().trim() ?? '';
    if (text.isEmpty) return const [];
    return text
        .split(',')
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }

  static String _normalizeMediaType(String value, String url) {
    final type = value.trim().toLowerCase();
    final lowerUrl = url.trim().toLowerCase();
    if (type.contains('video') || lowerUrl.endsWith('.mp4')) return 'video';
    if (type.contains('image') ||
        lowerUrl.endsWith('.jpg') ||
        lowerUrl.endsWith('.jpeg') ||
        lowerUrl.endsWith('.png')) {
      return 'image';
    }
    return '';
  }
}
