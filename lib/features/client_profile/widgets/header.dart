import 'package:flutter/material.dart';
import 'package:flutter_wordsaloud/features/client_profile/widgets/pill_button.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class Hearder extends StatelessWidget {
  const Hearder({
    super.key,
    required Color headerColor,
    required Color goldColor, required this.text1, required this.text2, required this.suvbtitle,
  }) : _headerColor = headerColor, _goldColor = goldColor;

  final Color _headerColor;
  final Color _goldColor;
  final String text1;
  final String text2;
  final String suvbtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: _headerColor,
      padding: const EdgeInsets.only(
        top: 60,
        left: 18,
        right: 18,
        bottom: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderPillButton(
            label: 'Back',
            icon: Icons.arrow_back,
            onTap: () => Get.back(),
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.w900,
                height: 1,
              ),
              children: [
                TextSpan(text: text1 ),
                TextSpan(
                  text: text2,
                  style: TextStyle(
                    color: _goldColor,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            suvbtitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}