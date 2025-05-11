

import 'package:kushal_assignment/core/utils/extensions/string_extensions.dart';

/// Simple class same as Either
class DataOrError<T> {

  final T? data;
  final String? _errorMsg;

  DataOrError._(this.data, this._errorMsg);

  DataOrError.withData(T data) : this._(data, null);
  DataOrError.withError(String? err) : this._(null, err);

  bool get hasData => data != null;

  bool get hasError => !hasData;

  String get errorMsg => _errorMsg!.isNotNullNorEmpty ? _errorMsg! : "Something Went Wrong!";

}