import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({
    required bool success,
    T? data,
    String? message,
    @JsonKey(fromJson: _errorsFromJson) Map<String, dynamic>? errors,
    @JsonKey(fromJson: _metaFromJson) PaginationMeta? meta,
  }) = _ApiResponse;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);
}

@freezed
abstract class PaginationMeta with _$PaginationMeta {
  const factory PaginationMeta({
    @Default(1) int currentPage,
    @Default(1) int lastPage,
    @Default(0) int total,
    @Default(0) int perPage,
    String? nextPageUrl,
    String? prevPageUrl,
  }) = _PaginationMeta;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);
}

// Handles both { "code": "HRM_AUTH_001" } (string values) and
// { "field": ["error msg"] } (list values) from the backend.
Map<String, dynamic>? _errorsFromJson(dynamic json) {
  if (json == null) return null;
  if (json is Map) return Map<String, dynamic>.from(json);
  return null;
}

PaginationMeta? _metaFromJson(dynamic json) {
  if (json == null || json is List) return null;
  return PaginationMeta.fromJson(json as Map<String, dynamic>);
}

class PaginatedResponse<T> {
  final List<T> items;
  final int currentPage;
  final int lastPage;
  final int total;

  const PaginatedResponse({
    required this.items,
    required this.currentPage,
    required this.lastPage,
    required this.total,
  });

  bool get hasMore => currentPage < lastPage;

  PaginatedResponse<T> appendPage(PaginatedResponse<T> next) {
    return PaginatedResponse(
      items: [...items, ...next.items],
      currentPage: next.currentPage,
      lastPage: next.lastPage,
      total: next.total,
    );
  }
}
