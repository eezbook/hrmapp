import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

@Freezed(genericArgumentFactories: true)
abstract class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({
    required bool success,
    T? data,
    String? message,
    Map<String, List<String>>? errors,
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
    required int currentPage,
    required int lastPage,
    required int total,
    required int perPage,
    String? nextPageUrl,
    String? prevPageUrl,
  }) = _PaginationMeta;

  factory PaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$PaginationMetaFromJson(json);
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
