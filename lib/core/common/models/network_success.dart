// lib/core/network/models/network_success.dart
import 'package:equatable/equatable.dart';

import 'pagination_model.dart';

class NetworkSuccess<T> extends Equatable {
  final T data;
  final String message;
  final int statusCode;
  final PaginationModel? pagination;
  final Map<String, dynamic>? meta;

  final bool isFromCache;

  const NetworkSuccess({
    required this.data,
    required this.message,
    required this.statusCode,
    this.pagination,
    this.meta,
    this.isFromCache = false,
  });

  @override
  List<Object?> get props => [
    data,
    message,
    statusCode,
    pagination,
    meta,
    isFromCache,
  ];
}

class ServerSuccess<T> extends NetworkSuccess<T> {
  const ServerSuccess({
    required super.data,
    required super.message,
    required super.statusCode,
    super.meta,
    super.pagination,
    super.isFromCache = false,
  });
}

class CreatedSuccess<T> extends NetworkSuccess<T> {
  const CreatedSuccess({
    required super.data,
    required super.message,
    super.statusCode = 201,
    super.meta,
    super.pagination,
    super.isFromCache = false,
  });
}

class UpdatedSuccess<T> extends NetworkSuccess<T> {
  const UpdatedSuccess({
    required super.data,
    required super.message,
    super.statusCode = 200,
    super.meta,
    super.pagination,
    super.isFromCache = false,
  });
}

class DeletedSuccess extends NetworkSuccess<void> {
  const DeletedSuccess({
    required super.message,
    super.statusCode = 204,
    super.meta,
    super.pagination,
    super.isFromCache = false,
  }) : super(data: null);
}

class RetrievedSuccess<T> extends NetworkSuccess<T> {
  const RetrievedSuccess({
    required super.data,
    required super.message,
    super.statusCode = 200,
    super.meta,
    super.pagination,
    super.isFromCache = false,
  });
}
