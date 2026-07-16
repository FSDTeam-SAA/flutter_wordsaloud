import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutx_core/core/debug_print.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'auth_storage_service.dart';

class ConnectivityService {
  static ConnectivityService? _instance;
  static ConnectivityService get instance =>
      _instance ??= ConnectivityService._internal();

  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  bool _isInitialCheck = true;

  // Current connectivity status as ValueNotifier for reactive updates
  final ValueNotifier<bool> _isConnectedNotifier = ValueNotifier<bool>(true);
  ValueNotifier<bool> get isConnectedNotifier => _isConnectedNotifier;
  bool get isConnected => _isConnectedNotifier.value;

  // Stream controller for connectivity changes
  final StreamController<bool> _connectivityController =
      StreamController<bool>.broadcast();
  Stream<bool> get connectivityStream => _connectivityController.stream;

  /// Stream that emits only when the device reconnects to the internet
  Stream<void> get onReconnected => _connectivityController.stream
      .where((connected) => connected)
      .map((_) {});

  /// Initialize connectivity monitoring
  Future<void> initialize() async {
    DPrint.info('Initializing ConnectivityService');
    // Check initial connectivity
    await _checkConnectivity();

    // Listen for connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _onConnectivityChanged,
      onError: (error) {
        if (kDebugMode) print('Connectivity error: $error');
      },
    );

    DPrint.info('ConnectivityService initialized - isConnected: $isConnected');
  }

  /// Check current connectivity status
  Future<bool> checkConnectivity() async {
    try {
      final List<ConnectivityResult> connectivityResults = await _connectivity
          .checkConnectivity();
      return _hasInternetConnection(connectivityResults);
    } catch (e) {
      if (kDebugMode) print('Error checking connectivity: $e');
      return false;
    }
  }

  /// Private method to check connectivity and update status
  Future<void> _checkConnectivity() async {
    final bool wasConnected = _isConnectedNotifier.value;
    final bool isNowConnected = await checkConnectivity();

    if (wasConnected != isNowConnected || _isInitialCheck) {
      _isConnectedNotifier.value = isNowConnected;
      _connectivityController.add(isNowConnected);

      if (!_isInitialCheck) {
        await _showConnectivityNotification(isNowConnected);
      }

      if (kDebugMode) {
        print(
          'Connectivity changed: ${isNowConnected ? 'Connected' : 'Disconnected'}',
        );
      }
    }
    _isInitialCheck = false;
  }

  /// Handle connectivity changes
  void _onConnectivityChanged(List<ConnectivityResult> results) async {
    final bool wasConnected = _isConnectedNotifier.value;
    final bool isNowConnected = _hasInternetConnection(results);

    if (wasConnected != isNowConnected) {
      _isConnectedNotifier.value = isNowConnected;
      _connectivityController.add(isNowConnected);

      await _showConnectivityNotification(isNowConnected);

      if (kDebugMode) {
        print(
          'Connectivity changed: ${isNowConnected ? 'Connected' : 'Disconnected'}',
        );
      }
    }
  }

  Future<void> _showConnectivityNotification(bool isNowConnected) async {
    try {
      // Guard: Ensure GetMaterialApp/context is available before showing snackbar
      if (Get.context == null) {
        DPrint.info(
          'Skipping connectivity snackbar: Get.context is null (app initializing)',
        );
        return;
      }

      final authStorage = Get.find<AuthStorageService>();
      final isAuth = await authStorage.isAuthenticated();

      if (!isAuth) return;

      if (isNowConnected) {
        Get.snackbar(
          'Back Online',
          'Your internet connection has been restored.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(Icons.wifi, color: Colors.white),
          duration: const Duration(seconds: 3),
        );
      } else {
        Get.snackbar(
          'No Internet',
          'You are currently offline. Some features may be unavailable.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          icon: const Icon(Icons.wifi_off, color: Colors.white),
          duration: const Duration(seconds: 5),
          isDismissible: true,
        );
      }
    } catch (e) {
      DPrint.error('Error showing connectivity notification: $e');
    }
  }

  /// Check if any of the connectivity results indicate internet connection
  bool _hasInternetConnection(List<ConnectivityResult> results) {
    return results.any(
      (result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet ||
          result == ConnectivityResult.vpn,
    );
  }

  /// Wait for internet connection (useful for retry mechanisms)
  Future<void> waitForConnection({Duration? timeout}) async {
    if (_isConnectedNotifier.value) return;

    final completer = Completer<void>();
    late StreamSubscription<bool> subscription;

    subscription = connectivityStream.listen((isConnected) {
      if (isConnected) {
        subscription.cancel();
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    });

    if (timeout != null) {
      Timer(timeout, () {
        subscription.cancel();
        if (!completer.isCompleted) {
          completer.completeError(
            TimeoutException('Connection timeout', timeout),
          );
        }
      });
    }

    return completer.future;
  }

  /// Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivityController.close();
    _isConnectedNotifier.dispose();
  }
}
