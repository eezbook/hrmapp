// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'training_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TrainingRequestModel {

 int get id; String get trainingTitle; String? get trainingType; String? get trainingLocation; String get startDate; String get endDate; int get totalDays; double get advanceAmount; String get status; String? get mainNarration; String? get createdAt; String? get employeeName; String? get employeePhoto;
/// Create a copy of TrainingRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrainingRequestModelCopyWith<TrainingRequestModel> get copyWith => _$TrainingRequestModelCopyWithImpl<TrainingRequestModel>(this as TrainingRequestModel, _$identity);

  /// Serializes this TrainingRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TrainingRequestModel&&(identical(other.id, id) || other.id == id)&&(identical(other.trainingTitle, trainingTitle) || other.trainingTitle == trainingTitle)&&(identical(other.trainingType, trainingType) || other.trainingType == trainingType)&&(identical(other.trainingLocation, trainingLocation) || other.trainingLocation == trainingLocation)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.totalDays, totalDays) || other.totalDays == totalDays)&&(identical(other.advanceAmount, advanceAmount) || other.advanceAmount == advanceAmount)&&(identical(other.status, status) || other.status == status)&&(identical(other.mainNarration, mainNarration) || other.mainNarration == mainNarration)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.employeeName, employeeName) || other.employeeName == employeeName)&&(identical(other.employeePhoto, employeePhoto) || other.employeePhoto == employeePhoto));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,trainingTitle,trainingType,trainingLocation,startDate,endDate,totalDays,advanceAmount,status,mainNarration,createdAt,employeeName,employeePhoto);

@override
String toString() {
  return 'TrainingRequestModel(id: $id, trainingTitle: $trainingTitle, trainingType: $trainingType, trainingLocation: $trainingLocation, startDate: $startDate, endDate: $endDate, totalDays: $totalDays, advanceAmount: $advanceAmount, status: $status, mainNarration: $mainNarration, createdAt: $createdAt, employeeName: $employeeName, employeePhoto: $employeePhoto)';
}


}

/// @nodoc
abstract mixin class $TrainingRequestModelCopyWith<$Res>  {
  factory $TrainingRequestModelCopyWith(TrainingRequestModel value, $Res Function(TrainingRequestModel) _then) = _$TrainingRequestModelCopyWithImpl;
@useResult
$Res call({
 int id, String trainingTitle, String? trainingType, String? trainingLocation, String startDate, String endDate, int totalDays, double advanceAmount, String status, String? mainNarration, String? createdAt, String? employeeName, String? employeePhoto
});




}
/// @nodoc
class _$TrainingRequestModelCopyWithImpl<$Res>
    implements $TrainingRequestModelCopyWith<$Res> {
  _$TrainingRequestModelCopyWithImpl(this._self, this._then);

  final TrainingRequestModel _self;
  final $Res Function(TrainingRequestModel) _then;

/// Create a copy of TrainingRequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? trainingTitle = null,Object? trainingType = freezed,Object? trainingLocation = freezed,Object? startDate = null,Object? endDate = null,Object? totalDays = null,Object? advanceAmount = null,Object? status = null,Object? mainNarration = freezed,Object? createdAt = freezed,Object? employeeName = freezed,Object? employeePhoto = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,trainingTitle: null == trainingTitle ? _self.trainingTitle : trainingTitle // ignore: cast_nullable_to_non_nullable
as String,trainingType: freezed == trainingType ? _self.trainingType : trainingType // ignore: cast_nullable_to_non_nullable
as String?,trainingLocation: freezed == trainingLocation ? _self.trainingLocation : trainingLocation // ignore: cast_nullable_to_non_nullable
as String?,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String,totalDays: null == totalDays ? _self.totalDays : totalDays // ignore: cast_nullable_to_non_nullable
as int,advanceAmount: null == advanceAmount ? _self.advanceAmount : advanceAmount // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,mainNarration: freezed == mainNarration ? _self.mainNarration : mainNarration // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,employeeName: freezed == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String?,employeePhoto: freezed == employeePhoto ? _self.employeePhoto : employeePhoto // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TrainingRequestModel].
extension TrainingRequestModelPatterns on TrainingRequestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TrainingRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TrainingRequestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TrainingRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _TrainingRequestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TrainingRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _TrainingRequestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String trainingTitle,  String? trainingType,  String? trainingLocation,  String startDate,  String endDate,  int totalDays,  double advanceAmount,  String status,  String? mainNarration,  String? createdAt,  String? employeeName,  String? employeePhoto)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TrainingRequestModel() when $default != null:
return $default(_that.id,_that.trainingTitle,_that.trainingType,_that.trainingLocation,_that.startDate,_that.endDate,_that.totalDays,_that.advanceAmount,_that.status,_that.mainNarration,_that.createdAt,_that.employeeName,_that.employeePhoto);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String trainingTitle,  String? trainingType,  String? trainingLocation,  String startDate,  String endDate,  int totalDays,  double advanceAmount,  String status,  String? mainNarration,  String? createdAt,  String? employeeName,  String? employeePhoto)  $default,) {final _that = this;
switch (_that) {
case _TrainingRequestModel():
return $default(_that.id,_that.trainingTitle,_that.trainingType,_that.trainingLocation,_that.startDate,_that.endDate,_that.totalDays,_that.advanceAmount,_that.status,_that.mainNarration,_that.createdAt,_that.employeeName,_that.employeePhoto);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String trainingTitle,  String? trainingType,  String? trainingLocation,  String startDate,  String endDate,  int totalDays,  double advanceAmount,  String status,  String? mainNarration,  String? createdAt,  String? employeeName,  String? employeePhoto)?  $default,) {final _that = this;
switch (_that) {
case _TrainingRequestModel() when $default != null:
return $default(_that.id,_that.trainingTitle,_that.trainingType,_that.trainingLocation,_that.startDate,_that.endDate,_that.totalDays,_that.advanceAmount,_that.status,_that.mainNarration,_that.createdAt,_that.employeeName,_that.employeePhoto);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TrainingRequestModel implements TrainingRequestModel {
  const _TrainingRequestModel({required this.id, required this.trainingTitle, this.trainingType, this.trainingLocation, required this.startDate, required this.endDate, required this.totalDays, this.advanceAmount = 0.0, required this.status, this.mainNarration, this.createdAt, this.employeeName, this.employeePhoto});
  factory _TrainingRequestModel.fromJson(Map<String, dynamic> json) => _$TrainingRequestModelFromJson(json);

@override final  int id;
@override final  String trainingTitle;
@override final  String? trainingType;
@override final  String? trainingLocation;
@override final  String startDate;
@override final  String endDate;
@override final  int totalDays;
@override@JsonKey() final  double advanceAmount;
@override final  String status;
@override final  String? mainNarration;
@override final  String? createdAt;
@override final  String? employeeName;
@override final  String? employeePhoto;

/// Create a copy of TrainingRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrainingRequestModelCopyWith<_TrainingRequestModel> get copyWith => __$TrainingRequestModelCopyWithImpl<_TrainingRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrainingRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TrainingRequestModel&&(identical(other.id, id) || other.id == id)&&(identical(other.trainingTitle, trainingTitle) || other.trainingTitle == trainingTitle)&&(identical(other.trainingType, trainingType) || other.trainingType == trainingType)&&(identical(other.trainingLocation, trainingLocation) || other.trainingLocation == trainingLocation)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.totalDays, totalDays) || other.totalDays == totalDays)&&(identical(other.advanceAmount, advanceAmount) || other.advanceAmount == advanceAmount)&&(identical(other.status, status) || other.status == status)&&(identical(other.mainNarration, mainNarration) || other.mainNarration == mainNarration)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.employeeName, employeeName) || other.employeeName == employeeName)&&(identical(other.employeePhoto, employeePhoto) || other.employeePhoto == employeePhoto));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,trainingTitle,trainingType,trainingLocation,startDate,endDate,totalDays,advanceAmount,status,mainNarration,createdAt,employeeName,employeePhoto);

@override
String toString() {
  return 'TrainingRequestModel(id: $id, trainingTitle: $trainingTitle, trainingType: $trainingType, trainingLocation: $trainingLocation, startDate: $startDate, endDate: $endDate, totalDays: $totalDays, advanceAmount: $advanceAmount, status: $status, mainNarration: $mainNarration, createdAt: $createdAt, employeeName: $employeeName, employeePhoto: $employeePhoto)';
}


}

/// @nodoc
abstract mixin class _$TrainingRequestModelCopyWith<$Res> implements $TrainingRequestModelCopyWith<$Res> {
  factory _$TrainingRequestModelCopyWith(_TrainingRequestModel value, $Res Function(_TrainingRequestModel) _then) = __$TrainingRequestModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String trainingTitle, String? trainingType, String? trainingLocation, String startDate, String endDate, int totalDays, double advanceAmount, String status, String? mainNarration, String? createdAt, String? employeeName, String? employeePhoto
});




}
/// @nodoc
class __$TrainingRequestModelCopyWithImpl<$Res>
    implements _$TrainingRequestModelCopyWith<$Res> {
  __$TrainingRequestModelCopyWithImpl(this._self, this._then);

  final _TrainingRequestModel _self;
  final $Res Function(_TrainingRequestModel) _then;

/// Create a copy of TrainingRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? trainingTitle = null,Object? trainingType = freezed,Object? trainingLocation = freezed,Object? startDate = null,Object? endDate = null,Object? totalDays = null,Object? advanceAmount = null,Object? status = null,Object? mainNarration = freezed,Object? createdAt = freezed,Object? employeeName = freezed,Object? employeePhoto = freezed,}) {
  return _then(_TrainingRequestModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,trainingTitle: null == trainingTitle ? _self.trainingTitle : trainingTitle // ignore: cast_nullable_to_non_nullable
as String,trainingType: freezed == trainingType ? _self.trainingType : trainingType // ignore: cast_nullable_to_non_nullable
as String?,trainingLocation: freezed == trainingLocation ? _self.trainingLocation : trainingLocation // ignore: cast_nullable_to_non_nullable
as String?,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as String,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as String,totalDays: null == totalDays ? _self.totalDays : totalDays // ignore: cast_nullable_to_non_nullable
as int,advanceAmount: null == advanceAmount ? _self.advanceAmount : advanceAmount // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,mainNarration: freezed == mainNarration ? _self.mainNarration : mainNarration // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,employeeName: freezed == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String?,employeePhoto: freezed == employeePhoto ? _self.employeePhoto : employeePhoto // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
