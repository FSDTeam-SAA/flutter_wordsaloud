import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class TellClientsController extends GetxController {
  final RxString pitch = ''.obs;
  final RxString rate = ''.obs;
  final RxString rateUnit = 'Per day'.obs;
  final RxList<XFile> workPhotos = <XFile>[].obs;

  final int maxPitchChars = 140;

  final List<String> rateUnits = const ['Per day', 'Per hour', 'Per job'];

  void onPitchChanged(String value) {
    if (value.length <= maxPitchChars) {
      pitch.value = value;
    }
  }

  void onRateChanged(String value) {
    rate.value = value;
  }

  void selectRateUnit(String value) {
    rateUnit.value = value;
  }

  Future<void> pickPhotos() async {
    final picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    if (images.isNotEmpty) {
      workPhotos.addAll(images);
    }
  }

  bool get canContinue => pitch.value.trim().isNotEmpty;

  void onContinuePressed() {
    // TODO: submit tradesman profile data
  }
}
