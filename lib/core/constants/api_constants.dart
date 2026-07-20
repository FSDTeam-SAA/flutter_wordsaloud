class ApiConstants {
  /// [Base Configuration]
  static const String baseDomain = 'http://localhost:5001'; // Noyon Office
  // static const String baseDomain = 'http://192.168.10.243:5006'; // Noyon Office Wifi
  // static const String baseDomain = 'http://192.168.0.218:5006'; // Noyon Home

  // static const String baseDomain = 'http://187.77.187.56:5006'; // Office VPS

  static const String baseUrl = '$baseDomain/api/v1';
  static const String graphqlEndpoint = '$baseDomain/graphql';

  /// Dynamically generated WebSocket URL based on baseDomain
  static String get webSocketUrl {
    if (baseDomain.startsWith('https://')) {
      return baseDomain.replaceFirst('https://', 'wss://');
    } else if (baseDomain.startsWith('http://')) {
      return baseDomain.replaceFirst('http://', 'ws://');
    }
    // Fallback for unexpected cases (e.g., no scheme)
    return 'ws://$baseDomain';
  }

  /// [Headers]
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, String> authHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };

  static Map<String, String> get multipartHeaders => {
    'Accept': 'application/json',
    // Content-Type will be set automatically for multipart
  };

  /// [Socket Events]
  static SocketEndpoint get socketEvents => SocketEndpoint();

  /// [Endpoint Groups
  static AuthEndpoints get auth => AuthEndpoints();
  static UserEndpoints get user => UserEndpoints();
  static CommentEndpoints get comment => CommentEndpoints();
  static PostEndpoints get post => PostEndpoints();
  static NotificationEndpoints get notification => NotificationEndpoints();
  static ChatEndpoints get chat => ChatEndpoints();

}

class SocketEndpoint {
  final String joinChatRoom = "joinChatRoom";
  final String registerUser = "registerUser";
  final String heartbeat = "heartbeat";

  final String joinPost = "joinPost";
  final String leavePost = "leavePost";

  final String joinConversation = "joinConversation";
  final String joinGroup = "joinGroup";
  final String leaveGroup = "leaveGroup";
  final String joinAlerts = "joinAlerts";

  final String watchPresence = "watchPresence";
  final String unwatchPresence = "unwatchPresence";

  final String notificationNew = "notification:new";
  final String messageNew = "message:new";
  final String conversationUpdated = "conversation:updated";
  final String conversationSeen = "conversation:seen";
  final String conversationTyping = "conversation:typing";
  final String messageDeleted = "message:deleted";
  final String messageUpdated = "message:updated";
  final String messagePinned = "message:pinned";
  final String messageReaction = "message:reaction";
  final String postReaction = "post:reaction";
  final String postComment = "post:comment";
  final String commentReaction = "comment:reaction";
  final String userPresence = "userPresence";

  final String searchUsers = "search_query";
  final String searchUsersResults = "search_results";

  final String searchPageCategories = "search_page_categories";
  final String searchPageCategoriesResults = "search_page_categories_results";

  // Call Signaling
  final String callInitiate = "call:initiate";
  final String callReceive = "call:receive";
  final String callRespond = "call:respond";
  final String callResponse = "call:response";
  final String callJoin = "call:join";
  final String callSignal = "call:signal";
  final String callInvite = "call:invite";
  final String callLeave = "call:leave";
  final String callToggleMedia = "call:toggle-media";
  final String callPeerJoined = "call:peer-joined";
  final String callPeerLeft = "call:peer-left";
  final String callMediaUpdate = "call:media-update";
}

class CommentEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/comments';
  final String comments = _base;

  String postComments(String postId) => '$_base/post/$postId';
  String createComment(String postId) => '$_base/$postId';
  String reactComment(String commentId) => '$_base/react/$commentId';
  String commentReplies(String commentId) => '$_base/$commentId/replies';
  String commentByID(String commentId) => '$_base/$commentId';
}

/// [Authentication Endpoints]
class AuthEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/auth';


  final String login = '$_base/login';
  final String register = '$_base/register';
  final String verifyEmail = '$_base/send-otp';
  final String resendOTP = '$_base/resend-otp';
  final String forgotPassword = '$_base/forgot-password';
  final String verifyResetOTP = '$_base/verify-reset-otp';
  final String resetPassword = '$_base/reset-password';
  final String changePassword = '$_base/change-password';
  final String refreshToken = '$_base/refresh-token';
  final String logout = '$_base/logout';
}

class UserEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/users';
  final String users = _base;

  String getProfileByIdOrEmail(String identifier) => '$_base/$identifier';

  // final String updatePersonalInfo = '$_base/update-profile';

  final String profile = '$_base/profile';
  final String deleteAccount = '$_base/delete-account';

  String followUser(String id) => '$_base/follow/$id';
  String unfollowUser(String id) => '$_base/follow/$id';

  /// [Search]
  final String searchUsers = '$_base/search/list';
}

class PostEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/posts';
  final String posts = _base;

  String postByID(String id) => '$_base/$id';

  final String feed = '$_base/feed';

  String createPost(String groupId) => '$_base/$groupId';
  String deletePost(String postId) => '$_base/$postId';

  String reactPost(String postId) => '$_base/$postId/react';
  String save(String postId) => '$_base/$postId/save';

  final String allJoinedGroupPost = '$_base/groups/joined';

  String userTimeline(String userId) => '$_base/timeline/$userId';
}

class NotificationEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/notifications';
  final String root = _base;

  final String readAll = '$_base/read-all';
  String markRead(String id) => '$_base/$id/read';
  String delete(String id) => '$_base/$id';
}

class ChatEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/messages';
  final String root = _base;
  String conversations = '$_base/conversations';

  String get getMyConversations => conversations;

  String get createDirectConversation => '$conversations/direct';

  String getConversationByID(String conversationId) =>
      '$conversations/$conversationId';

  String sendDirectMessage(String conversationId) =>
      '$conversations/$conversationId/messages';

  String getChatMessages(String conversationId) =>
      '$conversations/$conversationId/messages';

  String reactToMessage(String conversationId, String messageId) =>
      '$conversations/$conversationId/messages/$messageId/react';

  String editMessage(String messageId) => '$_base/$messageId';

  String pinMessage(String conversationId, String messageId) =>
      '$conversations/$conversationId/messages/$messageId/pin';

  String markConversationSeen(String conversationId) =>
      '$conversations/$conversationId/seen';

  String deleteMessage(String messageId) => '$_base/$messageId';

  final String createGroupConversation = '$_base/conversations/group';
}