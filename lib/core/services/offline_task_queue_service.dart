import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutx_core/core/debug_print.dart';
import 'package:get/get.dart';
import '../common/models/offline_task_model.dart';

class OfflineTaskQueueService extends GetxService {
  static const String _boxName = 'offline_tasks_box';
  late Box<String> _box;

  Future<OfflineTaskQueueService> init() async {
    DPrint.info('Initializing OfflineTaskQueueService');
    _box = await Hive.openBox<String>(_boxName);
    return this;
  }

  Future<void> addTask(OfflineTaskModel task) async {
    await _box.put(task.id, task.toJson());
    DPrint.info('Offline Task queued: ${task.type} (${task.id})');
  }

  Future<void> removeTask(String id) async {
    await _box.delete(id);
    DPrint.info('Offline Task removed: $id');
  }

  Future<void> updateTask(OfflineTaskModel task) async {
    await _box.put(task.id, task.toJson());
  }

  List<OfflineTaskModel> getAllTasks() {
    if (!_box.isOpen) return [];
    return _box.values.map((jsonStr) => OfflineTaskModel.fromJson(jsonStr)).toList();
  }
}
