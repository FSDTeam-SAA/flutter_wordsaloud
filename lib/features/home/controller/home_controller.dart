import 'package:get/get.dart';
import 'package:flutter_wordsaloud/features/tradesman_account_creation/controller/tradesman_controller.dart';

class TradeCategory {
  final String name;
  final String image;
  final bool isNew;
  final int listed;

  const TradeCategory({
    required this.name,
    required this.image,
    this.isNew = false,
    this.listed = 73,
  });
}

class HomeController extends GetxController {
  final List<TradeCategory> _fallbackCategories = const [
    TradeCategory(
      name: 'Phone Tech',
      image: 'assets/images/fi_5060325.png',
      isNew: true,
    ),
    TradeCategory(
      name: 'Computer Tech',
      image: 'assets/images/fi_10528057.png',
      isNew: true,
    ),
    TradeCategory(name: 'Plumber', image: 'assets/images/fi_6342703.png'),
    TradeCategory(name: 'Electrician', image: 'assets/images/fi_9781304.png'),
    TradeCategory(name: 'Appliance Fix', image: 'assets/images/fi_2012957.png'),
    TradeCategory(
      name: 'Joinery',
      image: 'assets/images/fi_14106303.png',
      isNew: true,
    ),
    TradeCategory(name: 'AC Tech', image: 'assets/images/fi_7969720.png'),
    TradeCategory(name: 'Painter', image: 'assets/images/fi_1995467.png'),
    TradeCategory(name: 'Maid Service', image: 'assets/images/fi_15551378.png'),
    TradeCategory(
      name: 'Caterer',
      image: 'assets/images/fi_4490380.png',
      isNew: true,
    ),
    TradeCategory(
      name: 'Tile Man',
      image: 'assets/images/fi_11932525.png',
      isNew: true,
    ),
    TradeCategory(name: 'Glass Man', image: 'assets/images/fi_896123.png'),
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

  @override
  void onInit() {
    super.onInit();
    categories.assignAll(_fallbackCategories);
  }

  Future<void> fetchSkillList() async {
    if (!Get.isRegistered<TradesmanController>()) return;

    final tradesmanController = Get.find<TradesmanController>();
    isLoadingSkills.value = true;
    final skills = await tradesmanController.fetchSkillList();
    isLoadingSkills.value = false;

    if (skills.isEmpty) return;

    final countsBySkill = <String, int>{};
    for (final skill in skills) {
      final name = skill.skill?.trim();
      if (name == null || name.isEmpty) continue;
      countsBySkill[_skillKey(name)] = skill.listedCount ?? 0;
    }

    categories.assignAll(
      _fallbackCategories.map((category) {
        final listedCount = countsBySkill[_skillKey(category.name)];
        return TradeCategory(
          name: category.name,
          image: category.image,
          isNew: category.isNew,
          listed: listedCount ?? category.listed,
        );
      }),
    );
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
      case 'mechanic':
      case 'mobile mech':
        return 'mechanic';
      default:
        return normalized;
    }
  }
}
