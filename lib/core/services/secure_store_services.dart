// lib/core/network/services/secure_store_services.dart

import 'package:flutx_core/core/debug_print.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStoreServices {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Singleton Instance
  static final SecureStoreServices _instance = SecureStoreServices._internal();

  // Private constructor
  SecureStoreServices._internal();

  // Factory constructor to return the singleton instance
  factory SecureStoreServices() => _instance;

  /// [Method to store data securely]
  Future<void> storeData(String key, String value) async {
    DPrint.log("Successfully store the data");
    await _storage.write(key: key, value: value);
  }

  /// [Method to retrieve data securely]
  Future<String?> retrieveData(String key) async {
    return await _storage.read(key: key);
  }

  /// [Method to store boolean data securely]
  Future<void> storeBool(String key, bool value) async {
    await storeData(key, value.toString());
  }

  /// [Method to retrieve boolean data securely]
  Future<bool?> retrieveBool(String key) async {
    final value = await retrieveData(key);
    if (value == null) return null;
    return value == true.toString();
  }

  /// [Method to delete data securely]
  Future<void> deleteData(String key) async {
    await _storage.delete(key: key);
  }

  /// [Medele all the data securely]
  Future<void> deleteAllData() async {
    await _storage.deleteAll();
  }
}
