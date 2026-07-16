// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:visibility_detector/visibility_detector.dart';
//
// import 'package:flutx_core/flutx_core.dart';
//
// import '../../api/socket_client.dart';
// import '../../constants/api_constants.dart';
//
// typedef PresenceBuilder =
//     Widget Function(BuildContext context, RxBool isOnline, String lastActiveAt);
//
// class RealtimeOnlineStatusWrapper extends StatefulWidget {
//   final String userId;
//   final RxBool initialIsOnline;
//   final String initialLastActiveAt;
//   final PresenceBuilder builder;
//
//   const RealtimeOnlineStatusWrapper({
//     super.key,
//     required this.userId,
//     required this.initialIsOnline,
//     required this.initialLastActiveAt,
//     required this.builder,
//   });
//
//   @override
//   State<RealtimeOnlineStatusWrapper> createState() =>
//       _RealtimeOnlineStatusWrapperState();
// }
//
// class _RealtimeOnlineStatusWrapperState
//     extends State<RealtimeOnlineStatusWrapper> {
//   final SocketClient _socketClient = SocketClient();
//   bool _isWatching = false;
//
//   // Localized state for this specific user
//   late RxBool _isOnline;
//   late String _lastActiveAt;
//   Timer? _timer;
//
//   @override
//   void initState() {
//     super.initState();
//     _isOnline = widget.initialIsOnline;
//     _lastActiveAt = widget.initialLastActiveAt;
//
//     // Check online status immediately
//     _updateOnlineStatus();
//
//     // Periodic check every minute to turn offline if inactive
//     _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
//       _updateOnlineStatus();
//     });
//
//     // Listen for presence updates for this specific user
//     _socketClient.on(
//       ApiConstants.socketEvents.userPresence,
//       _onPresenceReceived,
//     );
//   }
//
//   void _updateOnlineStatus() {
//     // If already offline, no need to check
//     if (!_isOnline.value || _lastActiveAt.isEmpty) return;
//
//     try {
//       final lastActive = DateTime.parse(_lastActiveAt);
//       final now = DateTime.now();
//       final difference = now.difference(lastActive).inMinutes;
//
//       // If last activity is $\ge$ 5 minutes ago, mark offline
//       if (difference >= 5) {
//         _isOnline.value = false;
//         DPrint.info(
//           "Inactivity Offline Sync for ${widget.userId}: Marked offline (Last active: $difference mins ago)",
//         );
//       }
//     } catch (e) {
//       DPrint.error(
//         "Error parsing lastActiveAt for ${widget.userId}: $_lastActiveAt",
//       );
//     }
//   }
//
//   void _onPresenceReceived(dynamic data) {
//     if (data == null || data is! Map) return;
//
//     final String? userId = data['userId']?.toString();
//     if (userId != widget.userId) return;
//
//     if (mounted) {
//       if (data['isOnline'] is bool) {
//         _isOnline.value = data['isOnline'];
//       }
//       _lastActiveAt = data['lastActiveAt']?.toString() ?? _lastActiveAt;
//
//       // Validate status based on time
//       _updateOnlineStatus();
//
//       DPrint.info(
//         "Localized Presence Sync for ${widget.userId}: isOnline=${_isOnline.value}",
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     _stopWatching();
//     _socketClient.off(
//       ApiConstants.socketEvents.userPresence,
//       _onPresenceReceived,
//     );
//     super.dispose();
//   }
//
//   void _startWatching() {
//     if (!_isWatching && _socketClient.isConnected) {
//       _socketClient.emit(
//         ApiConstants.socketEvents.watchPresence,
//         widget.userId,
//       );
//       _isWatching = true;
//     }
//   }
//
//   void _stopWatching() {
//     if (_isWatching && _socketClient.isConnected) {
//       _socketClient.emit(
//         ApiConstants.socketEvents.unwatchPresence,
//         widget.userId,
//       );
//       _isWatching = false;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return VisibilityDetector(
//       key: Key('user-presence-${widget.userId}'),
//       onVisibilityChanged: (info) {
//         if (info.visibleFraction > 0.1) {
//           _startWatching();
//         } else {
//           _stopWatching();
//         }
//       },
//       child: Obx(() {
//         return widget.builder(context, _isOnline, _lastActiveAt);
//       }),
//     );
//   }
// }
