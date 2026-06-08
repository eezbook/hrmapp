// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attendance_summary_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AttendanceSummaryModel {

 int get month; int get year; String get monthName; int get workingDays; int get presentDays; int get absentDays; int get lateDays; int get halfDays; int get leaveDays; int get travelDays; int get holidayDays; int get weekendDays; double get totalWorkingHours; double get averageWorkingHours; double get attendancePercentage;
/// Create a copy of AttendanceSummaryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttendanceSummaryModelCopyWith<AttendanceSummaryModel> get copyWith => _$AttendanceSummaryModelCopyWithImpl<AttendanceSummaryModel>(this as AttendanceSummaryModel, _$identity);

  /// Serializes this AttendanceSummaryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttendanceSummaryModel&&(identical(other.month, month) || other.month == month)&&(identical(other.year, year) || other.year == year)&&(identical(other.monthName, monthName) || other.monthName == monthName)&&(identical(other.workingDays, workingDays) || other.workingDays == workingDays)&&(identical(other.presentDays, presentDays) || other.presentDays == presentDays)&&(identical(other.absentDays, absentDays) || other.absentDays == absentDays)&&(identical(other.lateDays, lateDays) || other.lateDays == lateDays)&&(identical(other.halfDays, halfDays) || other.halfDays == halfDays)&&(identical(other.leaveDays, leaveDays) || other.leaveDays == leaveDays)&&(identical(other.travelDays, travelDays) || other.travelDays == travelDays)&&(identical(other.holidayDays, holidayDays) || other.holidayDays == holidayDays)&&(identical(other.weekendDays, weekendDays) || other.weekendDays == weekendDays)&&(identical(other.totalWorkingHours, totalWorkingHours) || other.totalWorkingHours == totalWorkingHours)&&(identical(other.averageWorkingHours, averageWorkingHours) || other.averageWorkingHours == averageWorkingHours)&&(identical(other.attendancePercentage, attendancePercentage) || other.attendancePercentage == attendancePercentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,year,monthName,workingDays,presentDays,absentDays,lateDays,halfDays,leaveDays,travelDays,holidayDays,weekendDays,totalWorkingHours,averageWorkingHours,attendancePercentage);

@override
String toString() {
  return 'AttendanceSummaryModel(month: $month, year: $year, monthName: $monthName, workingDays: $workingDays, presentDays: $presentDays, absentDays: $absentDays, lateDays: $lateDays, halfDays: $halfDays, leaveDays: $leaveDays, travelDays: $travelDays, holidayDays: $holidayDays, weekendDays: $weekendDays, totalWorkingHours: $totalWorkingHours, averageWorkingHours: $averageWorkingHours, attendancePercentage: $attendancePercentage)';
}


}

/// @nodoc
abstract mixin class $AttendanceSummaryModelCopyWith<$Res>  {
  factory $AttendanceSummaryModelCopyWith(AttendanceSummaryModel value, $Res Function(AttendanceSummaryModel) _then) = _$AttendanceSummaryModelCopyWithImpl;
@useResult
$Res call({
 int month, int year, String monthName, int workingDays, int presentDays, int absentDays, int lateDays, int halfDays, int leaveDays, int travelDays, int holidayDays, int weekendDays, double totalWorkingHours, double averageWorkingHours, double attendancePercentage
});




}
/// @nodoc
class _$AttendanceSummaryModelCopyWithImpl<$Res>
    implements $AttendanceSummaryModelCopyWith<$Res> {
  _$AttendanceSummaryModelCopyWithImpl(this._self, this._then);

  final AttendanceSummaryModel _self;
  final $Res Function(AttendanceSummaryModel) _then;

/// Create a copy of AttendanceSummaryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? month = null,Object? year = null,Object? monthName = null,Object? workingDays = null,Object? presentDays = null,Object? absentDays = null,Object? lateDays = null,Object? halfDays = null,Object? leaveDays = null,Object? travelDays = null,Object? holidayDays = null,Object? weekendDays = null,Object? totalWorkingHours = null,Object? averageWorkingHours = null,Object? attendancePercentage = null,}) {
  return _then(_self.copyWith(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,monthName: null == monthName ? _self.monthName : monthName // ignore: cast_nullable_to_non_nullable
as String,workingDays: null == workingDays ? _self.workingDays : workingDays // ignore: cast_nullable_to_non_nullable
as int,presentDays: null == presentDays ? _self.presentDays : presentDays // ignore: cast_nullable_to_non_nullable
as int,absentDays: null == absentDays ? _self.absentDays : absentDays // ignore: cast_nullable_to_non_nullable
as int,lateDays: null == lateDays ? _self.lateDays : lateDays // ignore: cast_nullable_to_non_nullable
as int,halfDays: null == halfDays ? _self.halfDays : halfDays // ignore: cast_nullable_to_non_nullable
as int,leaveDays: null == leaveDays ? _self.leaveDays : leaveDays // ignore: cast_nullable_to_non_nullable
as int,travelDays: null == travelDays ? _self.travelDays : travelDays // ignore: cast_nullable_to_non_nullable
as int,holidayDays: null == holidayDays ? _self.holidayDays : holidayDays // ignore: cast_nullable_to_non_nullable
as int,weekendDays: null == weekendDays ? _self.weekendDays : weekendDays // ignore: cast_nullable_to_non_nullable
as int,totalWorkingHours: null == totalWorkingHours ? _self.totalWorkingHours : totalWorkingHours // ignore: cast_nullable_to_non_nullable
as double,averageWorkingHours: null == averageWorkingHours ? _self.averageWorkingHours : averageWorkingHours // ignore: cast_nullable_to_non_nullable
as double,attendancePercentage: null == attendancePercentage ? _self.attendancePercentage : attendancePercentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AttendanceSummaryModel].
extension AttendanceSummaryModelPatterns on AttendanceSummaryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttendanceSummaryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttendanceSummaryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttendanceSummaryModel value)  $default,){
final _that = this;
switch (_that) {
case _AttendanceSummaryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttendanceSummaryModel value)?  $default,){
final _that = this;
switch (_that) {
case _AttendanceSummaryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int month,  int year,  String monthName,  int workingDays,  int presentDays,  int absentDays,  int lateDays,  int halfDays,  int leaveDays,  int travelDays,  int holidayDays,  int weekendDays,  double totalWorkingHours,  double averageWorkingHours,  double attendancePercentage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttendanceSummaryModel() when $default != null:
return $default(_that.month,_that.year,_that.monthName,_that.workingDays,_that.presentDays,_that.absentDays,_that.lateDays,_that.halfDays,_that.leaveDays,_that.travelDays,_that.holidayDays,_that.weekendDays,_that.totalWorkingHours,_that.averageWorkingHours,_that.attendancePercentage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int month,  int year,  String monthName,  int workingDays,  int presentDays,  int absentDays,  int lateDays,  int halfDays,  int leaveDays,  int travelDays,  int holidayDays,  int weekendDays,  double totalWorkingHours,  double averageWorkingHours,  double attendancePercentage)  $default,) {final _that = this;
switch (_that) {
case _AttendanceSummaryModel():
return $default(_that.month,_that.year,_that.monthName,_that.workingDays,_that.presentDays,_that.absentDays,_that.lateDays,_that.halfDays,_that.leaveDays,_that.travelDays,_that.holidayDays,_that.weekendDays,_that.totalWorkingHours,_that.averageWorkingHours,_that.attendancePercentage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int month,  int year,  String monthName,  int workingDays,  int presentDays,  int absentDays,  int lateDays,  int halfDays,  int leaveDays,  int travelDays,  int holidayDays,  int weekendDays,  double totalWorkingHours,  double averageWorkingHours,  double attendancePercentage)?  $default,) {final _that = this;
switch (_that) {
case _AttendanceSummaryModel() when $default != null:
return $default(_that.month,_that.year,_that.monthName,_that.workingDays,_that.presentDays,_that.absentDays,_that.lateDays,_that.halfDays,_that.leaveDays,_that.travelDays,_that.holidayDays,_that.weekendDays,_that.totalWorkingHours,_that.averageWorkingHours,_that.attendancePercentage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AttendanceSummaryModel implements AttendanceSummaryModel {
  const _AttendanceSummaryModel({required this.month, required this.year, required this.monthName, this.workingDays = 0, this.presentDays = 0, this.absentDays = 0, this.lateDays = 0, this.halfDays = 0, this.leaveDays = 0, this.travelDays = 0, this.holidayDays = 0, this.weekendDays = 0, this.totalWorkingHours = 0.0, this.averageWorkingHours = 0.0, this.attendancePercentage = 0.0});
  factory _AttendanceSummaryModel.fromJson(Map<String, dynamic> json) => _$AttendanceSummaryModelFromJson(json);

@override final  int month;
@override final  int year;
@override final  String monthName;
@override@JsonKey() final  int workingDays;
@override@JsonKey() final  int presentDays;
@override@JsonKey() final  int absentDays;
@override@JsonKey() final  int lateDays;
@override@JsonKey() final  int halfDays;
@override@JsonKey() final  int leaveDays;
@override@JsonKey() final  int travelDays;
@override@JsonKey() final  int holidayDays;
@override@JsonKey() final  int weekendDays;
@override@JsonKey() final  double totalWorkingHours;
@override@JsonKey() final  double averageWorkingHours;
@override@JsonKey() final  double attendancePercentage;

/// Create a copy of AttendanceSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttendanceSummaryModelCopyWith<_AttendanceSummaryModel> get copyWith => __$AttendanceSummaryModelCopyWithImpl<_AttendanceSummaryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AttendanceSummaryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttendanceSummaryModel&&(identical(other.month, month) || other.month == month)&&(identical(other.year, year) || other.year == year)&&(identical(other.monthName, monthName) || other.monthName == monthName)&&(identical(other.workingDays, workingDays) || other.workingDays == workingDays)&&(identical(other.presentDays, presentDays) || other.presentDays == presentDays)&&(identical(other.absentDays, absentDays) || other.absentDays == absentDays)&&(identical(other.lateDays, lateDays) || other.lateDays == lateDays)&&(identical(other.halfDays, halfDays) || other.halfDays == halfDays)&&(identical(other.leaveDays, leaveDays) || other.leaveDays == leaveDays)&&(identical(other.travelDays, travelDays) || other.travelDays == travelDays)&&(identical(other.holidayDays, holidayDays) || other.holidayDays == holidayDays)&&(identical(other.weekendDays, weekendDays) || other.weekendDays == weekendDays)&&(identical(other.totalWorkingHours, totalWorkingHours) || other.totalWorkingHours == totalWorkingHours)&&(identical(other.averageWorkingHours, averageWorkingHours) || other.averageWorkingHours == averageWorkingHours)&&(identical(other.attendancePercentage, attendancePercentage) || other.attendancePercentage == attendancePercentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,month,year,monthName,workingDays,presentDays,absentDays,lateDays,halfDays,leaveDays,travelDays,holidayDays,weekendDays,totalWorkingHours,averageWorkingHours,attendancePercentage);

@override
String toString() {
  return 'AttendanceSummaryModel(month: $month, year: $year, monthName: $monthName, workingDays: $workingDays, presentDays: $presentDays, absentDays: $absentDays, lateDays: $lateDays, halfDays: $halfDays, leaveDays: $leaveDays, travelDays: $travelDays, holidayDays: $holidayDays, weekendDays: $weekendDays, totalWorkingHours: $totalWorkingHours, averageWorkingHours: $averageWorkingHours, attendancePercentage: $attendancePercentage)';
}


}

/// @nodoc
abstract mixin class _$AttendanceSummaryModelCopyWith<$Res> implements $AttendanceSummaryModelCopyWith<$Res> {
  factory _$AttendanceSummaryModelCopyWith(_AttendanceSummaryModel value, $Res Function(_AttendanceSummaryModel) _then) = __$AttendanceSummaryModelCopyWithImpl;
@override @useResult
$Res call({
 int month, int year, String monthName, int workingDays, int presentDays, int absentDays, int lateDays, int halfDays, int leaveDays, int travelDays, int holidayDays, int weekendDays, double totalWorkingHours, double averageWorkingHours, double attendancePercentage
});




}
/// @nodoc
class __$AttendanceSummaryModelCopyWithImpl<$Res>
    implements _$AttendanceSummaryModelCopyWith<$Res> {
  __$AttendanceSummaryModelCopyWithImpl(this._self, this._then);

  final _AttendanceSummaryModel _self;
  final $Res Function(_AttendanceSummaryModel) _then;

/// Create a copy of AttendanceSummaryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? month = null,Object? year = null,Object? monthName = null,Object? workingDays = null,Object? presentDays = null,Object? absentDays = null,Object? lateDays = null,Object? halfDays = null,Object? leaveDays = null,Object? travelDays = null,Object? holidayDays = null,Object? weekendDays = null,Object? totalWorkingHours = null,Object? averageWorkingHours = null,Object? attendancePercentage = null,}) {
  return _then(_AttendanceSummaryModel(
month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,monthName: null == monthName ? _self.monthName : monthName // ignore: cast_nullable_to_non_nullable
as String,workingDays: null == workingDays ? _self.workingDays : workingDays // ignore: cast_nullable_to_non_nullable
as int,presentDays: null == presentDays ? _self.presentDays : presentDays // ignore: cast_nullable_to_non_nullable
as int,absentDays: null == absentDays ? _self.absentDays : absentDays // ignore: cast_nullable_to_non_nullable
as int,lateDays: null == lateDays ? _self.lateDays : lateDays // ignore: cast_nullable_to_non_nullable
as int,halfDays: null == halfDays ? _self.halfDays : halfDays // ignore: cast_nullable_to_non_nullable
as int,leaveDays: null == leaveDays ? _self.leaveDays : leaveDays // ignore: cast_nullable_to_non_nullable
as int,travelDays: null == travelDays ? _self.travelDays : travelDays // ignore: cast_nullable_to_non_nullable
as int,holidayDays: null == holidayDays ? _self.holidayDays : holidayDays // ignore: cast_nullable_to_non_nullable
as int,weekendDays: null == weekendDays ? _self.weekendDays : weekendDays // ignore: cast_nullable_to_non_nullable
as int,totalWorkingHours: null == totalWorkingHours ? _self.totalWorkingHours : totalWorkingHours // ignore: cast_nullable_to_non_nullable
as double,averageWorkingHours: null == averageWorkingHours ? _self.averageWorkingHours : averageWorkingHours // ignore: cast_nullable_to_non_nullable
as double,attendancePercentage: null == attendancePercentage ? _self.attendancePercentage : attendancePercentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
