import 'package:get/get.dart';

class ClientProfileController extends GetxController {
  final name = 'Keisha P.'.obs;
  final phone = '+1 868 754-2288'.obs;
  final area = 'Chaguanas'.obs;
  final RxnString profileImagePath = RxnString();

  void updateProfile({
    required String name,
    required String phone,
    required String area,
    String? profileImagePath,
  }) {
    this.name.value = name;
    this.phone.value = phone;
    this.area.value = area;
    this.profileImagePath.value = profileImagePath;
  }

  String get initial {
    final trimmedName = name.value.trim();
    if (trimmedName.isEmpty) return 'U';
    return trimmedName.substring(0, 1).toUpperCase();
  }
}
