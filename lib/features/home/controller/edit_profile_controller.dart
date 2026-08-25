import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileController extends GetxController {
  final String initialName;
  final String initialPhone;

  // Editable Rx variables
  final RxString pitch = ''.obs;
  final RxString rate = ''.obs;
  final RxString rateUnit = 'Per day'.obs;

  final RxString mainTrade = ''.obs;
  final RxList<String> extraTrades = <String>[].obs;

  final RxString homeArea = ''.obs;
  final RxString travelRange =
      'Trinidad wide'.obs; // matches screenshot selected option
  final RxnString profileImagePath = RxnString();

  // All available trades/skills in the application
  final List<String> availableTrades = const [
    'Phone Tech',
    'Computer Tech',
    'Plumber',
    'Electrician',
    'Appliance Fix',
    'Joinery',
    'AC Tech',
    'Painter',
    'Maid Service',
    'Caterer',
    'Tile Man',
    'Glass Man',
    'Mason',
    'Carpenter',
    'Fabricator/Welder',
    'Pool Cleaner',
    'Tree Cutter',
    'Landscaper',
    'Roofer',
    'Mechanic',
    'Auto Body',
    'Contractor',
  ];

  EditProfileController({
    required this.initialName,
    required this.initialPhone,
    String initialPitch = '',
    String initialRate = '',
    String initialRateUnit = 'Per day',
    String initialMainTrade = '',
    List<String> initialExtraTrades = const [],
    String initialHomeArea = '',
    String initialTravelRange = 'Trinidad wide',
    String? initialProfileImagePath,
  }) {
    pitch.value = initialPitch;
    rate.value = initialRate;
    rateUnit.value = initialRateUnit;
    mainTrade.value = _displayTradeName(initialMainTrade);
    for (final trade in initialExtraTrades.map(_displayTradeName)) {
      if (trade.isNotEmpty && !_isSelectedTrade(trade)) {
        extraTrades.add(trade);
      }
    }
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
    if (_sameTrade(mainTrade.value, tradeName)) {
      if (extraTrades.isNotEmpty) {
        mainTrade.value = extraTrades.first;
        extraTrades.removeAt(0);
      } else {
        mainTrade.value = '';
      }
    } else {
      extraTrades.removeWhere((trade) => _sameTrade(trade, tradeName));
    }
  }

  // Add a trade to selections
  void addTrade(String tradeName) {
    final normalizedTrade = _displayTradeName(tradeName);
    if (normalizedTrade.isEmpty || _isSelectedTrade(normalizedTrade)) return;

    if (mainTrade.isEmpty) {
      mainTrade.value = normalizedTrade;
      return;
    }

    extraTrades.add(normalizedTrade);
  }

  // Filter out already selected trades for the "Add Trade" dialog
  List<String> get remainingTrades {
    return availableTrades.where((trade) {
      return !_isSelectedTrade(trade);
    }).toList();
  }

  String _displayTradeName(String tradeName) {
    final value = tradeName.trim();
    if (value.isEmpty) return '';

    for (final trade in availableTrades) {
      if (_sameTrade(trade, value)) return trade;
    }

    return value;
  }

  bool _isSelectedTrade(String tradeName) {
    return _sameTrade(mainTrade.value, tradeName) ||
        extraTrades.any((trade) => _sameTrade(trade, tradeName));
  }

  bool _sameTrade(String first, String second) {
    return _tradeKey(first) == _tradeKey(second);
  }

  String _tradeKey(String tradeName) {
    final value = tradeName.trim().toLowerCase();
    switch (value) {
      case 'appliance':
      case 'appliance fix':
        return 'appliance';
      case 'fabricator/welder':
      case 'welder/gate':
        return 'welder';
      // case 'mechanic':
      //   return 'mechanic';
      default:
        return value;
    }
  }
}
