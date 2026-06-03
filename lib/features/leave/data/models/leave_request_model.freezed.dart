// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leave_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ApprovalStepModel {

 int get level; String get approverName; String get status; String? get comment; String? get decidedAt;
/// Create a copy of ApprovalStepModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApprovalStepModelCopyWith<ApprovalStepModel> get copyWith => _$ApprovalStepModelCopyWithImpl<ApprovalStepModel>(this as ApprovalStepModel, _$identity);

  /// Serializes this ApprovalStepModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApprovalStepModel&&(identical(other.level, level) || other.level == level)&&(identical(other.approverName, approverName) || other.approverName == approverName)&&(identical(other.status, status) || other.status == status)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.decidedAt, decidedAt) || other.decidedAt == decidedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,level,approverName,status,comment,decidedAt);

@override
String toString() {
  return 'ApprovalStepModel(level: $level, approverName: $approverName, status: $status, comment: $comment, decidedAt: $decidedAt)';
}


}

/// @nodoc
abstract mixin class $ApprovalStepModelCopyWith<$Res>  {
  factory $ApprovalStepModelCopyWith(ApprovalStepModel value, $Res Function(ApprovalStepModel) _then) = _$ApprovalStepModelCopyWithImpl;
@useResult
$Res call({
 int level, String approverName, String status, String? comment, String? decidedAt
});




}
/// @nodoc
class _$ApprovalStepModelCopyWithImpl<$Res>
    implements $ApprovalStepModelCopyWith<$Res> {
  _$ApprovalStepModelCopyWithImpl(this._self, this._then);

  final ApprovalStepModel _self;
  final $Res Function(ApprovalStepModel) _then;

/// Create a copy of ApprovalStepModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? approverName = null,Object? status = null,Object? comment = freezed,Object? decidedAt = freezed,}) {
  return _then(_self.copyWith(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,approverName: null == approverName ? _self.approverName : approverName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,decidedAt: freezed == decidedAt ? _self.decidedAt : decidedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ApprovalStepModel].
extension ApprovalStepModelPatterns on ApprovalStepModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ApprovalStepModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ApprovalStepModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ApprovalStepModel value)  $default,){
final _that = this;
switch (_that) {
case _ApprovalStepModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ApprovalStepModel value)?  $default,){
final _that = this;
switch (_that) {
case _ApprovalStepModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int level,  String approverName,  String status,  String? comment,  String? decidedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ApprovalStepModel() when $default != null:
return $default(_that.level,_that.approverName,_that.status,_that.comment,_that.decidedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int level,  String approverName,  String status,  String? comment,  String? decidedAt)  $default,) {final _that = this;
switch (_that) {
case _ApprovalStepModel():
return $default(_that.level,_that.approverName,_that.status,_that.comment,_that.decidedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int level,  String approverName,  String status,  String? comment,  String? decidedAt)?  $default,) {final _that = this;
switch (_that) {
case _ApprovalStepModel() when $default != null:
return $default(_that.level,_that.approverName,_that.status,_that.comment,_that.decidedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ApprovalStepModel implements ApprovalStepModel {
  const _ApprovalStepModel({required this.level, required this.approverName, required this.status, this.comment, this.decidedAt});
  factory _ApprovalStepModel.fromJson(Map<String, dynamic> json) => _$ApprovalStepModelFromJson(json);

@override final  int level;
@override final  String approverName;
@override final  String status;
@override final  String? comment;
@override final  String? decidedAt;

/// Create a copy of ApprovalStepModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ApprovalStepModelCopyWith<_ApprovalStepModel> get copyWith => __$ApprovalStepModelCopyWithImpl<_ApprovalStepModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApprovalStepModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ApprovalStepModel&&(identical(other.level, level) || other.level == level)&&(identical(other.approverName, approverName) || other.approverName == approverName)&&(identical(other.status, status) || other.status == status)&&(identical(other.comment, comment) || other.comment == comment)&&(identical(other.decidedAt, decidedAt) || other.decidedAt == decidedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,level,approverName,status,comment,decidedAt);

@override
String toString() {
  return 'ApprovalStepModel(level: $level, approverName: $approverName, status: $status, comment: $comment, decidedAt: $decidedAt)';
}


}

/// @nodoc
abstract mixin class _$ApprovalStepModelCopyWith<$Res> implements $ApprovalStepModelCopyWith<$Res> {
  factory _$ApprovalStepModelCopyWith(_ApprovalStepModel value, $Res Function(_ApprovalStepModel) _then) = __$ApprovalStepModelCopyWithImpl;
@override @useResult
$Res call({
 int level, String approverName, String status, String? comment, String? decidedAt
});




}
/// @nodoc
class __$ApprovalStepModelCopyWithImpl<$Res>
    implements _$ApprovalStepModelCopyWith<$Res> {
  __$ApprovalStepModelCopyWithImpl(this._self, this._then);

  final _ApprovalStepModel _self;
  final $Res Function(_ApprovalStepModel) _then;

/// Create a copy of ApprovalStepModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = null,Object? approverName = null,Object? status = null,Object? comment = freezed,Object? decidedAt = freezed,}) {
  return _then(_ApprovalStepModel(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as int,approverName: null == approverName ? _self.approverName : approverName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,comment: freezed == comment ? _self.comment : comment // ignore: cast_nullable_to_non_nullable
as String?,decidedAt: freezed == decidedAt ? _self.decidedAt : decidedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$LeaveRequestModel {

 int get id; String get leaveTypeName; String get startDate; String get endDate; double get days; String get status; String get reason; String? get documentUrl; String? get cancelledAt; String? get createdAt; bool? get isHalfDay; String? get halfDaySession; List<ApprovalStepModel>? get approvalTrail; String? get employeeName; String? get employeePhoto; String? get leaveTypeCode;
/// Create a copy of LeaveRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaveRequestModelCopyWith<LeaveRequestModel> get copyWith => _$LeaveRequestModelCopyWithImpl<LeaveRequestModel>(this as LeaveRequestModel, _$identity);

  /// Serializes this LeaveRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaveRequestModel&&(identical(other.id, id) || other.id == id)&&(identical(other.leaveTypeName, leaveTypeName) || other.leaveTypeName == leaveTypeName)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.days, days) || other.days == days)&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.documentUrl, documentUrl) || other.documentUrl == documentUrl)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isHalfDay, isHalfDay) || other.isHalfDay == isHalfDay)&&(identical(other.halfDaySession, halfDaySession) || other.halfDaySession == halfDaySession)&&const DeepCollectionEquality().equals(other.approvalTrail, approvalTrail)&&(identical(other.employeeName, employeeName) || other.employeeName == employeeName)&&(identical(other.employeePhoto, employeePhoto) || other.employeePhoto == employeePhoto)&&(identical(other.leaveTypeCode, leaveTypeCode) || other.leaveTypeCode == leaveTypeCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,leaveTypeName,startDate,endDate,days,status,reason,documentUrl,cancelledAt,createdAt,isHalfDay,halfDaySession,const DeepCollectionEquality().hash(approvalTrail),employeeName,employeePhoto,leaveTypeCode);

@override
String toString() {
  return 'LeaveRequestModel(id: $id, leaveTypeName: $leaveTypeName, startDate: $startDate, endDate: $endDate, days: $days, status: $status, reason: $reason, documentUrl: $documentUrl, cancelledAt: $cancelledAt, createdAt: $createdAt, isHalfDay: $isHalfDay, halfDaySession: $halfDaySession, approvalTrail: $approvalTrail, employeeName: $employeeName, employeePhoto: $employeePhoto, leaveTypeCode: $leaveTypeCode)';
}


}

/// @nodoc
abstract mixin class $LeaveRequestModelCopyWith<$Res>  {
  factory $LeaveRequestModelCopyWith(LeaveRequestModel value, $Res Function(LeaveRequestModel) _then) = _$LeaveRequestModelCopyWithImpl;
@useResult
$Res call({
 int id, String leaveTypeName, String startDate, String endDate, double days, String status, String reason, String? documentUrl, String? cancelledAt, String? createdAt, bool? isHalfDay, String? halfDaySession, List<ApprovalStepModel>? approvalTrail, String? employeeName, String? employeePhoto, String? leaveTypeCode
});




}
/// @nodoc
class _$LeaveRequestModelCopyWithImpl<$Res>
    implements $LeaveRequestModelCopyWith<$Res> {
  _$LeaveRequestModelCopyWithImpl(this._self, this._then);

  final LeaveRequestModel _self;
  final $Res Function(LeaveRequestModel) _then;

/// Create a copy of LeaveRequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? leaveTypeName = null,Object? startDate = null,Object? endDate = null,Object? days = null,Object? status = null,Object? reason = null,Object? documentUrl = freezed,Object? cancelledAt = freezed,Object? createdAt = freezed,Object? isHalfDay = freezed,Object? halfDaySession = freezed,Object? approvalTrail = freezed,Object? employeeName = freezed,Object? employeePhoto = freezed,Object? leaveTypeCode = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,leaveTypeName: null == leaveTypeName ? _self.leaveTypeName : leaveTypeName // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,documentUrl: freezed == documentUrl ? _self.documentUrl : documentUrl // ignore: cast_nullable_to_non_nullable
as String?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,isHalfDay: freezed == isHalfDay ? _self.isHalfDay : isHalfDay // ignore: cast_nullable_to_non_nullable
as bool?,halfDaySession: freezed == halfDaySession ? _self.halfDaySession : halfDaySession // ignore: cast_nullable_to_non_nullable
as String?,approvalTrail: freezed == approvalTrail ? _self.approvalTrail : approvalTrail // ignore: cast_nullable_to_non_nullable
as List<ApprovalStepModel>?,employeeName: freezed == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String?,employeePhoto: freezed == employeePhoto ? _self.employeePhoto : employeePhoto // ignore: cast_nullable_to_non_nullable
as String?,leaveTypeCode: freezed == leaveTypeCode ? _self.leaveTypeCode : leaveTypeCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaveRequestModel].
extension LeaveRequestModelPatterns on LeaveRequestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaveRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaveRequestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaveRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _LeaveRequestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaveRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _LeaveRequestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String leaveTypeName,  String startDate,  String endDate,  double days,  String status,  String reason,  String? documentUrl,  String? cancelledAt,  String? createdAt,  bool? isHalfDay,  String? halfDaySession,  List<ApprovalStepModel>? approvalTrail,  String? employeeName,  String? employeePhoto,  String? leaveTypeCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaveRequestModel() when $default != null:
return $default(_that.id,_that.leaveTypeName,_that.startDate,_that.endDate,_that.days,_that.status,_that.reason,_that.documentUrl,_that.cancelledAt,_that.createdAt,_that.isHalfDay,_that.halfDaySession,_that.approvalTrail,_that.employeeName,_that.employeePhoto,_that.leaveTypeCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String leaveTypeName,  String startDate,  String endDate,  double days,  String status,  String reason,  String? documentUrl,  String? cancelledAt,  String? createdAt,  bool? isHalfDay,  String? halfDaySession,  List<ApprovalStepModel>? approvalTrail,  String? employeeName,  String? employeePhoto,  String? leaveTypeCode)  $default,) {final _that = this;
switch (_that) {
case _LeaveRequestModel():
return $default(_that.id,_that.leaveTypeName,_that.startDate,_that.endDate,_that.days,_that.status,_that.reason,_that.documentUrl,_that.cancelledAt,_that.createdAt,_that.isHalfDay,_that.halfDaySession,_that.approvalTrail,_that.employeeName,_that.employeePhoto,_that.leaveTypeCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String leaveTypeName,  String startDate,  String endDate,  double days,  String status,  String reason,  String? documentUrl,  String? cancelledAt,  String? createdAt,  bool? isHalfDay,  String? halfDaySession,  List<ApprovalStepModel>? approvalTrail,  String? employeeName,  String? employeePhoto,  String? leaveTypeCode)?  $default,) {final _that = this;
switch (_that) {
case _LeaveRequestModel() when $default != null:
return $default(_that.id,_that.leaveTypeName,_that.startDate,_that.endDate,_that.days,_that.status,_that.reason,_that.documentUrl,_that.cancelledAt,_that.createdAt,_that.isHalfDay,_that.halfDaySession,_that.approvalTrail,_that.employeeName,_that.employeePhoto,_that.leaveTypeCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaveRequestModel implements LeaveRequestModel {
  const _LeaveRequestModel({required this.id, required this.leaveTypeName, required this.startDate, required this.endDate, required this.days, required this.status, required this.reason, this.documentUrl, this.cancelledAt, this.createdAt, this.isHalfDay, this.halfDaySession, final  List<ApprovalStepModel>? approvalTrail, this.employeeName, this.employeePhoto, this.leaveTypeCode}): _approvalTrail = approvalTrail;
  factory _LeaveRequestModel.fromJson(Map<String, dynamic> json) => _$LeaveRequestModelFromJson(json);

@override final  int id;
@override final  String leaveTypeName;
@override final  String startDate;
@override final  String endDate;
@override final  double days;
@override final  String status;
@override final  String reason;
@override final  String? documentUrl;
@override final  String? cancelledAt;
@override final  String? createdAt;
@override final  bool? isHalfDay;
@override final  String? halfDaySession;
 final  List<ApprovalStepModel>? _approvalTrail;
@override List<ApprovalStepModel>? get approvalTrail {
  final value = _approvalTrail;
  if (value == null) return null;
  if (_approvalTrail is EqualUnmodifiableListView) return _approvalTrail;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  String? employeeName;
@override final  String? employeePhoto;
@override final  String? leaveTypeCode;

/// Create a copy of LeaveRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaveRequestModelCopyWith<_LeaveRequestModel> get copyWith => __$LeaveRequestModelCopyWithImpl<_LeaveRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaveRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaveRequestModel&&(identical(other.id, id) || other.id == id)&&(identical(other.leaveTypeName, leaveTypeName) || other.leaveTypeName == leaveTypeName)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.days, days) || other.days == days)&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.documentUrl, documentUrl) || other.documentUrl == documentUrl)&&(identical(other.cancelledAt, cancelledAt) || other.cancelledAt == cancelledAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isHalfDay, isHalfDay) || other.isHalfDay == isHalfDay)&&(identical(other.halfDaySession, halfDaySession) || other.halfDaySession == halfDaySession)&&const DeepCollectionEquality().equals(other._approvalTrail, _approvalTrail)&&(identical(other.employeeName, employeeName) || other.employeeName == employeeName)&&(identical(other.employeePhoto, employeePhoto) || other.employeePhoto == employeePhoto)&&(identical(other.leaveTypeCode, leaveTypeCode) || other.leaveTypeCode == leaveTypeCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,leaveTypeName,startDate,endDate,days,status,reason,documentUrl,cancelledAt,createdAt,isHalfDay,halfDaySession,const DeepCollectionEquality().hash(_approvalTrail),employeeName,employeePhoto,leaveTypeCode);

@override
String toString() {
  return 'LeaveRequestModel(id: $id, leaveTypeName: $leaveTypeName, startDate: $startDate, endDate: $endDate, days: $days, status: $status, reason: $reason, documentUrl: $documentUrl, cancelledAt: $cancelledAt, createdAt: $createdAt, isHalfDay: $isHalfDay, halfDaySession: $halfDaySession, approvalTrail: $approvalTrail, employeeName: $employeeName, employeePhoto: $employeePhoto, leaveTypeCode: $leaveTypeCode)';
}


}

/// @nodoc
abstract mixin class _$LeaveRequestModelCopyWith<$Res> implements $LeaveRequestModelCopyWith<$Res> {
  factory _$LeaveRequestModelCopyWith(_LeaveRequestModel value, $Res Function(_LeaveRequestModel) _then) = __$LeaveRequestModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String leaveTypeName, String startDate, String endDate, double days, String status, String reason, String? documentUrl, String? cancelledAt, String? createdAt, bool? isHalfDay, String? halfDaySession, List<ApprovalStepModel>? approvalTrail, String? employeeName, String? employeePhoto, String? leaveTypeCode
});




}
/// @nodoc
class __$LeaveRequestModelCopyWithImpl<$Res>
    implements _$LeaveRequestModelCopyWith<$Res> {
  __$LeaveRequestModelCopyWithImpl(this._self, this._then);

  final _LeaveRequestModel _self;
  final $Res Function(_LeaveRequestModel) _then;

/// Create a copy of LeaveRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? leaveTypeName = null,Object? startDate = null,Object? endDate = null,Object? days = null,Object? status = null,Object? reason = null,Object? documentUrl = freezed,Object? cancelledAt = freezed,Object? createdAt = freezed,Object? isHalfDay = freezed,Object? halfDaySession = freezed,Object? approvalTrail = freezed,Object? employeeName = freezed,Object? employeePhoto = freezed,Object? leaveTypeCode = freezed,}) {
  return _then(_LeaveRequestModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,leaveTypeName: null == leaveTypeName ? _self.leaveTypeName : leaveTypeName // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,documentUrl: freezed == documentUrl ? _self.documentUrl : documentUrl // ignore: cast_nullable_to_non_nullable
as String?,cancelledAt: freezed == cancelledAt ? _self.cancelledAt : cancelledAt // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,isHalfDay: freezed == isHalfDay ? _self.isHalfDay : isHalfDay // ignore: cast_nullable_to_non_nullable
as bool?,halfDaySession: freezed == halfDaySession ? _self.halfDaySession : halfDaySession // ignore: cast_nullable_to_non_nullable
as String?,approvalTrail: freezed == approvalTrail ? _self._approvalTrail : approvalTrail // ignore: cast_nullable_to_non_nullable
as List<ApprovalStepModel>?,employeeName: freezed == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String?,employeePhoto: freezed == employeePhoto ? _self.employeePhoto : employeePhoto // ignore: cast_nullable_to_non_nullable
as String?,leaveTypeCode: freezed == leaveTypeCode ? _self.leaveTypeCode : leaveTypeCode // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
