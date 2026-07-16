// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:flutx_core/core/debug_print.dart';
// import '../../services/media_cache_service.dart';
//
// class AppNetworkVideo extends StatefulWidget {
//   final String videoUrl;
//   final bool autoPlay;
//   final bool looping;
//
//   const AppNetworkVideo({
//     super.key,
//     required this.videoUrl,
//     this.autoPlay = false,
//     this.looping = false,
//   });
//
//   @override
//   State<AppNetworkVideo> createState() => _AppNetworkVideoState();
// }
//
// class _AppNetworkVideoState extends State<AppNetworkVideo> {
//   VideoPlayerController? _controller;
//   bool _isLoading = true;
//   bool _hasError = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeVideo();
//   }
//
//   Future<void> _initializeVideo() async {
//     try {
//       // 1. Ask CacheManager for the file.
//       // If offline/cached, returns local file instantly.
//       // If online/not cached, downloads it and caches it for next time.
//       final File file = await MediaCacheService.videoCacheManager.getSingleFile(
//         widget.videoUrl,
//       );
//
//       // 2. Initialize video player with the local cached file
//       _controller = VideoPlayerController.file(file)
//         ..addListener(() {
//           if (mounted) setState(() {});
//         });
//
//       await _controller!.initialize();
//       _controller!.setLooping(widget.looping);
//
//       if (widget.autoPlay) {
//         _controller!.play();
//       }
//
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//         });
//       }
//     } catch (e) {
//       DPrint.error("Error initializing video from cache: $e");
//       if (mounted) {
//         setState(() {
//           _isLoading = false;
//           _hasError = true;
//         });
//       }
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (_hasError) {
//       return Container(
//         color: Colors.black12,
//         child: const Center(
//           child: Icon(Icons.error_outline, color: Colors.red),
//         ),
//       );
//     }
//
//     if (_isLoading ||
//         _controller == null ||
//         !_controller!.value.isInitialized) {
//       return Container(
//         color: Colors.black12,
//         child: const Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     return AspectRatio(
//       aspectRatio: _controller!.value.aspectRatio,
//       child: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           VideoPlayer(_controller!),
//           _ControlsOverlay(controller: _controller!),
//           VideoProgressIndicator(_controller!, allowScrubbing: true),
//         ],
//       ),
//     );
//   }
// }
//
// class _ControlsOverlay extends StatelessWidget {
//   const _ControlsOverlay({required this.controller});
//
//   final VideoPlayerController controller;
//
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: <Widget>[
//         AnimatedSwitcher(
//           duration: const Duration(milliseconds: 50),
//           reverseDuration: const Duration(milliseconds: 200),
//           child: controller.value.isPlaying
//               ? const SizedBox.shrink()
//               : Container(
//                   color: Colors.black26,
//                   child: const Center(
//                     child: Icon(
//                       Icons.play_arrow,
//                       color: Colors.white,
//                       size: 50.0,
//                     ),
//                   ),
//                 ),
//         ),
//         GestureDetector(
//           onTap: () {
//             controller.value.isPlaying ? controller.pause() : controller.play();
//           },
//         ),
//       ],
//     );
//   }
// }
