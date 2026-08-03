import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../screens/about_aturservice_screen.dart';

class AboutAturserviceController extends GetxController {
  final headerSubtitle = 'Skilled professionals at your service'.obs;
  final missionTitle = 'Our mission'.obs;
  final missionBody =
      'Aturservicett is a marketplace built for Trinidad & Tobago -- connecting skilled tradesmen directly with clients who need them. Real reviews, real referrals, no middleman fees. Every trade, every borough.'
          .obs;
  final foundersNote =
      'Aturservicett was built to solve a real problem -- finding good, honest, verified tradesmen in Trinidad & Tobago shouldn\'t be difficult. We built this app so every skilled worker on our two islands has a place to be found, and every Trini has a way to find them.'
          .obs;
  final foundersSignature = 'Co-Founders'.obs;
  final contactTitle = 'We\'d love to hear from you'.obs;
  final contactSubtitle = 'Feedback, questions, or partnerships'.obs;
  final supportEmail = 'support@aturservicett.com'.obs;
  final stats = <AboutStat>[
    const AboutStat(value: '22', label: 'TRADES'),
    const AboutStat(value: '🇹🇹', label: 'T&T-WIDE'),
    const AboutStat(value: '0%', label: 'FEES'),
  ].obs;
}