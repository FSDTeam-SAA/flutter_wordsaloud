import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:aturservicett/features/tradesman_account_creation/controller/tradesman_controller.dart';
import 'package:aturservicett/features/tradesman_account_creation/model/response/get_skill_listed_count_response_model.dart';

class TradeOption {
  final String name;
  final String? icon;
  final bool isNew;

  const TradeOption({required this.name, this.icon, this.isNew = false});
}

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

  final RxBool isLoadingTradeCategories = false.obs;
  final RxList<TradeOption> availableTradeOptions = <TradeOption>[
    ..._fallbackTradeOptions,
  ].obs;

  static const List<TradeOption> _fallbackTradeOptions = [
    TradeOption(name: 'Phone Tech'),
    TradeOption(name: 'Computer Tech'),
    TradeOption(name: 'Plumber'),
    TradeOption(name: 'Electrician'),
    TradeOption(name: 'Appliance Fix'),
    TradeOption(name: 'Joinery'),
    TradeOption(name: 'AC Tech'),
    TradeOption(name: 'Painter'),
    TradeOption(name: 'Maid Service'),
    TradeOption(name: 'Caterer'),
    TradeOption(name: 'Tile Men'),
    TradeOption(name: 'Glass Men'),
    TradeOption(name: 'Mason'),
    TradeOption(name: 'Carpenter'),
    TradeOption(name: 'Fabricator/Welder'),
    TradeOption(name: 'Pool Cleaner'),
    TradeOption(name: 'Tree Cutter'),
    TradeOption(name: 'Landscaper'),
    TradeOption(name: 'Roofer'),
    TradeOption(name: 'Mechanic'),
    TradeOption(name: 'Auto Body'),
    TradeOption(name: 'Contractor'),
  ];

  List<String> get availableTrades =>
      availableTradeOptions.map((trade) => trade.name).toList();

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

  Future<void> loadAvailableTradesFromApi() async {
    if (!Get.isRegistered<TradesmanController>()) return;
    if (isLoadingTradeCategories.value) return;

    isLoadingTradeCategories.value = true;
    try {
      final skills = await Get.find<TradesmanController>().fetchSkillList();
      setAvailableTradeCategories(skills);
    } finally {
      isLoadingTradeCategories.value = false;
    }
  }

  void setAvailableTradeCategories(List<SkillModel> skills) {
    if (skills.isEmpty) return;

    final options = <TradeOption>[];
    final seenTradeKeys = <String>{};

    void addOption(TradeOption option) {
      final name = _displayTradeName(option.name);
      if (name.isEmpty) return;
      if (!seenTradeKeys.add(_tradeKey(name))) return;

      options.add(
        TradeOption(name: name, icon: option.icon, isNew: option.isNew),
      );
    }

    for (final skill in skills) {
      final name = skill.skill?.trim();
      if (name == null || name.isEmpty) continue;
      addOption(
        TradeOption(
          name: name,
          icon: skill.icon?.trim().isNotEmpty == true
              ? skill.icon!.trim()
              : null,
          isNew: skill.isNew,
        ),
      );
    }

    for (final option in _fallbackTradeOptions) {
      addOption(option);
    }

    if (options.isNotEmpty) {
      availableTradeOptions.assignAll(options);
    }
  }

  // Filter out already selected trades for the "Add Trade" dialog
  List<TradeOption> get remainingTradeOptions {
    return availableTradeOptions.where((trade) {
      return !_isSelectedTrade(trade.name);
    }).toList();
  }

  List<String> get remainingTrades {
    return remainingTradeOptions.map((trade) => trade.name).toList();
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
