// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_data_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DashboardDataModel {

 List<LeaveBalanceModel>? get leaveBalances; int? get pendingLeaveCount; int? get pendingApprovalsCount; int? get mandatoryTrainingDue; double? get myLearningProgress; int? get pendingExpenseClaimsCount; String? get nearestTrainingDeadline; String? get nearestTrainingTitle;
/// Create a copy of DashboardDataModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardDataModelCopyWith<DashboardDataModel> get copyWith => _$DashboardDataModelCopyWithImpl<DashboardDataModel>(this as DashboardDataModel, _$identity);

  /// Serializes this DashboardDataModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardDataModel&&const DeepCollectionEquality().equals(other.leaveBalances, leaveBalances)&&(identical(other.pendingLeaveCount, pendingLeaveCount) || other.pendingLeaveCount == pendingLeaveCount)&&(identical(other.pendingApprovalsCount, pendingApprovalsCount) || other.pendingApprovalsCount == pendingApprovalsCount)&&(identical(other.mandatoryTrainingDue, mandatoryTrainingDue) || other.mandatoryTrainingDue == mandatoryTrainingDue)&&(identical(other.myLearningProgress, myLearningProgress) || other.myLearningProgress == myLearningProgress)&&(identical(other.pendingExpenseClaimsCount, pendingExpenseClaimsCount) || other.pendingExpenseClaimsCount == pendingExpenseClaimsCount)&&(identical(other.nearestTrainingDeadline, nearestTrainingDeadline) || other.nearestTrainingDeadline == nearestTrainingDeadline)&&(identical(other.nearestTrainingTitle, nearestTrainingTitle) || other.nearestTrainingTitle == nearestTrainingTitle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(leaveBalances),pendingLeaveCount,pendingApprovalsCount,mandatoryTrainingDue,myLearningProgress,pendingExpenseClaimsCount,nearestTrainingDeadline,nearestTrainingTitle);

@override
String toString() {
  return 'DashboardDataModel(leaveBalances: $leaveBalances, pendingLeaveCount: $pendingLeaveCount, pendingApprovalsCount: $pendingApprovalsCount, mandatoryTrainingDue: $mandatoryTrainingDue, myLearningProgress: $myLearningProgress, pendingExpenseClaimsCount: $pendingExpenseClaimsCount, nearestTrainingDeadline: $nearestTrainingDeadline, nearestTrainingTitle: $nearestTrainingTitle)';
}


}

/// @nodoc
abstract mixin class $DashboardDataModelCopyWith<$Res>  {
  factory $DashboardDataModelCopyWith(DashboardDataModel value, $Res Function(DashboardDataModel) _then) = _$DashboardDataModelCopyWithImpl;
@useResult
$Res call({
 List<LeaveBalanceModel>? leaveBalances, int? pendingLeaveCount, int? pendingApprovalsCount, int? mandatoryTrainingDue, double? myLearningProgress, int? pendingExpenseClaimsCount, String? nearestTrainingDeadline, String? nearestTrainingTitle
});




}
/// @nodoc
class _$DashboardDataModelCopyWithImpl<$Res>
    implements $DashboardDataModelCopyWith<$Res> {
  _$DashboardDataModelCopyWithImpl(this._self, this._then);

  final DashboardDataModel _self;
  final $Res Function(DashboardDataModel) _then;

/// Create a copy of DashboardDataModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? leaveBalances = freezed,Object? pendingLeaveCount = freezed,Object? pendingApprovalsCount = freezed,Object? mandatoryTrainingDue = freezed,Object? myLearningProgress = freezed,Object? pendingExpenseClaimsCount = freezed,Object? nearestTrainingDeadline = freezed,Object? nearestTrainingTitle = freezed,}) {
  return _then(_self.copyWith(
leaveBalances: freezed == leaveBalances ? _self.leaveBalances : leaveBalances // ignore: cast_nullable_to_non_nullable
as List<LeaveBalanceModel>?,pendingLeaveCount: freezed == pendingLeaveCount ? _self.pendingLeaveCount : pendingLeaveCount // ignore: cast_nullable_to_non_nullable
as int?,pendingApprovalsCount: freezed == pendingApprovalsCount ? _self.pendingApprovalsCount : pendingApprovalsCount // ignore: cast_nullable_to_non_nullable
as int?,mandatoryTrainingDue: freezed == mandatoryTrainingDue ? _self.mandatoryTrainingDue : mandatoryTrainingDue // ignore: cast_nullable_to_non_nullable
as int?,myLearningProgress: freezed == myLearningProgress ? _self.myLearningProgress : myLearningProgress // ignore: cast_nullable_to_non_nullable
as double?,pendingExpenseClaimsCount: freezed == pendingExpenseClaimsCount ? _self.pendingExpenseClaimsCount : pendingExpenseClaimsCount // ignore: cast_nullable_to_non_nullable
as int?,nearestTrainingDeadline: freezed == nearestTrainingDeadline ? _self.nearestTrainingDeadline : nearestTrainingDeadline // ignore: cast_nullable_to_non_nullable
as String?,nearestTrainingTitle: freezed == nearestTrainingTitle ? _self.nearestTrainingTitle : nearestTrainingTitle // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardDataModel].
extension DashboardDataModelPatterns on DashboardDataModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardDataModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardDataModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardDataModel value)  $default,){
final _that = this;
switch (_that) {
case _DashboardDataModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardDataModel value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardDataModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<LeaveBalanceModel>? leaveBalances,  int? pendingLeaveCount,  int? pendingApprovalsCount,  int? mandatoryTrainingDue,  double? myLearningProgress,  int? pendingExpenseClaimsCount,  String? nearestTrainingDeadline,  String? nearestTrainingTitle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardDataModel() when $default != null:
return $default(_that.leaveBalances,_that.pendingLeaveCount,_that.pendingApprovalsCount,_that.mandatoryTrainingDue,_that.myLearningProgress,_that.pendingExpenseClaimsCount,_that.nearestTrainingDeadline,_that.nearestTrainingTitle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<LeaveBalanceModel>? leaveBalances,  int? pendingLeaveCount,  int? pendingApprovalsCount,  int? mandatoryTrainingDue,  double? myLearningProgress,  int? pendingExpenseClaimsCount,  String? nearestTrainingDeadline,  String? nearestTrainingTitle)  $default,) {final _that = this;
switch (_that) {
case _DashboardDataModel():
return $default(_that.leaveBalances,_that.pendingLeaveCount,_that.pendingApprovalsCount,_that.mandatoryTrainingDue,_that.myLearningProgress,_that.pendingExpenseClaimsCount,_that.nearestTrainingDeadline,_that.nearestTrainingTitle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<LeaveBalanceModel>? leaveBalances,  int? pendingLeaveCount,  int? pendingApprovalsCount,  int? mandatoryTrainingDue,  double? myLearningProgress,  int? pendingExpenseClaimsCount,  String? nearestTrainingDeadline,  String? nearestTrainingTitle)?  $default,) {final _that = this;
switch (_that) {
case _DashboardDataModel() when $default != null:
return $default(_that.leaveBalances,_that.pendingLeaveCount,_that.pendingApprovalsCount,_that.mandatoryTrainingDue,_that.myLearningProgress,_that.pendingExpenseClaimsCount,_that.nearestTrainingDeadline,_that.nearestTrainingTitle);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DashboardDataModel implements DashboardDataModel {
  const _DashboardDataModel({final  List<LeaveBalanceModel>? leaveBalances, this.pendingLeaveCount, this.pendingApprovalsCount, this.mandatoryTrainingDue, this.myLearningProgress, this.pendingExpenseClaimsCount, this.nearestTrainingDeadline, this.nearestTrainingTitle}): _leaveBalances = leaveBalances;
  factory _DashboardDataModel.fromJson(Map<String, dynamic> json) => _$DashboardDataModelFromJson(json);

 final  List<LeaveBalanceModel>? _leaveBalances;
@override List<LeaveBalanceModel>? get leaveBalances {
  final value = _leaveBalances;
  if (value == null) return null;
  if (_leaveBalances is EqualUnmodifiableListView) return _leaveBalances;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  int? pendingLeaveCount;
@override final  int? pendingApprovalsCount;
@override final  int? mandatoryTrainingDue;
@override final  double? myLearningProgress;
@override final  int? pendingExpenseClaimsCount;
@override final  String? nearestTrainingDeadline;
@override final  String? nearestTrainingTitle;

/// Create a copy of DashboardDataModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardDataModelCopyWith<_DashboardDataModel> get copyWith => __$DashboardDataModelCopyWithImpl<_DashboardDataModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DashboardDataModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardDataModel&&const DeepCollectionEquality().equals(other._leaveBalances, _leaveBalances)&&(identical(other.pendingLeaveCount, pendingLeaveCount) || other.pendingLeaveCount == pendingLeaveCount)&&(identical(other.pendingApprovalsCount, pendingApprovalsCount) || other.pendingApprovalsCount == pendingApprovalsCount)&&(identical(other.mandatoryTrainingDue, mandatoryTrainingDue) || other.mandatoryTrainingDue == mandatoryTrainingDue)&&(identical(other.myLearningProgress, myLearningProgress) || other.myLearningProgress == myLearningProgress)&&(identical(other.pendingExpenseClaimsCount, pendingExpenseClaimsCount) || other.pendingExpenseClaimsCount == pendingExpenseClaimsCount)&&(identical(other.nearestTrainingDeadline, nearestTrainingDeadline) || other.nearestTrainingDeadline == nearestTrainingDeadline)&&(identical(other.nearestTrainingTitle, nearestTrainingTitle) || other.nearestTrainingTitle == nearestTrainingTitle));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_leaveBalances),pendingLeaveCount,pendingApprovalsCount,mandatoryTrainingDue,myLearningProgress,pendingExpenseClaimsCount,nearestTrainingDeadline,nearestTrainingTitle);

@override
String toString() {
  return 'DashboardDataModel(leaveBalances: $leaveBalances, pendingLeaveCount: $pendingLeaveCount, pendingApprovalsCount: $pendingApprovalsCount, mandatoryTrainingDue: $mandatoryTrainingDue, myLearningProgress: $myLearningProgress, pendingExpenseClaimsCount: $pendingExpenseClaimsCount, nearestTrainingDeadline: $nearestTrainingDeadline, nearestTrainingTitle: $nearestTrainingTitle)';
}


}

/// @nodoc
abstract mixin class _$DashboardDataModelCopyWith<$Res> implements $DashboardDataModelCopyWith<$Res> {
  factory _$DashboardDataModelCopyWith(_DashboardDataModel value, $Res Function(_DashboardDataModel) _then) = __$DashboardDataModelCopyWithImpl;
@override @useResult
$Res call({
 List<LeaveBalanceModel>? leaveBalances, int? pendingLeaveCount, int? pendingApprovalsCount, int? mandatoryTrainingDue, double? myLearningProgress, int? pendingExpenseClaimsCount, String? nearestTrainingDeadline, String? nearestTrainingTitle
});




}
/// @nodoc
class __$DashboardDataModelCopyWithImpl<$Res>
    implements _$DashboardDataModelCopyWith<$Res> {
  __$DashboardDataModelCopyWithImpl(this._self, this._then);

  final _DashboardDataModel _self;
  final $Res Function(_DashboardDataModel) _then;

/// Create a copy of DashboardDataModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? leaveBalances = freezed,Object? pendingLeaveCount = freezed,Object? pendingApprovalsCount = freezed,Object? mandatoryTrainingDue = freezed,Object? myLearningProgress = freezed,Object? pendingExpenseClaimsCount = freezed,Object? nearestTrainingDeadline = freezed,Object? nearestTrainingTitle = freezed,}) {
  return _then(_DashboardDataModel(
leaveBalances: freezed == leaveBalances ? _self._leaveBalances : leaveBalances // ignore: cast_nullable_to_non_nullable
as List<LeaveBalanceModel>?,pendingLeaveCount: freezed == pendingLeaveCount ? _self.pendingLeaveCount : pendingLeaveCount // ignore: cast_nullable_to_non_nullable
as int?,pendingApprovalsCount: freezed == pendingApprovalsCount ? _self.pendingApprovalsCount : pendingApprovalsCount // ignore: cast_nullable_to_non_nullable
as int?,mandatoryTrainingDue: freezed == mandatoryTrainingDue ? _self.mandatoryTrainingDue : mandatoryTrainingDue // ignore: cast_nullable_to_non_nullable
as int?,myLearningProgress: freezed == myLearningProgress ? _self.myLearningProgress : myLearningProgress // ignore: cast_nullable_to_non_nullable
as double?,pendingExpenseClaimsCount: freezed == pendingExpenseClaimsCount ? _self.pendingExpenseClaimsCount : pendingExpenseClaimsCount // ignore: cast_nullable_to_non_nullable
as int?,nearestTrainingDeadline: freezed == nearestTrainingDeadline ? _self.nearestTrainingDeadline : nearestTrainingDeadline // ignore: cast_nullable_to_non_nullable
as String?,nearestTrainingTitle: freezed == nearestTrainingTitle ? _self.nearestTrainingTitle : nearestTrainingTitle // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
