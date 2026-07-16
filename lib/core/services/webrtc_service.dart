import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;
import 'package:flutx_core/core/debug_print.dart';
import 'package:get/get.dart';

class WebRTCService extends GetxService {
  webrtc.RTCPeerConnection? peerConnection;
  webrtc.MediaStream? localStream;
  final Rx<webrtc.MediaStream?> remoteStream = Rx<webrtc.MediaStream?>(null);

  final Map<String, dynamic> _iceServers = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'},
      {'urls': 'stun:stun1.l.google.com:19302'},
    ]
  };

  final Map<String, dynamic> _config = {
    'sdpSemantics': 'unified-plan',
  };

  @override
  void onInit() {
    super.onInit();
    _initWebRTC();
  }

  Future<void> _initWebRTC() async {
    // WebRTC initialization (especially for iOS)
    try {
      if (GetPlatform.isIOS) {
        await webrtc.Helper.setAppleAudioConfiguration(
          webrtc.AppleAudioConfiguration(
            appleAudioCategory: webrtc.AppleAudioCategory.playAndRecord,
            appleAudioCategoryOptions: {
              webrtc.AppleAudioCategoryOption.allowBluetooth,
              webrtc.AppleAudioCategoryOption.defaultToSpeaker,
            },
            appleAudioMode: webrtc.AppleAudioMode.voiceChat,
          ),
        );
        DPrint.log("iOS AppleAudioConfiguration set");
      }
    } catch (e) {
      DPrint.error("Error initializing WebRTC: $e");
    }
  }

  Future<webrtc.MediaStream> createLocalStream({bool video = true, bool audio = true}) async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': audio,
      'video': video
          ? {
              'mandatory': {
                'minWidth': '1280',
                'minHeight': '720',
                'minFrameRate': '30',
              },
              'facingMode': 'user',
              'optional': [
                {'width': {'ideal': 1920}},
                {'height': {'ideal': 1080}},
                {'frameRate': {'ideal': 60}},
              ],
            }
          : false,
    };

    localStream = await webrtc.navigator.mediaDevices.getUserMedia(mediaConstraints);
    
    // Apply initial autofocus if video track exists
    if (video) {
        await applyFocus();
    }
    
    return localStream!;
  }

  Future<void> applyFocus() async {
    try {
      final videoTrack = localStream?.getVideoTracks().firstOrNull;
      if (videoTrack != null) {
        await webrtc.Helper.setFocusMode(videoTrack, webrtc.CameraFocusMode.auto);
        await webrtc.Helper.setExposureMode(videoTrack, webrtc.CameraExposureMode.auto);
        DPrint.log("Camera autofocus and exposure set to auto");
      }
    } catch (e) {
      DPrint.error("Failed to set autofocus: $e");
    }
  }

  Future<webrtc.RTCPeerConnection> createRTCPeerConnection() async {
    peerConnection = await webrtc.createPeerConnection(_iceServers, _config);

    if (localStream != null) {
      localStream!.getTracks().forEach((track) {
        peerConnection!.addTrack(track, localStream!);
      });
    }

    peerConnection!.onTrack = (webrtc.RTCTrackEvent event) {
      DPrint.log("Received remote track: ${event.track.kind} (id: ${event.track.id})");
      if (event.streams.isNotEmpty) {
        remoteStream.value = event.streams[0];
        DPrint.log("Remote stream assigned from track: ${event.track.kind}");
      } else {
        // Fallback for some WebRTC implementations
        if (remoteStream.value == null) {
          webrtc.createLocalMediaStream('remote_stream').then((stream) {
            stream.addTrack(event.track);
            remoteStream.value = stream;
          });
        } else {
          remoteStream.value!.addTrack(event.track);
          // Trigger reactivity
          final current = remoteStream.value;
          remoteStream.value = null;
          remoteStream.value = current;
        }
      }
    };

    return peerConnection!;
  }

  Future<webrtc.RTCSessionDescription> createOffer() async {
    if (peerConnection == null) throw Exception("PeerConnection not initialized");
    
    // Unified Plan constraints for receiving media
    final Map<String, dynamic> constraints = {
      'offerToReceiveAudio': true,
      'offerToReceiveVideo': true,
    };
    
    webrtc.RTCSessionDescription offer = await peerConnection!.createOffer(constraints);
    await peerConnection!.setLocalDescription(offer);
    return offer;
  }

  Future<webrtc.RTCSessionDescription> createAnswer() async {
    if (peerConnection == null) throw Exception("PeerConnection not initialized");
    
    // Unified Plan constraints for receiving media
    final Map<String, dynamic> constraints = {
      'offerToReceiveAudio': true,
      'offerToReceiveVideo': true,
    };
    
    webrtc.RTCSessionDescription answer = await peerConnection!.createAnswer(constraints);
    await peerConnection!.setLocalDescription(answer);
    return answer;
  }

  Future<void> setRemoteDescription(String sdp, String type) async {
    if (peerConnection == null) throw Exception("PeerConnection not initialized");
    await peerConnection!.setRemoteDescription(webrtc.RTCSessionDescription(sdp, type));
  }

  Future<void> addCandidate(String candidate, String sdpMid, int sdpMLineIndex) async {
    if (peerConnection == null) throw Exception("PeerConnection not initialized");
    await peerConnection!.addCandidate(webrtc.RTCIceCandidate(candidate, sdpMid, sdpMLineIndex));
  }

  void dispose() {
    localStream?.dispose();
    remoteStream.value?.dispose();
    peerConnection?.dispose();
    localStream = null;
    remoteStream.value = null;
    peerConnection = null;
  }
}
