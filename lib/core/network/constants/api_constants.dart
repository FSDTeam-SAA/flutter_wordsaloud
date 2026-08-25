class ApiConstants {
  /// [Base Configuration]
  //static const String baseDomain = 'http://10.10.5.33:5002'; // eshita
  // static const String baseDomain = 'https://daniela-bake-backend.onrender.com'; // Publish
  // static const String baseDomain = 'http://18.116.214.151'; /// [AWS]
  // static const String baseDomain = 'http://192.168.0.218:8000';
  //static const String baseDomain = 'http://localhost:5002';///eshitas laptop
  static const String baseDomain = 'http://187.77.187.56:5056'; // Live
  static const String baseUrl = '$baseDomain/api/v1';

  /// Dynamically generated WebSocket URL based on baseDomain
  // static String get webSocketUrl {
  //   if (baseDomain.startsWith('https://')) {
  //     return baseDomain.replaceFirst('https://', 'wss://');
  //   } else if (baseDomain.startsWith('http://')) {
  //     return baseDomain.replaceFirst('http://', 'ws://');
  //   }
  //   // Fallback for unexpected cases (e.g., no scheme)
  //   return 'ws://$baseDomain';
  // }

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

  /// [Endpoint Groups
  static AuthEndpoints get auth => AuthEndpoints();
  static ProfileEndpoints get profile => ProfileEndpoints();
  static HomeEndpoints get home => HomeEndpoints();
  static TradesmanEndpoints get tradesman => TradesmanEndpoints();
  static UserEndpoints get user => UserEndpoints();
  static ChatEndpoints get chat => ChatEndpoints();
  static RatingEndpoints get rating => RatingEndpoints();
}

/// [Authentication Endpoints]
class AuthEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/auth';

  final String login = '$_base/login';
  final String verifyEmail = '$_base/verify-email';
  final String forgotPassword = '$_base/forgot-password';
  final String verifyOtp = '$_base/send-otp';
  final String resendOtp = '$_base/resend-otp';
  final String resetPassword = '$_base/reset-password';
  final String register = '$_base/register';
  final String updatePassword = '$_base/change-password';

  final String refreshToken = '$_base/refresh-token';
}

class ProfileEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/profile';
  String fetchProfile(String userId) => '$_base/$userId';
  String updateProfile(String userId) => '$_base/$userId';
  String fetchFavorite(String userId) =>
      '${ApiConstants.baseUrl}/favorites/$userId';
  final String fetchOngoing =
      '${ApiConstants.baseUrl}/orders/my?filter=ongoing';
  final String fetchDelivered =
      '${ApiConstants.baseUrl}/orders/my?filter=completed';

  String deleteProfile(String userId) =>
      '${ApiConstants.baseUrl}/profile/$userId';
  // String fetchCategory(String userId) =>;
}

class HomeEndpoints {
  final String category = '${ApiConstants.baseUrl}/categories';
  String items(String categoryId, {int page = 1, int limit = 10}) =>
      '${ApiConstants.baseUrl}/items?category=$categoryId&page=$page&limit=$limit';
  String searchItem(String text) =>
      '${ApiConstants.baseUrl}/items?search=$text';
  final String favorite = '${ApiConstants.baseUrl}/favorites';
  final String removeFavorite = '${ApiConstants.baseUrl}/favorites';
  String popular(String day) => '${ApiConstants.baseUrl}/items?day=$day';
  String allPopular({int page = 1, int limit = 10}) =>
      '${ApiConstants.baseUrl}/items?page=$page&limit=$limit';
  final String addCart = '${ApiConstants.baseUrl}/cart/add';
  final String removeCart = '${ApiConstants.baseUrl}/cart/remove';
  final String removeOneCart = '${ApiConstants.baseUrl}/cart/reduce';
}

class TradesmanEndpoints {
  final String whatCan = '${ApiConstants.baseUrl}/tradesman/onboarding/skills';
  final String whereWork =
      '${ApiConstants.baseUrl}/tradesman/onboarding/work-area';
  final String tellClient =
      '${ApiConstants.baseUrl}/tradesman/onboarding/pitch';
  final String deletePhoto =
      '${ApiConstants.baseUrl}/tradesman/onboarding/delete-photo';
  final String goLive = '${ApiConstants.baseUrl}/tradesman/onboarding/go-live';
  final String dashboard = '${ApiConstants.baseUrl}/tradesman/me/dashboard';
  final String updateProfile = '${ApiConstants.baseUrl}/tradesman/me/profile';
}

class UserEndpoints {
  final String home = '${ApiConstants.baseUrl}/tradesman/categories';
  final String getProfile = '${ApiConstants.baseUrl}/user/me';
  final String addInquiry = '${ApiConstants.baseUrl}/inquiry';
  final String getInquiry = '${ApiConstants.baseUrl}/admin/advertisements';
  final String updateProfile = '${ApiConstants.baseUrl}/user/me';
  String tradesmanDetails(String id) => '${ApiConstants.baseUrl}/tradesman/$id';
  String review(String tradesmanId) =>
      '${ApiConstants.baseUrl}/review/$tradesmanId';

  String categoryDetails({
    String skill = '',
    String search = '',
    String area = '',
    String sort = 'rating',
    int page = 1,
    int limit = 20,
  }) {
    final query = Uri(
      queryParameters: {
        'skill': skill,
        'search': search,
        'area': area,
        'sort': sort,
        'page': page.toString(),
        'limit': limit.toString(),
      },
    ).query;

    return '${ApiConstants.baseUrl}/tradesman?$query';
  }

  // String fetchCategory(String userId) =>;
}

class ChatEndpoints {
  String sendMsg(String conversationId) =>
      '${ApiConstants.baseUrl}/chat/messages/$conversationId';
  String getAdmin = '${ApiConstants.baseUrl}/users/admin';
  String createConversation = '${ApiConstants.baseUrl}/chat/conversations';
  String getAllMsg(String conversationId) =>
      '${ApiConstants.baseUrl}/chat/messages/$conversationId';
  // String fetchCategory(String userId) =>;
}

class RatingEndpoints {
  final String addReview = '${ApiConstants.baseUrl}/reviews';
  String getReview(String itemId) =>
      '${ApiConstants.baseUrl}/reviews/item/$itemId';
  String deleteReview(String id) => '${ApiConstants.baseUrl}/reviews/$id';
}
