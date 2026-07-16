import 'dart:async';
import 'package:get/get.dart';
import 'package:flutx_core/core/debug_print.dart';
import 'connectivity_service.dart';
import 'offline_task_queue_service.dart';

typedef TaskHandler = Future<bool> Function(Map<String, dynamic> payload);

class OfflineSyncManager extends GetxService {
  late final OfflineTaskQueueService _queueService;
  final Map<String, TaskHandler> _handlers = {};

  final _taskCompletedController = StreamController<String>.broadcast();
  Stream<String> get onTaskCompleted => _taskCompletedController.stream;

  bool _isProcessing = false;
  StreamSubscription? _connectivitySubscription;

  Future<OfflineSyncManager> init() async {
    DPrint.info('Initializing OfflineSyncManager');
    _queueService = Get.find<OfflineTaskQueueService>();

    // Listen for reconnection
    _connectivitySubscription = ConnectivityService.instance.onReconnected
        .listen((_) {
          flushQueue();
        });

    // Trigger initial flush just in case app starts connected with pending items in queue
    Future.delayed(const Duration(seconds: 2), () {
      if (ConnectivityService.instance.isConnected) {
        flushQueue();
      }
    });
    return this;
  }

  void registerHandler(String type, TaskHandler handler) {
    _handlers[type] = handler;
    DPrint.info('Registered offline task handler for type: $type');
  }

  @override
  void onClose() {
    _connectivitySubscription?.cancel();
    _taskCompletedController.close();
    super.onClose();
  }

  Future<void> flushQueue() async {
    if (_isProcessing) return;

    final tasks = _queueService.getAllTasks();
    if (tasks.isEmpty) return;

    // Sort tasks by created at to maintain chronological order
    tasks.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    _isProcessing = true;
    DPrint.info('Flushing offline task queue (${tasks.length} tasks)...');

    for (final task in tasks) {
      // Before processing each task, ensure we still have network connection
      if (!ConnectivityService.instance.isConnected) {
        DPrint.info('Connection lost while syncing. Aborting sync.');
        break;
      }

      final handler = _handlers[task.type];
      if (handler == null) {
        DPrint.error(
          'No handler registered for offline task type: ${task.type}. Skipping.',
        );
        continue;
      }

      try {
        final success = await handler(task.payload);
        if (success) {
          await _queueService.removeTask(task.id);
          _taskCompletedController.add(task.id);
          DPrint.info('Offline Task completely processed: ${task.id}');
        } else {
          DPrint.info(
            'Offline Task failed gracefully. Modifying retry count: ${task.id}',
          );
          final updatedTask = task.copyWith(retryCount: task.retryCount + 1);
          await _queueService.updateTask(updatedTask);
        }
      } catch (e) {
        DPrint.error('Exception processing offline task ${task.id}: $e');
        final updatedTask = task.copyWith(retryCount: task.retryCount + 1);
        await _queueService.updateTask(updatedTask);

        // If an exception occurs, it could be a transient issue or network failure.
        // We'll break the loop to be safe and let the next connection event or timer resume.
        break;
      }
    }

    _isProcessing = false;
  }
}
