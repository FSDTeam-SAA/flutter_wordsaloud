import 'dart:convert';

class OfflineTaskModel {
  final String id;
  final String type;
  final Map<String, dynamic> payload;
  final DateTime createdAt;
  final int retryCount;

  OfflineTaskModel({
    required this.id,
    required this.type,
    required this.payload,
    required this.createdAt,
    this.retryCount = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'payload': payload,
      'createdAt': createdAt.toIso8601String(),
      'retryCount': retryCount,
    };
  }

  factory OfflineTaskModel.fromMap(Map<String, dynamic> map) {
    return OfflineTaskModel(
      id: map['id'] as String,
      type: map['type'] as String,
      payload: Map<String, dynamic>.from(map['payload'] as Map),
      createdAt: DateTime.parse(map['createdAt'] as String),
      retryCount: map['retryCount'] as int? ?? 0,
    );
  }

  String toJson() => jsonEncode(toMap());

  factory OfflineTaskModel.fromJson(String source) => 
      OfflineTaskModel.fromMap(jsonDecode(source) as Map<String, dynamic>);
  
  OfflineTaskModel copyWith({
    String? id,
    String? type,
    Map<String, dynamic>? payload,
    DateTime? createdAt,
    int? retryCount,
  }) {
    return OfflineTaskModel(
      id: id ?? this.id,
      type: type ?? this.type,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      retryCount: retryCount ?? this.retryCount,
    );
  }
}
