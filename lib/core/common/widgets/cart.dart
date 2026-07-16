// import 'package:danielabake/core/constants/assets_const.dart';
// import 'package:danielabake/core/utils/app_svg.dart';
// import 'package:danielabake/features/Order_screen/controller/order_controller.dart';
// import 'package:danielabake/features/Order_screen/screens/order_screens.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class Cart extends StatelessWidget {
//   const Cart({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final OrderController controller = Get.find<OrderController>();
//
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: const Color(0xFF0B6DFF)),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: GestureDetector(
//           onTap: () {
//             Get.to(() => const OrderScreens());
//           },
//           child: Stack(
//             clipBehavior: Clip.none, // Allows badge to overflow
//             children: [
//               AppSvg(asset: Images.cart),
//
//               // Cart Badge (Quantity)
//               Obx(() {
//                 final cart = controller.cart.value;
//                 final int itemCount = cart?.items.length ?? 0;
//
//                 if (itemCount == 0) {
//                   return const SizedBox.shrink();
//                 }
//
//                 return Positioned(
//                   right: -6,
//                   top: -6,
//                   child: Container(
//                     padding: const EdgeInsets.all(4),
//                     constraints: const BoxConstraints(
//                       minWidth: 10,
//                       minHeight: 10,
//                     ),
//                     decoration: const BoxDecoration(
//                       color: Colors.red,
//                       shape: BoxShape.circle,
//                     ),
//                     child: Center(
//                     ),
//                   ),
//                 );
//               }),
//
//               // // Cart Badge (Quantity)
//               // Obx(() {
//               //   final cart = controller.cart.value;
//               //   final int itemCount = cart?.items.length ?? 0;
//               //
//               //   if (itemCount == 0) {
//               //     return const SizedBox.shrink();
//               //   }
//               //
//               //   return Positioned(
//               //     right: -6,
//               //     top: -6,
//               //     child: Container(
//               //       padding: const EdgeInsets.all(4),
//               //       constraints: const BoxConstraints(
//               //         minWidth: 18,
//               //         minHeight: 18,
//               //       ),
//               //       decoration: const BoxDecoration(
//               //         color: Colors.red,
//               //         shape: BoxShape.circle,
//               //       ),
//               //       child: Center(
//               //         child: Text(
//               //           itemCount > 99 ? '99+' : '$itemCount',
//               //           style: const TextStyle(
//               //             color: Colors.white,
//               //             fontSize: 10,
//               //             fontWeight: FontWeight.bold,
//               //           ),
//               //           textAlign: TextAlign.center,
//               //         ),
//               //       ),
//               //     ),
//               //   );
//               // }),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
