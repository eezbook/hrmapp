// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShiftConfigModel {

 String? get morningShiftStart; String? get morningShiftEnd; String? get eveningShiftStart; String? get eveningShiftEnd; int get lateRelaxationMinutes; double get latePenaltyAmount; int get latePenaltyType; double get absentDeductionAmount; int get absentDeductionType; int? get employeeShiftType; String? get effectiveShiftName; String? get effectiveShiftStart; String? get effectiveShiftEnd;
/// Create a copy of ShiftConfigModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShiftConfigModelCopyWith<ShiftConfigModel> get copyWith => _$ShiftConfigModelCopyWithImpl<ShiftConfigModel>(this as ShiftConfigModel, _$identity);

  /// Serializes this ShiftConfigModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShiftConfigModel&&(identical(other.morningShiftStart, morningShiftStart) || other.morningShiftStart == morningShiftStart)&&(identical(other.morningShiftEnd, morningShiftEnd) || other.morningShiftEnd == morningShiftEnd)&&(identical(other.eveningShiftStart, eveningShiftStart) || other.eveningShiftStart == eveningShiftStart)&&(identical(other.eveningShiftEnd, eveningShiftEnd) || other.eveningShiftEnd == eveningShiftEnd)&&(identical(other.lateRelaxationMinutes, lateRelaxationMinutes) || other.lateRelaxationMinutes == lateRelaxationMinutes)&&(identical(other.latePenaltyAmount, latePenaltyAmount) || other.latePenaltyAmount == latePenaltyAmount)&&(identical(other.latePenaltyType, latePenaltyType) || other.latePenaltyType == latePenaltyType)&&(identical(other.absentDeductionAmount, absentDeductionAmount) || other.absentDeductionAmount == absentDeductionAmount)&&(identical(other.absentDeductionType, absentDeductionType) || other.absentDeductionType == absentDeductionType)&&(identical(other.employeeShiftType, employeeShiftType) || other.employeeShiftType == employeeShiftType)&&(identical(other.effectiveShiftName, effectiveShiftName) || other.effectiveShiftName == effectiveShiftName)&&(identical(other.effectiveShiftStart, effectiveShiftStart) || other.effectiveShiftStart == effectiveShiftStart)&&(identical(other.effectiveShiftEnd, effectiveShiftEnd) || other.effectiveShiftEnd == effectiveShiftEnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,morningShiftStart,morningShiftEnd,eveningShiftStart,eveningShiftEnd,lateRelaxationMinutes,latePenaltyAmount,latePenaltyType,absentDeductionAmount,absentDeductionType,employeeShiftType,effectiveShiftName,effectiveShiftStart,effectiveShiftEnd);

@override
String toString() {
  return 'ShiftConfigModel(morningShiftStart: $morningShiftStart, morningShiftEnd: $morningShiftEnd, eveningShiftStart: $eveningShiftStart, eveningShiftEnd: $eveningShiftEnd, lateRelaxationMinutes: $lateRelaxationMinutes, latePenaltyAmount: $latePenaltyAmount, latePenaltyType: $latePenaltyType, absentDeductionAmount: $absentDeductionAmount, absentDeductionType: $absentDeductionType, employeeShiftType: $employeeShiftType, effectiveShiftName: $effectiveShiftName, effectiveShiftStart: $effectiveShiftStart, effectiveShiftEnd: $effectiveShiftEnd)';
}


}

/// @nodoc
abstract mixin class $ShiftConfigModelCopyWith<$Res>  {
  factory $ShiftConfigModelCopyWith(ShiftConfigModel value, $Res Function(ShiftConfigModel) _then) = _$ShiftConfigModelCopyWithImpl;
@useResult
$Res call({
 String? morningShiftStart, String? morningShiftEnd, String? eveningShiftStart, String? eveningShiftEnd, int lateRelaxationMinutes, double latePenaltyAmount, int latePenaltyType, double absentDeductionAmount, int absentDeductionType, int? employeeShiftType, String? effectiveShiftName, String? effectiveShiftStart, String? effectiveShiftEnd
});




}
/// @nodoc
class _$ShiftConfigModelCopyWithImpl<$Res>
    implements $ShiftConfigModelCopyWith<$Res> {
  _$ShiftConfigModelCopyWithImpl(this._self, this._then);

  final ShiftConfigModel _self;
  final $Res Function(ShiftConfigModel) _then;

/// Create a copy of ShiftConfigModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? morningShiftStart = freezed,Object? morningShiftEnd = freezed,Object? eveningShiftStart = freezed,Object? eveningShiftEnd = freezed,Object? lateRelaxationMinutes = null,Object? latePenaltyAmount = null,Object? latePenaltyType = null,Object? absentDeductionAmount = null,Object? absentDeductionType = null,Object? employeeShiftType = freezed,Object? effectiveShiftName = freezed,Object? effectiveShiftStart = freezed,Object? effectiveShiftEnd = freezed,}) {
  return _then(_self.copyWith(
morningShiftStart: freezed == morningShiftStart ? _self.morningShiftStart : morningShiftStart // ignore: cast_nullable_to_non_nullable
as String?,morningShiftEnd: freezed == morningShiftEnd ? _self.morningShiftEnd : morningShiftEnd // ignore: cast_nullable_to_non_nullable
as String?,eveningShiftStart: freezed == eveningShiftStart ? _self.eveningShiftStart : eveningShiftStart // ignore: cast_nullable_to_non_nullable
as String?,eveningShiftEnd: freezed == eveningShiftEnd ? _self.eveningShiftEnd : eveningShiftEnd // ignore: cast_nullable_to_non_nullable
as String?,lateRelaxationMinutes: null == lateRelaxationMinutes ? _self.lateRelaxationMinutes : lateRelaxationMinutes // ignore: cast_nullable_to_non_nullable
as int,latePenaltyAmount: null == latePenaltyAmount ? _self.latePenaltyAmount : latePenaltyAmount // ignore: cast_nullable_to_non_nullable
as double,latePenaltyType: null == latePenaltyType ? _self.latePenaltyType : latePenaltyType // ignore: cast_nullable_to_non_nullable
as int,absentDeductionAmount: null == absentDeductionAmount ? _self.absentDeductionAmount : absentDeductionAmount // ignore: cast_nullable_to_non_nullable
as double,absentDeductionType: null == absentDeductionType ? _self.absentDeductionType : absentDeductionType // ignore: cast_nullable_to_non_nullable
as int,employeeShiftType: freezed == employeeShiftType ? _self.employeeShiftType : employeeShiftType // ignore: cast_nullable_to_non_nullable
as int?,effectiveShiftName: freezed == effectiveShiftName ? _self.effectiveShiftName : effectiveShiftName // ignore: cast_nullable_to_non_nullable
as String?,effectiveShiftStart: freezed == effectiveShiftStart ? _self.effectiveShiftStart : effectiveShiftStart // ignore: cast_nullable_to_non_nullable
as String?,effectiveShiftEnd: freezed == effectiveShiftEnd ? _self.effectiveShiftEnd : effectiveShiftEnd // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ShiftConfigModel].
extension ShiftConfigModelPatterns on ShiftConfigModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShiftConfigModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShiftConfigModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShiftConfigModel value)  $default,){
final _that = this;
switch (_that) {
case _ShiftConfigModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShiftConfigModel value)?  $default,){
final _that = this;
switch (_that) {
case _ShiftConfigModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? morningShiftStart,  String? morningShiftEnd,  String? eveningShiftStart,  String? eveningShiftEnd,  int lateRelaxationMinutes,  double latePenaltyAmount,  int latePenaltyType,  double absentDeductionAmount,  int absentDeductionType,  int? employeeShiftType,  String? effectiveShiftName,  String? effectiveShiftStart,  String? effectiveShiftEnd)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShiftConfigModel() when $default != null:
return $default(_that.morningShiftStart,_that.morningShiftEnd,_that.eveningShiftStart,_that.eveningShiftEnd,_that.lateRelaxationMinutes,_that.latePenaltyAmount,_that.latePenaltyType,_that.absentDeductionAmount,_that.absentDeductionType,_that.employeeShiftType,_that.effectiveShiftName,_that.effectiveShiftStart,_that.effectiveShiftEnd);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? morningShiftStart,  String? morningShiftEnd,  String? eveningShiftStart,  String? eveningShiftEnd,  int lateRelaxationMinutes,  double latePenaltyAmount,  int latePenaltyType,  double absentDeductionAmount,  int absentDeductionType,  int? employeeShiftType,  String? effectiveShiftName,  String? effectiveShiftStart,  String? effectiveShiftEnd)  $default,) {final _that = this;
switch (_that) {
case _ShiftConfigModel():
return $default(_that.morningShiftStart,_that.morningShiftEnd,_that.eveningShiftStart,_that.eveningShiftEnd,_that.lateRelaxationMinutes,_that.latePenaltyAmount,_that.latePenaltyType,_that.absentDeductionAmount,_that.absentDeductionType,_that.employeeShiftType,_that.effectiveShiftName,_that.effectiveShiftStart,_that.effectiveShiftEnd);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? morningShiftStart,  String? morningShiftEnd,  String? eveningShiftStart,  String? eveningShiftEnd,  int lateRelaxationMinutes,  double latePenaltyAmount,  int latePenaltyType,  double absentDeductionAmount,  int absentDeductionType,  int? employeeShiftType,  String? effectiveShiftName,  String? effectiveShiftStart,  String? effectiveShiftEnd)?  $default,) {final _that = this;
switch (_that) {
case _ShiftConfigModel() when $default != null:
return $default(_that.morningShiftStart,_that.morningShiftEnd,_that.eveningShiftStart,_that.eveningShiftEnd,_that.lateRelaxationMinutes,_that.latePenaltyAmount,_that.latePenaltyType,_that.absentDeductionAmount,_that.absentDeductionType,_that.employeeShiftType,_that.effectiveShiftName,_that.effectiveShiftStart,_that.effectiveShiftEnd);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShiftConfigModel implements ShiftConfigModel {
  const _ShiftConfigModel({this.morningShiftStart, this.morningShiftEnd, this.eveningShiftStart, this.eveningShiftEnd, this.lateRelaxationMinutes = 10, this.latePenaltyAmount = 0.0, this.latePenaltyType = 1, this.absentDeductionAmount = 0.0, this.absentDeductionType = 1, this.employeeShiftType, this.effectiveShiftName, this.effectiveShiftStart, this.effectiveShiftEnd});
  factory _ShiftConfigModel.fromJson(Map<String, dynamic> json) => _$ShiftConfigModelFromJson(json);

@override final  String? morningShiftStart;
@override final  String? morningShiftEnd;
@override final  String? eveningShiftStart;
@override final  String? eveningShiftEnd;
@override@JsonKey() final  int lateRelaxationMinutes;
@override@JsonKey() final  double latePenaltyAmount;
@override@JsonKey() final  int latePenaltyType;
@override@JsonKey() final  double absentDeductionAmount;
@override@JsonKey() final  int absentDeductionType;
@override final  int? employeeShiftType;
@override final  String? effectiveShiftName;
@override final  String? effectiveShiftStart;
@override final  String? effectiveShiftEnd;

/// Create a copy of ShiftConfigModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShiftConfigModelCopyWith<_ShiftConfigModel> get copyWith => __$ShiftConfigModelCopyWithImpl<_ShiftConfigModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShiftConfigModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShiftConfigModel&&(identical(other.morningShiftStart, morningShiftStart) || other.morningShiftStart == morningShiftStart)&&(identical(other.morningShiftEnd, morningShiftEnd) || other.morningShiftEnd == morningShiftEnd)&&(identical(other.eveningShiftStart, eveningShiftStart) || other.eveningShiftStart == eveningShiftStart)&&(identical(other.eveningShiftEnd, eveningShiftEnd) || other.eveningShiftEnd == eveningShiftEnd)&&(identical(other.lateRelaxationMinutes, lateRelaxationMinutes) || other.lateRelaxationMinutes == lateRelaxationMinutes)&&(identical(other.latePenaltyAmount, latePenaltyAmount) || other.latePenaltyAmount == latePenaltyAmount)&&(identical(other.latePenaltyType, latePenaltyType) || other.latePenaltyType == latePenaltyType)&&(identical(other.absentDeductionAmount, absentDeductionAmount) || other.absentDeductionAmount == absentDeductionAmount)&&(identical(other.absentDeductionType, absentDeductionType) || other.absentDeductionType == absentDeductionType)&&(identical(other.employeeShiftType, employeeShiftType) || other.employeeShiftType == employeeShiftType)&&(identical(other.effectiveShiftName, effectiveShiftName) || other.effectiveShiftName == effectiveShiftName)&&(identical(other.effectiveShiftStart, effectiveShiftStart) || other.effectiveShiftStart == effectiveShiftStart)&&(identical(other.effectiveShiftEnd, effectiveShiftEnd) || other.effectiveShiftEnd == effectiveShiftEnd));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,morningShiftStart,morningShiftEnd,eveningShiftStart,eveningShiftEnd,lateRelaxationMinutes,latePenaltyAmount,latePenaltyType,absentDeductionAmount,absentDeductionType,employeeShiftType,effectiveShiftName,effectiveShiftStart,effectiveShiftEnd);

@override
String toString() {
  return 'ShiftConfigModel(morningShiftStart: $morningShiftStart, morningShiftEnd: $morningShiftEnd, eveningShiftStart: $eveningShiftStart, eveningShiftEnd: $eveningShiftEnd, lateRelaxationMinutes: $lateRelaxationMinutes, latePenaltyAmount: $latePenaltyAmount, latePenaltyType: $latePenaltyType, absentDeductionAmount: $absentDeductionAmount, absentDeductionType: $absentDeductionType, employeeShiftType: $employeeShiftType, effectiveShiftName: $effectiveShiftName, effectiveShiftStart: $effectiveShiftStart, effectiveShiftEnd: $effectiveShiftEnd)';
}


}

/// @nodoc
abstract mixin class _$ShiftConfigModelCopyWith<$Res> implements $ShiftConfigModelCopyWith<$Res> {
  factory _$ShiftConfigModelCopyWith(_ShiftConfigModel value, $Res Function(_ShiftConfigModel) _then) = __$ShiftConfigModelCopyWithImpl;
@override @useResult
$Res call({
 String? morningShiftStart, String? morningShiftEnd, String? eveningShiftStart, String? eveningShiftEnd, int lateRelaxationMinutes, double latePenaltyAmount, int latePenaltyType, double absentDeductionAmount, int absentDeductionType, int? employeeShiftType, String? effectiveShiftName, String? effectiveShiftStart, String? effectiveShiftEnd
});




}
/// @nodoc
class __$ShiftConfigModelCopyWithImpl<$Res>
    implements _$ShiftConfigModelCopyWith<$Res> {
  __$ShiftConfigModelCopyWithImpl(this._self, this._then);

  final _ShiftConfigModel _self;
  final $Res Function(_ShiftConfigModel) _then;

/// Create a copy of ShiftConfigModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? morningShiftStart = freezed,Object? morningShiftEnd = freezed,Object? eveningShiftStart = freezed,Object? eveningShiftEnd = freezed,Object? lateRelaxationMinutes = null,Object? latePenaltyAmount = null,Object? latePenaltyType = null,Object? absentDeductionAmount = null,Object? absentDeductionType = null,Object? employeeShiftType = freezed,Object? effectiveShiftName = freezed,Object? effectiveShiftStart = freezed,Object? effectiveShiftEnd = freezed,}) {
  return _then(_ShiftConfigModel(
morningShiftStart: freezed == morningShiftStart ? _self.morningShiftStart : morningShiftStart // ignore: cast_nullable_to_non_nullable
as String?,morningShiftEnd: freezed == morningShiftEnd ? _self.morningShiftEnd : morningShiftEnd // ignore: cast_nullable_to_non_nullable
as String?,eveningShiftStart: freezed == eveningShiftStart ? _self.eveningShiftStart : eveningShiftStart // ignore: cast_nullable_to_non_nullable
as String?,eveningShiftEnd: freezed == eveningShiftEnd ? _self.eveningShiftEnd : eveningShiftEnd // ignore: cast_nullable_to_non_nullable
as String?,lateRelaxationMinutes: null == lateRelaxationMinutes ? _self.lateRelaxationMinutes : lateRelaxationMinutes // ignore: cast_nullable_to_non_nullable
as int,latePenaltyAmount: null == latePenaltyAmount ? _self.latePenaltyAmount : latePenaltyAmount // ignore: cast_nullable_to_non_nullable
as double,latePenaltyType: null == latePenaltyType ? _self.latePenaltyType : latePenaltyType // ignore: cast_nullable_to_non_nullable
as int,absentDeductionAmount: null == absentDeductionAmount ? _self.absentDeductionAmount : absentDeductionAmount // ignore: cast_nullable_to_non_nullable
as double,absentDeductionType: null == absentDeductionType ? _self.absentDeductionType : absentDeductionType // ignore: cast_nullable_to_non_nullable
as int,employeeShiftType: freezed == employeeShiftType ? _self.employeeShiftType : employeeShiftType // ignore: cast_nullable_to_non_nullable
as int?,effectiveShiftName: freezed == effectiveShiftName ? _self.effectiveShiftName : effectiveShiftName // ignore: cast_nullable_to_non_nullable
as String?,effectiveShiftStart: freezed == effectiveShiftStart ? _self.effectiveShiftStart : effectiveShiftStart // ignore: cast_nullable_to_non_nullable
as String?,effectiveShiftEnd: freezed == effectiveShiftEnd ? _self.effectiveShiftEnd : effectiveShiftEnd // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
