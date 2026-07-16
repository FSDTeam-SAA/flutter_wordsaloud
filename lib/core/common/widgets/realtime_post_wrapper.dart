// import 'package:flutter/material.dart';
//
// import 'package:visibility_detector/visibility_detector.dart';
//
// import '../../api/socket_client.dart';
// import '../../constants/api_constants.dart';
//
// class RealtimePostWrapper extends StatefulWidget {
//   final String postId;
//   final Widget child;
//
//   const RealtimePostWrapper({
//     super.key,
//     required this.postId,
//     required this.child,
//   });
//
//   @override
//   State<RealtimePostWrapper> createState() => _RealtimePostWrapperState();
// }
//
// class _RealtimePostWrapperState extends State<RealtimePostWrapper> {
//   final SocketClient _socketClient = SocketClient();
//   bool _isInRoom = false;
//
//   @override
//   void dispose() {
//     _leaveRoom();
//     super.dispose();
//   }
//
//   void _joinRoom() {
//     if (!_isInRoom && _socketClient.isConnected) {
//       _socketClient.emit(ApiConstants.socketEvents.joinPost, widget.postId);
//       _isInRoom = true;
//     }
//   }
//
//   void _leaveRoom() {
//     if (_isInRoom) {
//       _socketClient.emit(ApiConstants.socketEvents.leavePost, widget.postId);
//       _isInRoom = false;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return VisibilityDetector(
//       key: Key('post-realtime-${widget.postId}'),
//       onVisibilityChanged: (info) {
//         if (info.visibleFraction > 0.1) {
//           _joinRoom();
//         } else {
//           _leaveRoom();
//         }
//       },
//       child: widget.child,
//     );
//   }
// }
