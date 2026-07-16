import '../../api/network_result.dart';

abstract class GraphqlRepo {
  NetworkResult<T> query<T>({
    required String document,
    required T Function(dynamic) fromJsonT,
  });

  NetworkResult<T> mutation<T>({
    required String document,
    required T Function(dynamic) fromJsonT,
    Map<String, dynamic> variables = const {},
  });
}