import 'package:dio/dio.dart';

import 'api_error.dart';

abstract class ApiResult<T> {

  static const String _jsonNodeData = "data";
  static const String _jsonNodeStatus = "status";
  static const String _jsonNodeStatusCode = "statusCode";

  static Function(Map<String, dynamic>) get emptyMapper => (Map<String, dynamic> d) => {};

  /// This method works only with Map response
  static ApiResult<T> fromResponse<T>(
      Response response, T Function(Map<String, dynamic>) mapper) {
    final responseData = response.data;

/*
    bool correctResponse = isCorrectResponse(responseData[_jsonNodeStatus]) ||
        isCorrectResponse(responseData[_jsonNodeStatusCode])
        || responseData["success"] as bool;
    // correctResponse = correctResponse;

 */
    bool correctResponse = (responseData is Map) && isCorrectResponse(responseData[_jsonNodeStatus]) ||
        isCorrectResponse(responseData[_jsonNodeStatusCode]) ||
        (responseData["success"] as bool? ?? false);

    if (!correctResponse) {
      return ServerError.fromResponse(response);
    } else if (correctResponse && responseData[_jsonNodeData] != null) {
      if (response.data[_jsonNodeData] is Map<String, dynamic>) {
        var responseMap = (response.data[_jsonNodeData] as Map<String, dynamic>);
        return Success(mapper(responseMap), isEmptyData: responseMap.isEmpty);
      } else {
        return Success(mapper(responseData));
      }
    } else {
      return InternalError(null);
    }
  }

  static ApiResult<List<T>> fromListResponse<T>(
      Response response, T Function(Map<String, dynamic>) mapper) {
    final responseData = response.data;

    bool correctResponse = isCorrectResponse(responseData[_jsonNodeStatus]) ||
        isCorrectResponse(responseData[_jsonNodeStatusCode]);

    if (!correctResponse) {
      return ServerError.fromResponse(response);
    } else if (correctResponse && responseData[_jsonNodeData] != null) {
      var l = <T>[];
      if (response.data[_jsonNodeData] is List) {
        var rList = response.data[_jsonNodeData];
        for (var d in rList) {
          l.add(mapper(d));
        }
      }
      return Success(l);
    } else {
      return InternalError(null);
    }
  }

  static bool isCorrectResponse(dynamic responseCode) => responseCode == 200 || responseCode == 201;
  static ApiResult<List<T>> fromRawListResponse<T>(
      Response response, T Function(Map<String, dynamic>) mapper) {
    try {
      final data = response.data;
      if (data is List) {
        final list = data.map((item) => mapper(item)).toList();
        return Success(list);
      } else {
        return InternalError("Expected a list but got: ${data.runtimeType}");
      }
    } catch (e) {
      return InternalError("Parsing error: $e");
    }
  }

}

class Success<T> extends ApiResult<T> {
  final T data;
  final bool isEmptyData;

  Success(this.data, {this.isEmptyData = false});
}

class Failed<T> extends ApiResult<T> {
  ApiError errors;

  Failed(this.errors);
}

class ServerError<T> extends Failed<T> {
  ServerError(ApiError errors) : super(errors);

  static ServerError<T> fromResponse<T>(Response response) {
    return ServerError(ApiError.fromJson(response.data));
  }
}

class InternalError<T> extends ApiResult<T> {
  final String? msg;

  InternalError(this.msg);
}

class TokenExpired<T> extends ApiResult<T> {
  TokenExpired();
}

class EmptyResponse<T> extends ApiResult<T> {
  EmptyResponse();
}

