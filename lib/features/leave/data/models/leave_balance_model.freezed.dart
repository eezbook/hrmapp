// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leave_balance_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LeaveBalanceModel {

 int get id; String get leaveTypeName; String get leaveTypeCode; double get allocated; double get used; double get pending; double get remaining; String? get color;
/// Create a copy of LeaveBalanceModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveBalanceModelCopyWith<LeaveBalanceModel> get copyWith => _$LeaveBalanceModelCopyWithImpl<LeaveBalanceModel>(this as LeaveBalanceModel, _$identity);

  /// Serializes this LeaveBalanceModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveBalanceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.leaveTypeName, leaveTypeName) || other.leaveTypeName == leaveTypeName)&&(identical(other.leaveTypeCode, leaveTypeCode) || other.leaveTypeCode == leaveTypeCode)&&(identical(other.allocated, allocated) || other.allocated == allocated)&&(identical(other.used, used) || other.used == used)&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,leaveTypeName,leaveTypeCode,allocated,used,pending,remaining,color);

@override
String toString() {
  return 'LeaveBalanceModel(id: $id, leaveTypeName: $leaveTypeName, leaveTypeCode: $leaveTypeCode, allocated: $allocated, used: $used, pending: $pending, remaining: $remaining, color: $color)';
}


}

/// @nodoc
abstract mixin class $LeaveBalanceModelCopyWith<$Res>  {
  factory $LeaveBalanceModelCopyWith(LeaveBalanceModel value, $Res Function(LeaveBalanceModel) _then) = _$LeaveBalanceModelCopyWithImpl;
@useResult
$Res call({
 int id, String leaveTypeName, String leaveTypeCode, double allocated, double used, double pending, double remaining, String? color
});




}
/// @nodoc
class _$LeaveBalanceModelCopyWithImpl<$Res>
    implements $LeaveBalanceModelCopyWith<$Res> {
  _$LeaveBalanceModelCopyWithImpl(this._self, this._then);

  final LeaveBalanceModel _self;
  final $Res Function(LeaveBalanceModel) _then;

/// Create a copy of LeaveBalanceModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? leaveTypeName = null,Object? leaveTypeCode = null,Object? allocated = null,Object? used = null,Object? pending = null,Object? remaining = null,Object? color = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,leaveTypeName: null == leaveTypeName ? _self.leaveTypeName : leaveTypeName // ignore: cast_nullable_to_non_nullable
as String,leaveTypeCode: null == leaveTypeCode ? _self.leaveTypeCode : leaveTypeCode // ignore: cast_nullable_to_non_nullable
as String,allocated: null == allocated ? _self.allocated : allocated // ignore: cast_nullable_to_non_nullable
as double,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as double,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as double,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as double,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaveBalanceModel].
extension LeaveBalanceModelPatterns on LeaveBalanceModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveBalanceModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveBalanceModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveBalanceModel value)  $default,){
final _that = this;
switch (_that) {
case _LeaveBalanceModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveBalanceModel value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveBalanceModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String leaveTypeName,  String leaveTypeCode,  double allocated,  double used,  double pending,  double remaining,  String? color)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveBalanceModel() when $default != null:
return $default(_that.id,_that.leaveTypeName,_that.leaveTypeCode,_that.allocated,_that.used,_that.pending,_that.remaining,_that.color);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String leaveTypeName,  String leaveTypeCode,  double allocated,  double used,  double pending,  double remaining,  String? color)  $default,) {final _that = this;
switch (_that) {
case _LeaveBalanceModel():
return $default(_that.id,_that.leaveTypeName,_that.leaveTypeCode,_that.allocated,_that.used,_that.pending,_that.remaining,_that.color);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String leaveTypeName,  String leaveTypeCode,  double allocated,  double used,  double pending,  double remaining,  String? color)?  $default,) {final _that = this;
switch (_that) {
case _LeaveBalanceModel() when $default != null:
return $default(_that.id,_that.leaveTypeName,_that.leaveTypeCode,_that.allocated,_that.used,_that.pending,_that.remaining,_that.color);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaveBalanceModel implements LeaveBalanceModel {
  const _LeaveBalanceModel({required this.id, required this.leaveTypeName, required this.leaveTypeCode, this.allocated = 0.0, this.used = 0.0, this.pending = 0.0, this.remaining = 0.0, this.color});
  factory _LeaveBalanceModel.fromJson(Map<String, dynamic> json) => _$LeaveBalanceModelFromJson(json);

@override final  int id;
@override final  String leaveTypeName;
@override final  String leaveTypeCode;
@override@JsonKey() final  double allocated;
@override@JsonKey() final  double used;
@override@JsonKey() final  double pending;
@override@JsonKey() final  double remaining;
@override final  String? color;

/// Create a copy of LeaveBalanceModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveBalanceModelCopyWith<_LeaveBalanceModel> get copyWith => __$LeaveBalanceModelCopyWithImpl<_LeaveBalanceModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaveBalanceModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveBalanceModel&&(identical(other.id, id) || other.id == id)&&(identical(other.leaveTypeName, leaveTypeName) || other.leaveTypeName == leaveTypeName)&&(identical(other.leaveTypeCode, leaveTypeCode) || other.leaveTypeCode == leaveTypeCode)&&(identical(other.allocated, allocated) || other.allocated == allocated)&&(identical(other.used, used) || other.used == used)&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.color, color) || other.color == color));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,leaveTypeName,leaveTypeCode,allocated,used,pending,remaining,color);

@override
String toString() {
  return 'LeaveBalanceModel(id: $id, leaveTypeName: $leaveTypeName, leaveTypeCode: $leaveTypeCode, allocated: $allocated, used: $used, pending: $pending, remaining: $remaining, color: $color)';
}


}

/// @nodoc
abstract mixin class _$LeaveBalanceModelCopyWith<$Res> implements $LeaveBalanceModelCopyWith<$Res> {
  factory _$LeaveBalanceModelCopyWith(_LeaveBalanceModel value, $Res Function(_LeaveBalanceModel) _then) = __$LeaveBalanceModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String leaveTypeName, String leaveTypeCode, double allocated, double used, double pending, double remaining, String? color
});




}
/// @nodoc
class __$LeaveBalanceModelCopyWithImpl<$Res>
    implements _$LeaveBalanceModelCopyWith<$Res> {
  __$LeaveBalanceModelCopyWithImpl(this._self, this._then);

  final _LeaveBalanceModel _self;
  final $Res Function(_LeaveBalanceModel) _then;

/// Create a copy of LeaveBalanceModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? leaveTypeName = null,Object? leaveTypeCode = null,Object? allocated = null,Object? used = null,Object? pending = null,Object? remaining = null,Object? color = freezed,}) {
  return _then(_LeaveBalanceModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,leaveTypeName: null == leaveTypeName ? _self.leaveTypeName : leaveTypeName // ignore: cast_nullable_to_non_nullable
as String,leaveTypeCode: null == leaveTypeCode ? _self.leaveTypeCode : leaveTypeCode // ignore: cast_nullable_to_non_nullable
as String,allocated: null == allocated ? _self.allocated : allocated // ignore: cast_nullable_to_non_nullable
as double,used: null == used ? _self.used : used // ignore: cast_nullable_to_non_nullable
as double,pending: null == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as double,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as double,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
