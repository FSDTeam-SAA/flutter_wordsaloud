import 'package:dartz/dartz.dart';

import '../common/models/network_failure.dart';
import '../common/models/network_success.dart';

typedef NetworkResult<T> = Future<Either<NetworkFailure, NetworkSuccess<T>>>;
