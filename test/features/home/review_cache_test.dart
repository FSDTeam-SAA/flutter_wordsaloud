import 'package:aturservicett/core/network/api_client.dart';
import 'package:aturservicett/core/network/interceptor/custom_cache_interceptor.dart';
import 'package:aturservicett/core/network/models/network_failure.dart';
import 'package:aturservicett/core/network/models/network_success.dart';
import 'package:aturservicett/core/network/network_result.dart';
import 'package:aturservicett/features/tradesman_account_creation/repositories/tradesman_repo_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class _RecordingApiClient implements ApiClient {
  final requests = <Options?>[];

  @override
  NetworkResult<T> get<T>({
    required String endpoint,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic) fromJsonT,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    requests.add(options);
    return Left<NetworkFailure, NetworkSuccess<T>>(
      const UnknownFailure(message: 'No network in this test'),
    );
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test(
    'customer profiles, browse counts and dashboard always bypass old cache',
    () async {
      final client = _RecordingApiClient();
      final repo = TradesmanRepositoryImpl(apiClient: client);
      await repo.getSpecifiedTradesman('profile-id', skill: 'Plumber');
      await repo.getSpecifiedTradesman('profile-id', skill: 'Plumber');
      await repo.getTradesman(skill: 'Plumber');
      await repo.dashboard();
      expect(client.requests, hasLength(4));
      for (final options in client.requests) {
        expect(options?.extra?[CustomCacheInterceptor.skipCacheKey], isTrue);
        expect(options?.headers?['Cache-Control'], contains('no-store'));
      }
    },
  );
}
