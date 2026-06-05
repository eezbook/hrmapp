import 'package:freezed_annotation/freezed_annotation.dart';

part 'leave_type_model.freezed.dart';
part 'leave_type_model.g.dart';

@freezed
abstract class LeaveTypeModel with _$LeaveTypeModel {
  const factory LeaveTypeModel({
    required int id,
    required String name,
    required String code,
    required bool requiresDocument,
    required bool allowHalfDay,
    @Default(0) int maxDays,
    String? color,
  }) = _LeaveTypeModel;

  factory LeaveTypeModel.fromJson(Map<String, dynamic> json) =>
      _$LeaveTypeModelFromJson(json);
}
