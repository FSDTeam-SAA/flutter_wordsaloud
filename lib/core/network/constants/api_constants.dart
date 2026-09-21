class ApiConstants {
  /// [Base Configuration]
  static const String baseDomain = 'http://10.10.26.122:5001';
  // static const String baseDomain =
  //     'https://backendwordsaloudd-rose.vercel.app'; // Publish

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

  static TradesmanEndpoints get tradesman => TradesmanEndpoints();
  static UserEndpoints get user => UserEndpoints();

  static RatingEndpoints get rating => RatingEndpoints();
}

/// [Authentication Endpoints]
class AuthEndpoints {
  static const String _base = '${ApiConstants.baseUrl}/auth';

  final String login = '$_base/login';
  final String verifyEmail = '$_base/verify-email';

  final String verifyOtp = '$_base/send-otp';
  final String resendOtp = '$_base/resend-otp';

  final String register = '$_base/register';

  final String refreshToken = '$_base/refresh-token';
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

class RatingEndpoints {
  final String addReview = '${ApiConstants.baseUrl}/reviews';
  String getReview(String itemId) =>
      '${ApiConstants.baseUrl}/reviews/item/$itemId';
  String deleteReview(String id) => '${ApiConstants.baseUrl}/reviews/$id';
}
