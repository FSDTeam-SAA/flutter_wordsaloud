import 'package:aturservicett/core/network/api_client.dart';
import 'package:aturservicett/core/network/interceptor/custom_cache_interceptor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('no-cache request options allow the auth header to be attached', () {
    final options = ApiClient.noCacheOptions();

    options.headers!['Authorization'] = 'Bearer token';
    options.extra![CustomCacheInterceptor.skipCacheKey] = true;

    expect(options.headers!['Authorization'], 'Bearer token');
    expect(options.extra![CustomCacheInterceptor.skipCacheKey], isTrue);
  });
}
