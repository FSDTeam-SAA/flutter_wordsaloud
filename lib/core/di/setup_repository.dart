import 'package:get/get.dart';

import '../../features/auth/repositories/auth_repo.dart';
import '../../features/auth/repositories/auth_repo_impl.dart';
import '../network/api_client.dart';
import '../utils/getx_helper.dart';

void setupRepository() {
  Get.getOrPutLazy<AuthRepository>(
    () => AuthRepositoryImpl(apiClient: Get.find<ApiClient>()),
    fenix: true,
  );
}
