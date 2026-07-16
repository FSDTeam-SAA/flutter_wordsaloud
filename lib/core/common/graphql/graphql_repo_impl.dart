// import 'package:flutter_tbzwa/core/common/graphql/graphql_repo.dart';
//
// import '../../api/graphql_client.dart';
// import '../../api/network_result.dart';
//
// class GraphqlRepoImpl implements GraphqlRepo {
//   final GraphQLClientService _graphQLClientService;
//
//   GraphqlRepoImpl({required GraphQLClientService graphQLClientService})
//     : _graphQLClientService = graphQLClientService;
//
//   @override
//   NetworkResult<T> query<T>({
//     required String document,
//     required T Function(dynamic) fromJsonT,
//   }) {
//     return _graphQLClientService.query(
//       document: document,
//       fromJsonT: fromJsonT,
//     );
//   }
//
//   @override
//   NetworkResult<T> mutation<T>({
//     required String document,
//     required T Function(dynamic) fromJsonT,
//     Map<String, dynamic> variables = const {},
//   }) {
//     return _graphQLClientService.mutate(
//       document: document,
//       fromJsonT: fromJsonT,
//       variables: variables,
//     );
//   }
// }
