import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_error.freezed.dart';
part 'api_error.g.dart';

@freezed
class ApiError with _$ApiError {

  const ApiError._();

  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory ApiError({
    @JsonKey(name: "statusCode")
    final int? statusCode,
    final bool? success,
    final String? message,
    final String? requestId,
    final String? error,
  }) = _ApiError;

  factory ApiError.fromJson(Map<String, dynamic> json) => _$ApiErrorFromJson(json);
}
