import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  final String initialName;
  final String initialPhone;

  // Editable Rx variables
  final RxString pitch = ''.obs;
  final RxString rate = ''.obs;
  final RxString rateUnit = 'per day'.obs;
  
  final RxString mainTrade = ''.obs;
  final RxList<String> extraTrades = <String>[].obs;
  
  final RxString homeArea = ''.obs;
  final RxString travelRange = 'Trinidad-wide'.obs; // matches screenshot selected option
  final RxnString profileImagePath = RxnString();

  // All available trades/skills in the application
  final List<String> availableTrades = const [
    'Phone Tech',
    'Computer Tech',
    'Plumber',
    'Electrician',
    'Carpenter',
    'Joinery',
    'Mobile Mech',
    'Painter',
    'Appliance',
    'AC Tech',
    'Tile Man',
    'Mason',
    'Glass Man',
    'Roofer',
    'Welder/Gate',
    'Pool Cleaner',
    'Tree Cutter',
    'Landscaper',
    'Auto Body',
    'Contractor',
  ];

  EditProfileController({
    required this.initialName,
    required this.initialPhone,
    String initialPitch = '',
    String initialRate = '',
    String initialRateUnit = 'per day',
    String initialMainTrade = '',
    List<String> initialExtraTrades = const [],
    String initialHomeArea = '',
    String initialTravelRange = 'Trinidad-wide',
    String? initialProfileImagePath,
  }) {
    pitch.value = initialPitch;
    rate.value = initialRate;
    rateUnit.value = initialRateUnit;
    mainTrade.value = initialMainTrade;
    extraTrades.addAll(initialExtraTrades);
    homeArea.value = initialHomeArea;
    travelRange.value = initialTravelRange;
    profileImagePath.value = initialProfileImagePath;
  }

  // Pick/Change profile heading photo
  Future<void> pickProfilePhoto() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (image != null) {
        profileImagePath.value = image.path;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }

  // Remove a trade from selections
  void removeTrade(String tradeName) {
    if (mainTrade.value == tradeName) {
      if (extraTrades.isNotEmpty) {
        mainTrade.value = extraTrades.first;
        extraTrades.removeAt(0);
      } else {
        mainTrade.value = '';
      }
    } else {
      extraTrades.remove(tradeName);
    }
  }

  // Add a trade to selections
  void addTrade(String tradeName) {
    if (mainTrade.isEmpty) {
      mainTrade.value = tradeName;
    } else {
      extraTrades.add(tradeName);
    }
  }

  // Filter out already selected trades for the "Add Trade" dialog
  List<String> get remainingTrades {
    return availableTrades.where((trade) {
      return mainTrade.value != trade && !extraTrades.contains(trade);
    }).toList();
  }
}
