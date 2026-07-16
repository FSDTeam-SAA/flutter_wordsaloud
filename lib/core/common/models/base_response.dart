// lib/core/network/models/base_response.dart

import 'error_source.dart';
import 'pagination_model.dart';

class BaseResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final List<ErrorSource>? errorSources;
  final PaginationModel? pagination;
  final Map<String, dynamic>? meta;

  BaseResponse({
    required this.success,
    required this.message,
    this.data,
    this.errorSources,
    this.pagination,
    this.meta,
  });

  factory BaseResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return BaseResponse<T>(
      success: json['success'] ?? json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      errorSources: json['errorSources'] != null
          ? (json['errorSources'] as List)
                .map((e) => ErrorSource.fromJson(e))
                .toList()
          : null,
      pagination: json['pagination'] != null
          ? PaginationModel.fromJson(json['pagination'])
          : null,
      meta: json['meta'],
    );
  }

  String get combinedErrorMessage {
    if (errorSources == null || errorSources!.isEmpty) return message;
    return errorSources!.map((e) => e.message).join('\n');
  }
}
