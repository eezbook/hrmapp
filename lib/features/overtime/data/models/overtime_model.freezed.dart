// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'overtime_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OvertimeRequestModel {

 int get id; String get date; String get startTime; String get endTime; double get hours; double get amount; String get status; String get reason; String? get approverComment; String? get createdAt; String? get employeeName; String? get employeePhoto; String? get approvedBy;
/// Create a copy of OvertimeRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OvertimeRequestModelCopyWith<OvertimeRequestModel> get copyWith => _$OvertimeRequestModelCopyWithImpl<OvertimeRequestModel>(this as OvertimeRequestModel, _$identity);

  /// Serializes this OvertimeRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OvertimeRequestModel&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.hours, hours) || other.hours == hours)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.approverComment, approverComment) || other.approverComment == approverComment)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.employeeName, employeeName) || other.employeeName == employeeName)&&(identical(other.employeePhoto, employeePhoto) || other.employeePhoto == employeePhoto)&&(identical(other.approvedBy, approvedBy) || other.approvedBy == approvedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,startTime,endTime,hours,amount,status,reason,approverComment,createdAt,employeeName,employeePhoto,approvedBy);

@override
String toString() {
  return 'OvertimeRequestModel(id: $id, date: $date, startTime: $startTime, endTime: $endTime, hours: $hours, amount: $amount, status: $status, reason: $reason, approverComment: $approverComment, createdAt: $createdAt, employeeName: $employeeName, employeePhoto: $employeePhoto, approvedBy: $approvedBy)';
}


}

/// @nodoc
abstract mixin class $OvertimeRequestModelCopyWith<$Res>  {
  factory $OvertimeRequestModelCopyWith(OvertimeRequestModel value, $Res Function(OvertimeRequestModel) _then) = _$OvertimeRequestModelCopyWithImpl;
@useResult
$Res call({
 int id, String date, String startTime, String endTime, double hours, double amount, String status, String reason, String? approverComment, String? createdAt, String? employeeName, String? employeePhoto, String? approvedBy
});




}
/// @nodoc
class _$OvertimeRequestModelCopyWithImpl<$Res>
    implements $OvertimeRequestModelCopyWith<$Res> {
  _$OvertimeRequestModelCopyWithImpl(this._self, this._then);

  final OvertimeRequestModel _self;
  final $Res Function(OvertimeRequestModel) _then;

/// Create a copy of OvertimeRequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? startTime = null,Object? endTime = null,Object? hours = null,Object? amount = null,Object? status = null,Object? reason = null,Object? approverComment = freezed,Object? createdAt = freezed,Object? employeeName = freezed,Object? employeePhoto = freezed,Object? approvedBy = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as double,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,approverComment: freezed == approverComment ? _self.approverComment : approverComment // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,employeeName: freezed == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String?,employeePhoto: freezed == employeePhoto ? _self.employeePhoto : employeePhoto // ignore: cast_nullable_to_non_nullable
as String?,approvedBy: freezed == approvedBy ? _self.approvedBy : approvedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [OvertimeRequestModel].
extension OvertimeRequestModelPatterns on OvertimeRequestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OvertimeRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OvertimeRequestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OvertimeRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _OvertimeRequestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OvertimeRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _OvertimeRequestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String date,  String startTime,  String endTime,  double hours,  double amount,  String status,  String reason,  String? approverComment,  String? createdAt,  String? employeeName,  String? employeePhoto,  String? approvedBy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OvertimeRequestModel() when $default != null:
return $default(_that.id,_that.date,_that.startTime,_that.endTime,_that.hours,_that.amount,_that.status,_that.reason,_that.approverComment,_that.createdAt,_that.employeeName,_that.employeePhoto,_that.approvedBy);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String date,  String startTime,  String endTime,  double hours,  double amount,  String status,  String reason,  String? approverComment,  String? createdAt,  String? employeeName,  String? employeePhoto,  String? approvedBy)  $default,) {final _that = this;
switch (_that) {
case _OvertimeRequestModel():
return $default(_that.id,_that.date,_that.startTime,_that.endTime,_that.hours,_that.amount,_that.status,_that.reason,_that.approverComment,_that.createdAt,_that.employeeName,_that.employeePhoto,_that.approvedBy);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String date,  String startTime,  String endTime,  double hours,  double amount,  String status,  String reason,  String? approverComment,  String? createdAt,  String? employeeName,  String? employeePhoto,  String? approvedBy)?  $default,) {final _that = this;
switch (_that) {
case _OvertimeRequestModel() when $default != null:
return $default(_that.id,_that.date,_that.startTime,_that.endTime,_that.hours,_that.amount,_that.status,_that.reason,_that.approverComment,_that.createdAt,_that.employeeName,_that.employeePhoto,_that.approvedBy);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OvertimeRequestModel implements OvertimeRequestModel {
  const _OvertimeRequestModel({required this.id, required this.date, required this.startTime, required this.endTime, required this.hours, required this.amount, required this.status, required this.reason, this.approverComment, this.createdAt, this.employeeName, this.employeePhoto, this.approvedBy});
  factory _OvertimeRequestModel.fromJson(Map<String, dynamic> json) => _$OvertimeRequestModelFromJson(json);

@override final  int id;
@override final  String date;
@override final  String startTime;
@override final  String endTime;
@override final  double hours;
@override final  double amount;
@override final  String status;
@override final  String reason;
@override final  String? approverComment;
@override final  String? createdAt;
@override final  String? employeeName;
@override final  String? employeePhoto;
@override final  String? approvedBy;

/// Create a copy of OvertimeRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OvertimeRequestModelCopyWith<_OvertimeRequestModel> get copyWith => __$OvertimeRequestModelCopyWithImpl<_OvertimeRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OvertimeRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OvertimeRequestModel&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.hours, hours) || other.hours == hours)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.approverComment, approverComment) || other.approverComment == approverComment)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.employeeName, employeeName) || other.employeeName == employeeName)&&(identical(other.employeePhoto, employeePhoto) || other.employeePhoto == employeePhoto)&&(identical(other.approvedBy, approvedBy) || other.approvedBy == approvedBy));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,date,startTime,endTime,hours,amount,status,reason,approverComment,createdAt,employeeName,employeePhoto,approvedBy);

@override
String toString() {
  return 'OvertimeRequestModel(id: $id, date: $date, startTime: $startTime, endTime: $endTime, hours: $hours, amount: $amount, status: $status, reason: $reason, approverComment: $approverComment, createdAt: $createdAt, employeeName: $employeeName, employeePhoto: $employeePhoto, approvedBy: $approvedBy)';
}


}

/// @nodoc
abstract mixin class _$OvertimeRequestModelCopyWith<$Res> implements $OvertimeRequestModelCopyWith<$Res> {
  factory _$OvertimeRequestModelCopyWith(_OvertimeRequestModel value, $Res Function(_OvertimeRequestModel) _then) = __$OvertimeRequestModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String date, String startTime, String endTime, double hours, double amount, String status, String reason, String? approverComment, String? createdAt, String? employeeName, String? employeePhoto, String? approvedBy
});




}
/// @nodoc
class __$OvertimeRequestModelCopyWithImpl<$Res>
    implements _$OvertimeRequestModelCopyWith<$Res> {
  __$OvertimeRequestModelCopyWithImpl(this._self, this._then);

  final _OvertimeRequestModel _self;
  final $Res Function(_OvertimeRequestModel) _then;

/// Create a copy of OvertimeRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? startTime = null,Object? endTime = null,Object? hours = null,Object? amount = null,Object? status = null,Object? reason = null,Object? approverComment = freezed,Object? createdAt = freezed,Object? employeeName = freezed,Object? employeePhoto = freezed,Object? approvedBy = freezed,}) {
  return _then(_OvertimeRequestModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as String,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as String,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as double,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,approverComment: freezed == approverComment ? _self.approverComment : approverComment // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,employeeName: freezed == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String?,employeePhoto: freezed == employeePhoto ? _self.employeePhoto : employeePhoto // ignore: cast_nullable_to_non_nullable
as String?,approvedBy: freezed == approvedBy ? _self.approvedBy : approvedBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$OvertimeSummaryModel {

 double get totalApprovedHours; double get totalAmount; int get pendingCount;
/// Create a copy of OvertimeSummaryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OvertimeSummaryModelCopyWith<OvertimeSummaryModel> get copyWith => _$OvertimeSummaryModelCopyWithImpl<OvertimeSummaryModel>(this as OvertimeSummaryModel, _$identity);

  /// Serializes this OvertimeSummaryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OvertimeSummaryModel&&(identical(other.totalApprovedHours, totalApprovedHours) || other.totalApprovedHours == totalApprovedHours)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.pendingCount, pendingCount) || other.pendingCount == pendingCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalApprovedHours,totalAmount,pendingCount);

@override
String toString() {
  return 'OvertimeSummaryModel(totalApprovedHours: $totalApprovedHours, totalAmount: $totalAmount, pendingCount: $pendingCount)';
}


}

/// @nodoc
abstract mixin class $OvertimeSummaryModelCopyWith<$Res>  {
  factory $OvertimeSummaryModelCopyWith(OvertimeSummaryModel value, $Res Function(OvertimeSummaryModel) _then) = _$OvertimeSummaryModelCopyWithImpl;
@useResult
$Res call({
 double totalApprovedHours, double totalAmount, int pendingCount
});




}
/// @nodoc
class _$OvertimeSummaryModelCopyWithImpl<$Res>
    implements $OvertimeSummaryModelCopyWith<$Res> {
  _$OvertimeSummaryModelCopyWithImpl(this._self, this._then);

  final OvertimeSummaryModel _self;
  final $Res Function(OvertimeSummaryModel) _then;

/// Create a copy of OvertimeSummaryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalApprovedHours = null,Object? totalAmount = null,Object? pendingCount = null,}) {
  return _then(_self.copyWith(
totalApprovedHours: null == totalApprovedHours ? _self.totalApprovedHours : totalApprovedHours // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,pendingCount: null == pendingCount ? _self.pendingCount : pendingCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OvertimeSummaryModel].
extension OvertimeSummaryModelPatterns on OvertimeSummaryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OvertimeSummaryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OvertimeSummaryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OvertimeSummaryModel value)  $default,){
final _that = this;
switch (_that) {
case _OvertimeSummaryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OvertimeSummaryModel value)?  $default,){
final _that = this;
switch (_that) {
case _OvertimeSummaryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double totalApprovedHours,  double totalAmount,  int pendingCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OvertimeSummaryModel() when $default != null:
return $default(_that.totalApprovedHours,_that.totalAmount,_that.pendingCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double totalApprovedHours,  double totalAmount,  int pendingCount)  $default,) {final _that = this;
switch (_that) {
case _OvertimeSummaryModel():
return $default(_that.totalApprovedHours,_that.totalAmount,_that.pendingCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double totalApprovedHours,  double totalAmount,  int pendingCount)?  $default,) {final _that = this;
switch (_that) {
case _OvertimeSummaryModel() when $default != null:
return $default(_that.totalApprovedHours,_that.totalAmount,_that.pendingCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OvertimeSummaryModel implements OvertimeSummaryModel {
  const _OvertimeSummaryModel({required this.totalApprovedHours, required this.totalAmount, required this.pendingCount});
  factory _OvertimeSummaryModel.fromJson(Map<String, dynamic> json) => _$OvertimeSummaryModelFromJson(json);

@override final  double totalApprovedHours;
@override final  double totalAmount;
@override final  int pendingCount;

/// Create a copy of OvertimeSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OvertimeSummaryModelCopyWith<_OvertimeSummaryModel> get copyWith => __$OvertimeSummaryModelCopyWithImpl<_OvertimeSummaryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OvertimeSummaryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OvertimeSummaryModel&&(identical(other.totalApprovedHours, totalApprovedHours) || other.totalApprovedHours == totalApprovedHours)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.pendingCount, pendingCount) || other.pendingCount == pendingCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,totalApprovedHours,totalAmount,pendingCount);

@override
String toString() {
  return 'OvertimeSummaryModel(totalApprovedHours: $totalApprovedHours, totalAmount: $totalAmount, pendingCount: $pendingCount)';
}


}

/// @nodoc
abstract mixin class _$OvertimeSummaryModelCopyWith<$Res> implements $OvertimeSummaryModelCopyWith<$Res> {
  factory _$OvertimeSummaryModelCopyWith(_OvertimeSummaryModel value, $Res Function(_OvertimeSummaryModel) _then) = __$OvertimeSummaryModelCopyWithImpl;
@override @useResult
$Res call({
 double totalApprovedHours, double totalAmount, int pendingCount
});




}
/// @nodoc
class __$OvertimeSummaryModelCopyWithImpl<$Res>
    implements _$OvertimeSummaryModelCopyWith<$Res> {
  __$OvertimeSummaryModelCopyWithImpl(this._self, this._then);

  final _OvertimeSummaryModel _self;
  final $Res Function(_OvertimeSummaryModel) _then;

/// Create a copy of OvertimeSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalApprovedHours = null,Object? totalAmount = null,Object? pendingCount = null,}) {
  return _then(_OvertimeSummaryModel(
totalApprovedHours: null == totalApprovedHours ? _self.totalApprovedHours : totalApprovedHours // ignore: cast_nullable_to_non_nullable
as double,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,pendingCount: null == pendingCount ? _self.pendingCount : pendingCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
