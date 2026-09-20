import 'package:get/get.dart';
import 'package:aturservicett/features/tradesman_account_creation/controller/tradesman_controller.dart';
import 'package:aturservicett/features/tradesman_account_creation/model/response/get_all_tradesman_response_model.dart';
import 'package:aturservicett/features/tradesman_account_creation/model/response/get_skill_listed_count_response_model.dart';

class TradeCategory {
  final String name;
  final String image;
  final bool isNew;
  final bool isVip;
  final int listed;

  const TradeCategory({
    required this.name,
    required this.image,
    this.isNew = false,
    this.isVip = false,
    this.listed = 0,
  });
}

class HomeController extends GetxController {
  final List<TradeCategory> _fallbackCategories = const [
    TradeCategory(name: 'Phone Tech', image: 'assets/images/fi_5060325.png'),
    TradeCategory(
      name: 'Computer Tech',
      image: 'assets/images/fi_10528057.png',
    ),
    TradeCategory(name: 'Plumber', image: 'assets/images/fi_6342703.png'),
    TradeCategory(name: 'Electrician', image: 'assets/images/fi_9781304.png'),
    TradeCategory(name: 'Appliance Fix', image: 'assets/images/fi_2012957.png'),
    TradeCategory(name: 'Joinery', image: 'assets/images/fi_14106303.png'),
    TradeCategory(name: 'AC Tech', image: 'assets/images/fi_7969720.png'),
    TradeCategory(name: 'Painter', image: 'assets/images/fi_1995467.png'),
    TradeCategory(name: 'Maid Service', image: 'assets/images/fi_15551378.png'),
    TradeCategory(name: 'Caterer', image: 'assets/images/fi_4490380.png'),
    TradeCategory(name: 'Tile Men', image: 'assets/images/fi_11932525.png'),
    TradeCategory(name: 'Glass Men', image: 'assets/images/fi_896123.png'),
    TradeCategory(name: 'Mason', image: 'assets/images/fi_18029670.png'),
    TradeCategory(name: 'Carpenter', image: 'assets/images/fi_12479483.png'),
    TradeCategory(
      name: 'Fabricator/Welder',
      image: 'assets/images/fi_9439147.png',
    ),
    TradeCategory(name: 'Pool Cleaner', image: 'assets/images/fi_15551378.png'),
    TradeCategory(name: 'Tree Cutter', image: 'assets/images/fi_6327310.png'),
    TradeCategory(name: 'Landscaper', image: 'assets/images/fi_10033506.png'),
    TradeCategory(name: 'Roofer', image: 'assets/images/fi_14620736.png'),
    TradeCategory(name: 'Mechanic', image: 'assets/images/mechanic.png'),
    TradeCategory(name: 'Auto Body', image: 'assets/images/fi_6332022.png'),
    TradeCategory(name: 'Contractor', image: 'assets/images/fi_4490380.png'),
  ];

  final RxString searchQuery = ''.obs;
  final RxList<TradeCategory> categories = <TradeCategory>[].obs;
  final RxBool isLoadingSkills = false.obs;
  bool _isFetchingSkills = false;

  @override
  void onInit() {
    super.onInit();
    categories.assignAll(_fallbackCategories);
  }

  Future<void> fetchSkillList() async {
    if (!Get.isRegistered<TradesmanController>()) return;
    if (_isFetchingSkills) return;

    _isFetchingSkills = true;
    final tradesmanController = Get.find<TradesmanController>();
    isLoadingSkills.value = true;
    try {
      final skills = await tradesmanController.fetchSkillList();
      _applySkillList(skills);

      final tradesmen = await tradesmanController.fetchTradesmenForCounts();
      _applySkillList(skills, tradesmen: tradesmen);
    } finally {
      isLoadingSkills.value = false;
      _isFetchingSkills = false;
    }
  }

  Future<void> refreshCategoryListOnly() async {
    if (!Get.isRegistered<TradesmanController>()) return;
    if (_isFetchingSkills) return;

    _isFetchingSkills = true;
    try {
      final skills = await Get.find<TradesmanController>().fetchSkillList();
      _applySkillList(skills);
    } finally {
      _isFetchingSkills = false;
    }
  }

  void _applySkillList(
    List<SkillModel> skills, {
    List<Tradesman> tradesmen = const [],
  }) {
    if (skills.isEmpty && tradesmen.isEmpty) return;

    final countsBySkill = <String, int>{};
    final iconsBySkill = <String, String>{};
    final newBySkill = <String, bool>{};
    final vipBySkill = <String, bool>{};
    final apiCategoryNames = <String>[];
    final apiCategoryKeys = <String>{};
    for (final skill in skills) {
      final name = skill.skill?.trim();
      if (name == null || name.isEmpty) continue;
      final key = _skillKey(name);
      if (apiCategoryKeys.add(key)) {
        apiCategoryNames.add(name);
      }
      countsBySkill[key] = skill.listedCount ?? 0;
      final icon = skill.icon?.trim();
      if (icon != null && icon.isNotEmpty) {
        iconsBySkill[key] = icon;
      }
      newBySkill[key] = skill.isNew;
      vipBySkill[key] = skill.isVip;
    }

    if (tradesmen.isNotEmpty) {
      final tradesmanCountsBySkill = <String, int>{};
      for (final tradesman in tradesmen) {
        final offeredSkillKeys = <String>{
          _skillKey(tradesman.mainSkill),
          ...tradesman.extraSkills.map(_skillKey),
        }..removeWhere((skill) => skill.isEmpty);

        for (final skill in offeredSkillKeys) {
          tradesmanCountsBySkill[skill] =
              (tradesmanCountsBySkill[skill] ?? 0) + 1;
        }
      }

      for (final entry in tradesmanCountsBySkill.entries) {
        final apiCount = countsBySkill[entry.key] ?? 0;
        countsBySkill[entry.key] = entry.value > apiCount
            ? entry.value
            : apiCount;
      }
    }

    final fallbackKeys = _fallbackCategories
        .map((category) => _skillKey(category.name))
        .toSet();

    final apiOnlyCategories = <TradeCategory>[];
    for (final name in apiCategoryNames) {
      final key = _skillKey(name);
      if (fallbackKeys.contains(key)) continue;

      apiOnlyCategories.add(
        TradeCategory(
          name: name,
          image:
              iconsBySkill[key] ??
              'assets/images/project-manager_8741633 1.png',
          isNew: newBySkill[key] ?? false,
          isVip: vipBySkill[key] ?? false,
          listed: countsBySkill[key] ?? 0,
        ),
      );
    }

    final mergedCategories = _fallbackCategories.map((category) {
      final listedCount = countsBySkill[_skillKey(category.name)];
      return TradeCategory(
        name: category.name,
        image: iconsBySkill[_skillKey(category.name)] ?? category.image,
        isNew: newBySkill[_skillKey(category.name)] ?? false,
        isVip: vipBySkill[_skillKey(category.name)] ?? false,
        listed: listedCount ?? category.listed,
      );
    }).toList();

    categories.assignAll([...apiOnlyCategories, ...mergedCategories]);
  }

  List<TradeCategory> get filteredCategories {
    if (searchQuery.value.trim().isEmpty) return categories;
    return categories
        .where(
          (c) => c.name.toLowerCase().contains(searchQuery.value.toLowerCase()),
        )
        .toList();
  }

  String _skillKey(String value) {
    final normalized = value.trim().toLowerCase();
    switch (normalized) {
      case 'appliance':
      case 'appliance fix':
        return 'appliance';
      case 'fabricator/welder':
      case 'welder/gate':
        return 'welder';
      // case 'mechanic':
      //   return 'mechanic';
      default:
        return normalized;
    }
  }
}
