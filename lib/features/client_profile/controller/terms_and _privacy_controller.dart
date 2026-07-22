import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../screens/terms_and_privacy_screen.dart';

class TermsAndPrivacyController extends GetxController {
  final headerSubtitle =
      'Our commitments to you and how we protect your\ndata'.obs;
  final mattersTitle = 'What matters most'.obs;
  final questionsTitle = 'Questions about your data?'.obs;
  final questionsSubtitle =
      'Our team handles data requests, complaints,\nand clarifications.'.obs;
  final supportEmail = 'support@aturservicett.com'.obs;

  final policyItems = <PolicyItem>[
    const PolicyItem(
      icon: '📜',
      title: 'Terms & Conditions',
      subtitle:
          'How Aturservicett works, and what\nyou agree to when using the app',
    ),
    const PolicyItem(
      icon: '🔒',
      title: 'Privacy Policy',
      subtitle:
      'What data we collect, why we\ncollect it, and how we protect it',
    ),
  ].obs;

  final mattersMost = <String>[
    'Your phone number is used for account access only',
    'Your name is displayed as first name + last initial (e.g. "Keisha P.")',
    'We never sell your data to advertisers or third parties',
    'Aturservicett is a directory -- we don\'t handle payments between users',
    'You can request account deletion at any time',
  ].obs;
}
