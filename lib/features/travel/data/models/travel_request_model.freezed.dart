// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'travel_request_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TravelRequestModel {

 int get id; String get purpose; String get origin; String get destination; String get departureDate; String get returnDate; String get transportMode; double get estimatedBudget; String get status; String? get createdAt; String? get employeeName; String? get employeePhoto; double? get budgetLimit;
/// Create a copy of TravelRequestModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TravelRequestModelCopyWith<TravelRequestModel> get copyWith => _$TravelRequestModelCopyWithImpl<TravelRequestModel>(this as TravelRequestModel, _$identity);

  /// Serializes this TravelRequestModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TravelRequestModel&&(identical(other.id, id) || other.id == id)&&(identical(other.purpose, purpose) || other.purpose == purpose)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.departureDate, departureDate) || other.departureDate == departureDate)&&(identical(other.returnDate, returnDate) || other.returnDate == returnDate)&&(identical(other.transportMode, transportMode) || other.transportMode == transportMode)&&(identical(other.estimatedBudget, estimatedBudget) || other.estimatedBudget == estimatedBudget)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.employeeName, employeeName) || other.employeeName == employeeName)&&(identical(other.employeePhoto, employeePhoto) || other.employeePhoto == employeePhoto)&&(identical(other.budgetLimit, budgetLimit) || other.budgetLimit == budgetLimit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,purpose,origin,destination,departureDate,returnDate,transportMode,estimatedBudget,status,createdAt,employeeName,employeePhoto,budgetLimit);

@override
String toString() {
  return 'TravelRequestModel(id: $id, purpose: $purpose, origin: $origin, destination: $destination, departureDate: $departureDate, returnDate: $returnDate, transportMode: $transportMode, estimatedBudget: $estimatedBudget, status: $status, createdAt: $createdAt, employeeName: $employeeName, employeePhoto: $employeePhoto, budgetLimit: $budgetLimit)';
}


}

/// @nodoc
abstract mixin class $TravelRequestModelCopyWith<$Res>  {
  factory $TravelRequestModelCopyWith(TravelRequestModel value, $Res Function(TravelRequestModel) _then) = _$TravelRequestModelCopyWithImpl;
@useResult
$Res call({
 int id, String purpose, String origin, String destination, String departureDate, String returnDate, String transportMode, double estimatedBudget, String status, String? createdAt, String? employeeName, String? employeePhoto, double? budgetLimit
});




}
/// @nodoc
class _$TravelRequestModelCopyWithImpl<$Res>
    implements $TravelRequestModelCopyWith<$Res> {
  _$TravelRequestModelCopyWithImpl(this._self, this._then);

  final TravelRequestModel _self;
  final $Res Function(TravelRequestModel) _then;

/// Create a copy of TravelRequestModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? purpose = null,Object? origin = null,Object? destination = null,Object? departureDate = null,Object? returnDate = null,Object? transportMode = null,Object? estimatedBudget = null,Object? status = null,Object? createdAt = freezed,Object? employeeName = freezed,Object? employeePhoto = freezed,Object? budgetLimit = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String,departureDate: null == departureDate ? _self.departureDate : departureDate // ignore: cast_nullable_to_non_nullable
as String,returnDate: null == returnDate ? _self.returnDate : returnDate // ignore: cast_nullable_to_non_nullable
as String,transportMode: null == transportMode ? _self.transportMode : transportMode // ignore: cast_nullable_to_non_nullable
as String,estimatedBudget: null == estimatedBudget ? _self.estimatedBudget : estimatedBudget // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,employeeName: freezed == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String?,employeePhoto: freezed == employeePhoto ? _self.employeePhoto : employeePhoto // ignore: cast_nullable_to_non_nullable
as String?,budgetLimit: freezed == budgetLimit ? _self.budgetLimit : budgetLimit // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [TravelRequestModel].
extension TravelRequestModelPatterns on TravelRequestModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TravelRequestModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TravelRequestModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TravelRequestModel value)  $default,){
final _that = this;
switch (_that) {
case _TravelRequestModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TravelRequestModel value)?  $default,){
final _that = this;
switch (_that) {
case _TravelRequestModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String purpose,  String origin,  String destination,  String departureDate,  String returnDate,  String transportMode,  double estimatedBudget,  String status,  String? createdAt,  String? employeeName,  String? employeePhoto,  double? budgetLimit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TravelRequestModel() when $default != null:
return $default(_that.id,_that.purpose,_that.origin,_that.destination,_that.departureDate,_that.returnDate,_that.transportMode,_that.estimatedBudget,_that.status,_that.createdAt,_that.employeeName,_that.employeePhoto,_that.budgetLimit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String purpose,  String origin,  String destination,  String departureDate,  String returnDate,  String transportMode,  double estimatedBudget,  String status,  String? createdAt,  String? employeeName,  String? employeePhoto,  double? budgetLimit)  $default,) {final _that = this;
switch (_that) {
case _TravelRequestModel():
return $default(_that.id,_that.purpose,_that.origin,_that.destination,_that.departureDate,_that.returnDate,_that.transportMode,_that.estimatedBudget,_that.status,_that.createdAt,_that.employeeName,_that.employeePhoto,_that.budgetLimit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String purpose,  String origin,  String destination,  String departureDate,  String returnDate,  String transportMode,  double estimatedBudget,  String status,  String? createdAt,  String? employeeName,  String? employeePhoto,  double? budgetLimit)?  $default,) {final _that = this;
switch (_that) {
case _TravelRequestModel() when $default != null:
return $default(_that.id,_that.purpose,_that.origin,_that.destination,_that.departureDate,_that.returnDate,_that.transportMode,_that.estimatedBudget,_that.status,_that.createdAt,_that.employeeName,_that.employeePhoto,_that.budgetLimit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TravelRequestModel implements TravelRequestModel {
  const _TravelRequestModel({required this.id, required this.purpose, required this.origin, required this.destination, required this.departureDate, required this.returnDate, required this.transportMode, required this.estimatedBudget, required this.status, this.createdAt, this.employeeName, this.employeePhoto, this.budgetLimit});
  factory _TravelRequestModel.fromJson(Map<String, dynamic> json) => _$TravelRequestModelFromJson(json);

@override final  int id;
@override final  String purpose;
@override final  String origin;
@override final  String destination;
@override final  String departureDate;
@override final  String returnDate;
@override final  String transportMode;
@override final  double estimatedBudget;
@override final  String status;
@override final  String? createdAt;
@override final  String? employeeName;
@override final  String? employeePhoto;
@override final  double? budgetLimit;

/// Create a copy of TravelRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TravelRequestModelCopyWith<_TravelRequestModel> get copyWith => __$TravelRequestModelCopyWithImpl<_TravelRequestModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TravelRequestModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TravelRequestModel&&(identical(other.id, id) || other.id == id)&&(identical(other.purpose, purpose) || other.purpose == purpose)&&(identical(other.origin, origin) || other.origin == origin)&&(identical(other.destination, destination) || other.destination == destination)&&(identical(other.departureDate, departureDate) || other.departureDate == departureDate)&&(identical(other.returnDate, returnDate) || other.returnDate == returnDate)&&(identical(other.transportMode, transportMode) || other.transportMode == transportMode)&&(identical(other.estimatedBudget, estimatedBudget) || other.estimatedBudget == estimatedBudget)&&(identical(other.status, status) || other.status == status)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.employeeName, employeeName) || other.employeeName == employeeName)&&(identical(other.employeePhoto, employeePhoto) || other.employeePhoto == employeePhoto)&&(identical(other.budgetLimit, budgetLimit) || other.budgetLimit == budgetLimit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,purpose,origin,destination,departureDate,returnDate,transportMode,estimatedBudget,status,createdAt,employeeName,employeePhoto,budgetLimit);

@override
String toString() {
  return 'TravelRequestModel(id: $id, purpose: $purpose, origin: $origin, destination: $destination, departureDate: $departureDate, returnDate: $returnDate, transportMode: $transportMode, estimatedBudget: $estimatedBudget, status: $status, createdAt: $createdAt, employeeName: $employeeName, employeePhoto: $employeePhoto, budgetLimit: $budgetLimit)';
}


}

/// @nodoc
abstract mixin class _$TravelRequestModelCopyWith<$Res> implements $TravelRequestModelCopyWith<$Res> {
  factory _$TravelRequestModelCopyWith(_TravelRequestModel value, $Res Function(_TravelRequestModel) _then) = __$TravelRequestModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String purpose, String origin, String destination, String departureDate, String returnDate, String transportMode, double estimatedBudget, String status, String? createdAt, String? employeeName, String? employeePhoto, double? budgetLimit
});




}
/// @nodoc
class __$TravelRequestModelCopyWithImpl<$Res>
    implements _$TravelRequestModelCopyWith<$Res> {
  __$TravelRequestModelCopyWithImpl(this._self, this._then);

  final _TravelRequestModel _self;
  final $Res Function(_TravelRequestModel) _then;

/// Create a copy of TravelRequestModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? purpose = null,Object? origin = null,Object? destination = null,Object? departureDate = null,Object? returnDate = null,Object? transportMode = null,Object? estimatedBudget = null,Object? status = null,Object? createdAt = freezed,Object? employeeName = freezed,Object? employeePhoto = freezed,Object? budgetLimit = freezed,}) {
  return _then(_TravelRequestModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String,origin: null == origin ? _self.origin : origin // ignore: cast_nullable_to_non_nullable
as String,destination: null == destination ? _self.destination : destination // ignore: cast_nullable_to_non_nullable
as String,departureDate: null == departureDate ? _self.departureDate : departureDate // ignore: cast_nullable_to_non_nullable
as String,returnDate: null == returnDate ? _self.returnDate : returnDate // ignore: cast_nullable_to_non_nullable
as String,transportMode: null == transportMode ? _self.transportMode : transportMode // ignore: cast_nullable_to_non_nullable
as String,estimatedBudget: null == estimatedBudget ? _self.estimatedBudget : estimatedBudget // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,employeeName: freezed == employeeName ? _self.employeeName : employeeName // ignore: cast_nullable_to_non_nullable
as String?,employeePhoto: freezed == employeePhoto ? _self.employeePhoto : employeePhoto // ignore: cast_nullable_to_non_nullable
as String?,budgetLimit: freezed == budgetLimit ? _self.budgetLimit : budgetLimit // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
