// import 'package:danielabake/core/constants/assets_const.dart' hide Icons;
// import 'package:danielabake/core/utils/app_svg.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class AppBarSearch extends StatelessWidget {
//   final TextEditingController controller;
//   final ValueChanged<String>? onChanged;
//   final VoidCallback? onClear;
//   final RxBool isExpanded;
//
//   AppBarSearch({
//     super.key,
//     required this.controller,
//     this.onChanged,
//     this.onClear,
//     required this.isExpanded,
//   }) {
//     controller.addListener(() {
//       _text.value = controller.text; // update reactive text
//     });
//   }
//
//   final RxString _text = ''.obs;
//
//   @override
//   Widget build(BuildContext context) {
//     const double height = 36;
//     final double screenWidth = MediaQuery.of(context).size.width;
//
//     const double collapsedWidth = 36;
//
//     return Obx(() {
//       return GestureDetector(
//         onTap: () {
//           if (!isExpanded.value) {
//             isExpanded.value = true;
//           }
//         },
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 250),
//           height: height,
//           width: isExpanded.value ? screenWidth * 0.82 : collapsedWidth,
//           padding: const EdgeInsets.symmetric(horizontal: 4),
//           decoration: BoxDecoration(
//             border: Border.all(color: const Color(0xFF7F3615)),
//             borderRadius: BorderRadius.circular(50),
//           ),
//           child: Row(
//             children: [
//               if (!isExpanded.value)
//                 const Padding(
//                   padding: EdgeInsets.all(3.0),
//                   child: AppSvg(asset: Images.search),
//                 ),
//
//               if (isExpanded.value) ...[
//                 const SizedBox(width: 4),
//
//                 // TextField
//                 Expanded(
//                   child: TextField(
//                     controller: controller,
//                     decoration: const InputDecoration(
//                       hintText: "Search items...",
//                       border: InputBorder.none,
//                       isDense: true,
//                       contentPadding: EdgeInsets.symmetric(vertical: 8),
//                     ),
//                     autofocus: true,
//                     onChanged: onChanged,
//                   ),
//                 ),
//
//                 // Cross icon (reactive)
//                 if (_text.value.isNotEmpty)
//                   GestureDetector(
//                     onTap: () {
//                       controller.clear();
//                       _text.value = '';
//                       if (onClear != null) onClear!();
//                     },
//                     child: const Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 4.0),
//                       child: Icon(Icons.close, size: 18, color: Colors.black),
//                     ),
//                   ),
//               ],
//             ],
//           ),
//         ),
//       );
//     });
//   }
// }
//
//
