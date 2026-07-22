import 'package:flutter/material.dart';
import 'package:flutter_wordsaloud/features/client_profile/screens/privacy_and_policy_screen.dart';
import 'package:flutter_wordsaloud/features/client_profile/screens/terms_and_condition_screen.dart';
import 'package:get/get.dart';

class TermsAndPrivacyController extends GetxController {
  final headerSubtitle =
      'Our commitments to you and how we protect your\ndata'.obs;
  final mattersTitle = 'What matters most'.obs;
  final questionsTitle = 'Questions about your data?'.obs;
  final questionsSubtitle =
      'Our team handles data requests, complaints,\nand clarifications.'.obs;
  final supportEmail = 'support@aturservicett.com'.obs;

  final policyItems = <PolicyItem>[
    PolicyItem(
      icon: '📜',
      title: 'Terms & Conditions',
      subtitle:
          'How Aturservicett works, and what\nyou agree to when using the app',
      onPressed: () {
        Get.to(() => const TermsAndConditionScreen());
      },
    ),
    PolicyItem(
      icon: '🔒',
      title: 'Privacy Policy',
      subtitle:
          'What data we collect, why we\ncollect it, and how we protect it',
      onPressed: () {
        Get.to(() => const PrivacyAndPolicyScreen());
      },
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

class PolicyItem {
  const PolicyItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onPressed,
  });

  final String icon;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;
}
