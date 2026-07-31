import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AppNetworkVideo extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;
  final bool looping;
  final bool muted;
  final BoxFit fit;

  const AppNetworkVideo({
    super.key,
    required this.videoUrl,
    this.autoPlay = false,
    this.looping = false,
    this.muted = false,
    this.fit = BoxFit.cover,
  });

  @override
  State<AppNetworkVideo> createState() => _AppNetworkVideoState();
}

class _AppNetworkVideoState extends State<AppNetworkVideo> {
  VideoPlayerController? _controller;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    try {
      final controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.videoUrl),
      );
      _controller = controller;

      await controller.initialize();
      await controller.setLooping(widget.looping);
      await controller.setVolume(widget.muted ? 0 : 1);

      if (widget.autoPlay) {
        await controller.play();
      }

      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return const ColoredBox(
        color: Color(0xFFE9DFD3),
        child: Center(
          child: Icon(Icons.broken_image_outlined, color: Color(0xFF8C7F72)),
        ),
      );
    }

    if (_isLoading ||
        _controller == null ||
        !_controller!.value.isInitialized) {
      return const ColoredBox(
        color: Color(0xFFE9DFD3),
        child: Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFFAE3F30),
            ),
          ),
        ),
      );
    }

    return FittedBox(
      fit: widget.fit,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: _controller!.value.size.width,
        height: _controller!.value.size.height,
        child: VideoPlayer(_controller!),
      ),
    );
  }
}
