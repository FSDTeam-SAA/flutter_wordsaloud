import 'package:get/get.dart';

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
  final List<TradeCategory> categories = const [
    TradeCategory(name: 'Phone Tech', image: 'assets/images/fi_5060325.png', isNew: true),
    TradeCategory(name: 'Plumber', image: 'assets/images/fi_6342703.png'),
    TradeCategory(name: 'Electrician', image: 'assets/images/fi_9781304.png'),
    TradeCategory(name: 'Appliance Fix', image: 'assets/images/fi_2012957.png'),
    TradeCategory(name: 'Joinery', image: 'assets/images/fi_14106303.png', isNew: true),
    TradeCategory(name: 'AC Tech', image: 'assets/images/fi_7969720.png'),
    TradeCategory(name: 'Painter', image: 'assets/images/fi_1995467.png'),
    TradeCategory(name: 'Maid Service', image: 'assets/images/fi_15551378.png'),
    TradeCategory(name: 'Caterer', image: 'assets/images/fi_4490380.png', isNew: true),
    TradeCategory(name: 'Tile Man', image: 'assets/images/fi_11932525.png', isNew: true),
    TradeCategory(name: 'Glass Man', image: 'assets/images/fi_896123.png'),
    TradeCategory(name: 'Mason', image: 'assets/images/fi_18029670.png'),
    TradeCategory(name: 'Carpenter', image: 'assets/images/fi_12479483.png'),
    TradeCategory(name: 'Welder/Gate', image: 'assets/images/fi_9439147.png'),
    TradeCategory(name: 'Pool Cleaner', image: 'assets/images/fi_15551378.png'),
    TradeCategory(name: 'Tree Cutter', image: 'assets/images/fi_6327310.png'),
    TradeCategory(name: 'Landscaper', image: 'assets/images/fi_10033506.png'),
    TradeCategory(name: 'Roofer', image: 'assets/images/fi_14620736.png'),
    TradeCategory(name: 'Auto Body', image: 'assets/images/fi_6332022.png'),
    TradeCategory(name: 'Contractor', image: 'assets/images/fi_4490380.png'),
  ];

  final RxString searchQuery = ''.obs;

  List<TradeCategory> get filteredCategories {
    if (searchQuery.value.trim().isEmpty) return categories;
    return categories
        .where((c) =>
            c.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }
}
