// import 'dart:async';
// import 'package:flutter/widgets.dart';
// import 'package:get/get.dart';
// import 'package:flutx_core/flutx_core.dart';

// import '../api/socket_client.dart';
// import '../common/models/pagination_model.dart';
// import '../constants/api_constants.dart';
// import 'auth_storage_service.dart';


// class SocketService extends GetxService with WidgetsBindingObserver {
//   final SocketClient _socketClient = SocketClient();
//   final AuthStorageService _authStorage = Get.find<AuthStorageService>();
//   Timer? _heartbeatTimer;
//   bool _isSearchListenerRegistered = false;
//   bool _isGlobalSearchListenerRegistered = false;
//   bool _isGlobalChatListenersRegistered = false;

//   // Real-time Activity
//   final RxMap<String, List<String>> typingUsers = <String, List<String>>{}.obs;
//   final Rx<Map<String, dynamic>?> seenData = Rx<Map<String, dynamic>?>(null);

//   Future<SocketService> init() async {
//     WidgetsBinding.instance.addObserver(this);
//     // Start connection in background
//     _socketClient.connect();

//     // We do NOT await _socketClient.onReady here because it would block
//     // the entire app initialization if the user is offline.
//     // Instead, we perform setup that can handle delayed connection.
//     _joinInitialRooms();
//     _listenToGlobalEvents();

//     return this;
//   }

//   void _listenToGlobalEvents() {
//     _socketClient.on(ApiConstants.socketEvents.callReceive, (data) {
//       Get.find<CallController>().handleIncomingCall(data);
//     });

//     _socketClient.on(ApiConstants.socketEvents.callLeave, (data) {
//       Get.find<CallController>().handleRemoteLeave();
//     });

//     _registerGlobalChatListeners();
//   }

//   void _registerGlobalChatListeners() {
//     if (_isGlobalChatListenersRegistered) return;
//     _isGlobalChatListenersRegistered = true;

//     _socketClient.on(ApiConstants.socketEvents.messageNew, (data) {
//       DPrint.log("Global New Message $data");
//       try {
//         final message = SocketConversationResponseModel.fromJson(data);
//         newMessageData.value = message;
//       } catch (e) {
//         DPrint.error("Error parsing new message: $e");
//       }
//     });

//     _socketClient.on(ApiConstants.socketEvents.conversationUpdated, (data) {
//       DPrint.log("Global Conversation Updated $data");
//       try {
//         final conversation = SocketConversationResponseModel.fromJson(data);
//         conversationData.add(conversation);
//         // Also update newMessageData so ChatController can refresh the list
//         newMessageData.value = conversation;
//       } catch (e) {
//         DPrint.error("Error parsing conversation update: $e");
//       }
//     });

//     _socketClient.on(ApiConstants.socketEvents.messageReaction, (data) {
//       DPrint.log("Global Message Reaction $data");
//       messageReactionData.value = data;
//     });

//     _socketClient.on(ApiConstants.socketEvents.messageUpdated, (data) {
//       DPrint.log("Global Message Updated $data");
//       messageUpdatedData.value = data;
//     });

//     _socketClient.on(ApiConstants.socketEvents.messagePinned, (data) {
//       DPrint.log("Global Message Pinned $data");
//       messagePinnedData.value = data;
//     });

//     _socketClient.on(ApiConstants.socketEvents.messageDeleted, (data) {
//       DPrint.log("Global Message Deleted $data");
//       messageDeletedData.value = data;
//     });

//     _socketClient.on(ApiConstants.socketEvents.conversationSeen, (data) {
//       DPrint.log("Global Conversation Seen $data");
//       seenData.value = data;
//     });

//     _socketClient.on(ApiConstants.socketEvents.conversationTyping, (data) {
//       DPrint.log("Global Conversation Typing $data");
//       final String? convId = data['conversationId'];
//       final String? userId = data['userId'];
//       final bool? isTyping = data['isTyping'];

//       if (convId != null && userId != null) {
//         final currentTyping = List<String>.from(typingUsers[convId] ?? []);
//         if (isTyping == true) {
//           if (!currentTyping.contains(userId)) {
//             currentTyping.add(userId);
//           }
//         } else {
//           currentTyping.remove(userId);
//         }
//         typingUsers[convId] = currentTyping;
//       }
//     });
//   }

//   void emitSeen(String conversationId) {
//     if (_socketClient.isConnected) {
//       _socketClient.emit(
//         ApiConstants.socketEvents.conversationSeen,
//         conversationId,
//       );
//     }
//   }

//   void emitTyping(String conversationId, bool isTyping) {
//     if (_socketClient.isConnected) {
//       _socketClient.emit(ApiConstants.socketEvents.conversationTyping, {
//         'conversationId': conversationId,
//         'isTyping': isTyping,
//       });
//     }
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     _handleLifecycleState(state);
//   }

//   Future<void> _handleLifecycleState(AppLifecycleState state) async {
//     final userId = await _authStorage.getUserId();
//     if (userId == null) return;

//     if (state == AppLifecycleState.paused ||
//         state == AppLifecycleState.detached) {
//       // Stopped heartbeat will let the backend timeout or we can explicitly inform
//       _stopHeartbeat();
//       DPrint.log("App paused/detached - Heartbeat stopped for $userId");
//     } else if (state == AppLifecycleState.resumed) {
//       // App returned to foreground - resume heartbeat
//       _startHeartbeat(userId);
//       DPrint.log("App resumed - Heartbeat restarted for $userId");
//     }
//   }

//   Future<void> _joinInitialRooms() async {
//     final userId = await _authStorage.getUserId();
//     if (userId != null) {
//       // Register user (this also handles joining chat rooms in the backend)
//       _socketClient.emit(ApiConstants.socketEvents.registerUser, userId);
//       DPrint.log("Registered user and joined socket rooms for userId: $userId");

//       // Start heartbeat to maintain "Online" status
//       _startHeartbeat(userId);
//     } else {
//       DPrint.log(
//         "No userId found during SocketService initialization, skipping registration",
//       );
//     }
//   }

//   void _startHeartbeat(String userId) {
//     _stopHeartbeat(); // Cancel any existing timer first

//     // Emit heartbeat every 25 seconds (backend timeout is 45s)
//     _heartbeatTimer = Timer.periodic(const Duration(seconds: 25), (timer) {
//       if (_socketClient.isConnected) {
//         _socketClient.emit(ApiConstants.socketEvents.heartbeat, userId);
//       }
//     });
//     DPrint.log("Started presence heartbeat for userId: $userId");
//   }

//   void _stopHeartbeat() {
//     _heartbeatTimer?.cancel();
//     _heartbeatTimer = null;
//   }

//   /// Re-joins rooms on demand (e.g., after login)
//   Future<void> joinRoomsAfterLogin(String userId) async {
//     if (_socketClient.isConnected) {
//       _socketClient.emit(ApiConstants.socketEvents.registerUser, userId);
//       _socketClient.emit(ApiConstants.socketEvents.joinChatRoom, userId);
//       _startHeartbeat(userId);
//       DPrint.log("Manually registered socket user after login: $userId");
//     } else {
//       // If not connected, connect first
//       _socketClient.connect();
//       await _socketClient.onReady;
//       _socketClient.emit(ApiConstants.socketEvents.registerUser, userId);
//       _socketClient.emit(ApiConstants.socketEvents.joinChatRoom, userId);
//       _startHeartbeat(userId);
//     }
//   }

//   Future<void> searchUsersEmit(
//     String query,
//     PaginationModel paginationModel,
//     List<String> categories,
//   ) async {
//     if (_socketClient.isConnected) {
//       _socketClient.emit(ApiConstants.socketEvents.searchUsers, {
//         'q': query,
//         'categories': categories,
//         'limit': paginationModel.limit,
//       });
//     } else {
//       // If not connected, connect first
//       _socketClient.connect();
//       await _socketClient.onReady;
//       _socketClient.emit(ApiConstants.socketEvents.searchUsers, {
//         'q': query,
//         'categories': categories,
//         'limit': paginationModel.limit,
//       });
//     }
//   }

//   Future<void> searchByTypesEmit(String query, String type) async {
//     if (_socketClient.isConnected) {
//       _socketClient.emit(ApiConstants.socketEvents.searchUsers, {
//         'q': query,
//         'categories': [type],
//         'limit': 20,
//       });
//     } else {
//       _socketClient.connect();
//       await _socketClient.onReady;
//       _socketClient.emit(ApiConstants.socketEvents.searchUsers, {
//         'q': query,
//         'categories': [type],
//         'limit': 20,
//       });
//     }
//   }

//   /// Search User using [Socket]
//   ///
//   final RxList<UserModel> searchUsersData = <UserModel>[].obs;
//   final RxList<SearchGroupModel> searchGroupsData = <SearchGroupModel>[].obs;
//   final RxList<PostModel> searchPostsData = <PostModel>[].obs;
//   // final RxList<SearchEventModel> searchEventsData = <SearchEventModel>[].obs;
//   final RxList<EventModel> searchEventsData = <EventModel>[].obs;
//   //
//   ///
//   Future<void> searchUsersOn() async {
//     if (_isSearchListenerRegistered) return;
//     _isSearchListenerRegistered = true;

//     return _socketClient.on(ApiConstants.socketEvents.searchUsersResults, (
//       data,
//     ) {
//       try {
//         final search = SearchUserSocketResponseModel.fromJson(data);
//         searchUsersData.assignAll(search.results.users);
//         searchGroupsData.assignAll(search.results.groups);
//         searchPostsData.assignAll(search.results.posts);
//         searchEventsData.assignAll(search.results.events);
//         globalSearchResults.value = search.results;
//       } catch (e) {
//         DPrint.error("Error parsing search results: $e");
//       }
//     });
//   }

//   // --- Page Categories Search ---
//   final RxList<String> categorySearchData = <String>[].obs;
//   bool _isCategoryListenerRegistered = false;

//   Future<void> searchPageCategoriesOn() async {
//     if (_isCategoryListenerRegistered) return;
//     _isCategoryListenerRegistered = true;

//     return _socketClient.on(
//       ApiConstants.socketEvents.searchPageCategoriesResults,
//       (data) {
//         if (data != null && data['results'] != null) {
//           final List<dynamic> results = data['results'];
//           categorySearchData.assignAll(
//             results.map((e) => e.toString()).toList(),
//           );
//         } else {
//           categorySearchData.clear();
//         }
//       },
//     );
//   }

//   Future<void> searchPageCategoriesEmit(String query) async {
//     if (_socketClient.isConnected) {
//       _socketClient.emit(ApiConstants.socketEvents.searchPageCategories, {
//         'q': query,
//       });
//     } else {
//       _socketClient.connect();
//       await _socketClient.onReady;
//       _socketClient.emit(ApiConstants.socketEvents.searchPageCategories, {
//         'q': query,
//       });
//     }
//   }

//   final Rx<SearchResults?> globalSearchResults = Rx<SearchResults?>(null);

//   ///
//   Future<void> globalSearchOn() async {
//     if (_isGlobalSearchListenerRegistered) return;
//     _isGlobalSearchListenerRegistered = true;

//     return _socketClient.on(ApiConstants.socketEvents.searchUsersResults, (
//       data,
//     ) {
//       final search = SearchUserSocketResponseModel.fromJson(data);
//       globalSearchResults.value = search.results;
//     });
//   }

//   /// [Messaging part] Start
//   final RxList<SocketConversationResponseModel> conversationData =
//       <SocketConversationResponseModel>[].obs;
//   final Rx<SocketConversationResponseModel?> newMessageData =
//       Rx<SocketConversationResponseModel?>(null);
//   final Rx<Map<String, dynamic>?> messageReactionData =
//       Rx<Map<String, dynamic>?>(null);
//   final Rx<Map<String, dynamic>?> messageUpdatedData =
//       Rx<Map<String, dynamic>?>(null);
//   final Rx<Map<String, dynamic>?> messagePinnedData =
//       Rx<Map<String, dynamic>?>(null);
//   final Rx<Map<String, dynamic>?> messageDeletedData =
//       Rx<Map<String, dynamic>?>(null);

//   ///
//   Future<void> listenToNewMessage(String userId, String conversationId) async {
//     DPrint.log("Joining conversation room: $conversationId");

//     if (_socketClient.isConnected) {
//       _socketClient.emit(
//         ApiConstants.socketEvents.joinConversation,
//         conversationId,
//       );
//       _startHeartbeat(userId);
//     } else {
//       _socketClient.connect();
//       await _socketClient.onReady;
//       _socketClient.emit(
//         ApiConstants.socketEvents.joinConversation,
//         conversationId,
//       );
//       _startHeartbeat(userId);
//     }
//   }

//   /// [Messaging part] End
//   @override
//   void onClose() {
//     WidgetsBinding.instance.removeObserver(this);
//     _stopHeartbeat();
//     conversationData.clear();
//     newMessageData.value = null;
//     messageReactionData.value = null;
//     globalSearchResults.value = null;
//     searchUsersData.clear();
//     searchGroupsData.clear();
//     searchPostsData.clear();
//     searchEventsData.clear();
//     categorySearchData.clear();
//     super.onClose();
//   }
// }
