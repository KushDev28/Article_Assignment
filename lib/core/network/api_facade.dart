import 'package:dio/dio.dart';
import 'package:kushal_assignment/core/network/service_locator.dart';
import 'package:kushal_assignment/core/utils/extensions/string_extensions.dart';

import '../service/shared_pref_keys.dart';
import '../service/shared_pref_services.dart';
import 'api_config.dart';


class ApiFacade {
  static final ApiFacade _instance = ApiFacade._internal();
  late final Dio _dio;
  late final ApiConfig _config;

  factory ApiFacade() {
    return _instance;
  }

  ApiFacade._internal() {
    _config = getIt<ApiConfig>();
    _dio = Dio(
      BaseOptions(
        baseUrl: _config.baseUrl,
        connectTimeout: _config.connectTimeout,
        receiveTimeout: _config.receiveTimeout,
        headers: _config.defaultHeaders,
      ),
    );
    _dio.interceptors.add(LogInterceptor(responseBody: true));
  }

  Future<Response> delete(String endpoint, {dynamic data}) async {
    try {
      return await _dio.delete(endpoint, data: data);
    } on DioException catch (e) {
      // _handleError(e);
      rethrow;
    }
  }

  Future<Response> get(
      String endpoint, {
        Map<String, dynamic>? queryParams,
        bool needAccessToken = true,
        Map<String, dynamic>? data,
        Options? options,
      }) async {
    try {
      options ??= needAccessToken ? await _getAccessTokenOptions() : null;
      return await _dio.get(endpoint, queryParameters: queryParams, options: options, data: data);
    } on DioException catch (e) {
      if(e.response != null) {
        return _handleError(e);
      }
      // _handleError(e);
      rethrow;
    }
  }

  Future<Response> post(String endpoint, {dynamic data, bool needAccessToken = true}) async {
    try {
      var options = needAccessToken ? await _getAccessTokenOptions() : null;
      return await _dio.post(endpoint, data: data, options: options);
    } on DioException catch (e) {
      if(e.response != null) {
        return _handleError(e);
      }
      rethrow;
    }
  }

  Future<Response> put(String endpoint, {dynamic data}) async {
    try {
      return await _dio.put(endpoint, data: data);
    } on DioException catch (e) {
      // _handleError(e);
      rethrow;
    }
  }

  Future<Options> _getAccessTokenOptions({bool logOutUserIfAccessTokenEmpty = true}) async {
    var r = _config.defaultHeaders;
    var accessToken = (await SharedPreferencesService.getInstance())
        .getString(SharedPreferencesKeys.accessToken);
    if (accessToken!.isNullOrEmpty && logOutUserIfAccessTokenEmpty) {
      //  NavigationUtils.instance.goToLoginPage();
    }
    r["accesstoken"] = accessToken!;
    return Options(headers: r);
  }

  Response<dynamic> _handleError(DioException e) {
    print("API ERROR :: ${e.response?.statusCode} - ${e.message}");
    if (e.response?.statusCode == 401) {
      // NavigationUtils.instance.goToLoginPage();
      return e.response!;
    } else {
      return e.response!;
    }
  }
}
