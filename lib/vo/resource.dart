import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'resource.freezed.dart';

@freezed
abstract class Resource<T> with _$Resource<T> {
  const factory Resource.success(T data) = Success<T>;

  const factory Resource.loading() = Loading<T>;

  const factory Resource.error([String message]) = Failure<T>;
}
