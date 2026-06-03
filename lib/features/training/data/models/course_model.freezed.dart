// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'course_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CourseModel {

 int get id; String get title; String get category; String get type; int get durationMinutes; bool get isMandatory; String? get thumbnailUrl; String? get description; String? get deadlineDate; double? get rating; double? get myProgress; bool? get isEnrolled; bool? get isCompleted; int? get assessmentPassScore; int? get assessmentAttemptsAllowed; bool? get hasAssessment; String? get contentUrl;
/// Create a copy of CourseModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CourseModelCopyWith<CourseModel> get copyWith => _$CourseModelCopyWithImpl<CourseModel>(this as CourseModel, _$identity);

  /// Serializes this CourseModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CourseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.type, type) || other.type == type)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.isMandatory, isMandatory) || other.isMandatory == isMandatory)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.deadlineDate, deadlineDate) || other.deadlineDate == deadlineDate)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.myProgress, myProgress) || other.myProgress == myProgress)&&(identical(other.isEnrolled, isEnrolled) || other.isEnrolled == isEnrolled)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.assessmentPassScore, assessmentPassScore) || other.assessmentPassScore == assessmentPassScore)&&(identical(other.assessmentAttemptsAllowed, assessmentAttemptsAllowed) || other.assessmentAttemptsAllowed == assessmentAttemptsAllowed)&&(identical(other.hasAssessment, hasAssessment) || other.hasAssessment == hasAssessment)&&(identical(other.contentUrl, contentUrl) || other.contentUrl == contentUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,category,type,durationMinutes,isMandatory,thumbnailUrl,description,deadlineDate,rating,myProgress,isEnrolled,isCompleted,assessmentPassScore,assessmentAttemptsAllowed,hasAssessment,contentUrl);

@override
String toString() {
  return 'CourseModel(id: $id, title: $title, category: $category, type: $type, durationMinutes: $durationMinutes, isMandatory: $isMandatory, thumbnailUrl: $thumbnailUrl, description: $description, deadlineDate: $deadlineDate, rating: $rating, myProgress: $myProgress, isEnrolled: $isEnrolled, isCompleted: $isCompleted, assessmentPassScore: $assessmentPassScore, assessmentAttemptsAllowed: $assessmentAttemptsAllowed, hasAssessment: $hasAssessment, contentUrl: $contentUrl)';
}


}

/// @nodoc
abstract mixin class $CourseModelCopyWith<$Res>  {
  factory $CourseModelCopyWith(CourseModel value, $Res Function(CourseModel) _then) = _$CourseModelCopyWithImpl;
@useResult
$Res call({
 int id, String title, String category, String type, int durationMinutes, bool isMandatory, String? thumbnailUrl, String? description, String? deadlineDate, double? rating, double? myProgress, bool? isEnrolled, bool? isCompleted, int? assessmentPassScore, int? assessmentAttemptsAllowed, bool? hasAssessment, String? contentUrl
});




}
/// @nodoc
class _$CourseModelCopyWithImpl<$Res>
    implements $CourseModelCopyWith<$Res> {
  _$CourseModelCopyWithImpl(this._self, this._then);

  final CourseModel _self;
  final $Res Function(CourseModel) _then;

/// Create a copy of CourseModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? category = null,Object? type = null,Object? durationMinutes = null,Object? isMandatory = null,Object? thumbnailUrl = freezed,Object? description = freezed,Object? deadlineDate = freezed,Object? rating = freezed,Object? myProgress = freezed,Object? isEnrolled = freezed,Object? isCompleted = freezed,Object? assessmentPassScore = freezed,Object? assessmentAttemptsAllowed = freezed,Object? hasAssessment = freezed,Object? contentUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,isMandatory: null == isMandatory ? _self.isMandatory : isMandatory // ignore: cast_nullable_to_non_nullable
as bool,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,deadlineDate: freezed == deadlineDate ? _self.deadlineDate : deadlineDate // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,myProgress: freezed == myProgress ? _self.myProgress : myProgress // ignore: cast_nullable_to_non_nullable
as double?,isEnrolled: freezed == isEnrolled ? _self.isEnrolled : isEnrolled // ignore: cast_nullable_to_non_nullable
as bool?,isCompleted: freezed == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool?,assessmentPassScore: freezed == assessmentPassScore ? _self.assessmentPassScore : assessmentPassScore // ignore: cast_nullable_to_non_nullable
as int?,assessmentAttemptsAllowed: freezed == assessmentAttemptsAllowed ? _self.assessmentAttemptsAllowed : assessmentAttemptsAllowed // ignore: cast_nullable_to_non_nullable
as int?,hasAssessment: freezed == hasAssessment ? _self.hasAssessment : hasAssessment // ignore: cast_nullable_to_non_nullable
as bool?,contentUrl: freezed == contentUrl ? _self.contentUrl : contentUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CourseModel].
extension CourseModelPatterns on CourseModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CourseModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CourseModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CourseModel value)  $default,){
final _that = this;
switch (_that) {
case _CourseModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CourseModel value)?  $default,){
final _that = this;
switch (_that) {
case _CourseModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String category,  String type,  int durationMinutes,  bool isMandatory,  String? thumbnailUrl,  String? description,  String? deadlineDate,  double? rating,  double? myProgress,  bool? isEnrolled,  bool? isCompleted,  int? assessmentPassScore,  int? assessmentAttemptsAllowed,  bool? hasAssessment,  String? contentUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CourseModel() when $default != null:
return $default(_that.id,_that.title,_that.category,_that.type,_that.durationMinutes,_that.isMandatory,_that.thumbnailUrl,_that.description,_that.deadlineDate,_that.rating,_that.myProgress,_that.isEnrolled,_that.isCompleted,_that.assessmentPassScore,_that.assessmentAttemptsAllowed,_that.hasAssessment,_that.contentUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String category,  String type,  int durationMinutes,  bool isMandatory,  String? thumbnailUrl,  String? description,  String? deadlineDate,  double? rating,  double? myProgress,  bool? isEnrolled,  bool? isCompleted,  int? assessmentPassScore,  int? assessmentAttemptsAllowed,  bool? hasAssessment,  String? contentUrl)  $default,) {final _that = this;
switch (_that) {
case _CourseModel():
return $default(_that.id,_that.title,_that.category,_that.type,_that.durationMinutes,_that.isMandatory,_that.thumbnailUrl,_that.description,_that.deadlineDate,_that.rating,_that.myProgress,_that.isEnrolled,_that.isCompleted,_that.assessmentPassScore,_that.assessmentAttemptsAllowed,_that.hasAssessment,_that.contentUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String category,  String type,  int durationMinutes,  bool isMandatory,  String? thumbnailUrl,  String? description,  String? deadlineDate,  double? rating,  double? myProgress,  bool? isEnrolled,  bool? isCompleted,  int? assessmentPassScore,  int? assessmentAttemptsAllowed,  bool? hasAssessment,  String? contentUrl)?  $default,) {final _that = this;
switch (_that) {
case _CourseModel() when $default != null:
return $default(_that.id,_that.title,_that.category,_that.type,_that.durationMinutes,_that.isMandatory,_that.thumbnailUrl,_that.description,_that.deadlineDate,_that.rating,_that.myProgress,_that.isEnrolled,_that.isCompleted,_that.assessmentPassScore,_that.assessmentAttemptsAllowed,_that.hasAssessment,_that.contentUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CourseModel implements CourseModel {
  const _CourseModel({required this.id, required this.title, required this.category, required this.type, required this.durationMinutes, required this.isMandatory, this.thumbnailUrl, this.description, this.deadlineDate, this.rating, this.myProgress, this.isEnrolled, this.isCompleted, this.assessmentPassScore, this.assessmentAttemptsAllowed, this.hasAssessment, this.contentUrl});
  factory _CourseModel.fromJson(Map<String, dynamic> json) => _$CourseModelFromJson(json);

@override final  int id;
@override final  String title;
@override final  String category;
@override final  String type;
@override final  int durationMinutes;
@override final  bool isMandatory;
@override final  String? thumbnailUrl;
@override final  String? description;
@override final  String? deadlineDate;
@override final  double? rating;
@override final  double? myProgress;
@override final  bool? isEnrolled;
@override final  bool? isCompleted;
@override final  int? assessmentPassScore;
@override final  int? assessmentAttemptsAllowed;
@override final  bool? hasAssessment;
@override final  String? contentUrl;

/// Create a copy of CourseModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CourseModelCopyWith<_CourseModel> get copyWith => __$CourseModelCopyWithImpl<_CourseModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CourseModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CourseModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.category, category) || other.category == category)&&(identical(other.type, type) || other.type == type)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.isMandatory, isMandatory) || other.isMandatory == isMandatory)&&(identical(other.thumbnailUrl, thumbnailUrl) || other.thumbnailUrl == thumbnailUrl)&&(identical(other.description, description) || other.description == description)&&(identical(other.deadlineDate, deadlineDate) || other.deadlineDate == deadlineDate)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.myProgress, myProgress) || other.myProgress == myProgress)&&(identical(other.isEnrolled, isEnrolled) || other.isEnrolled == isEnrolled)&&(identical(other.isCompleted, isCompleted) || other.isCompleted == isCompleted)&&(identical(other.assessmentPassScore, assessmentPassScore) || other.assessmentPassScore == assessmentPassScore)&&(identical(other.assessmentAttemptsAllowed, assessmentAttemptsAllowed) || other.assessmentAttemptsAllowed == assessmentAttemptsAllowed)&&(identical(other.hasAssessment, hasAssessment) || other.hasAssessment == hasAssessment)&&(identical(other.contentUrl, contentUrl) || other.contentUrl == contentUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,category,type,durationMinutes,isMandatory,thumbnailUrl,description,deadlineDate,rating,myProgress,isEnrolled,isCompleted,assessmentPassScore,assessmentAttemptsAllowed,hasAssessment,contentUrl);

@override
String toString() {
  return 'CourseModel(id: $id, title: $title, category: $category, type: $type, durationMinutes: $durationMinutes, isMandatory: $isMandatory, thumbnailUrl: $thumbnailUrl, description: $description, deadlineDate: $deadlineDate, rating: $rating, myProgress: $myProgress, isEnrolled: $isEnrolled, isCompleted: $isCompleted, assessmentPassScore: $assessmentPassScore, assessmentAttemptsAllowed: $assessmentAttemptsAllowed, hasAssessment: $hasAssessment, contentUrl: $contentUrl)';
}


}

/// @nodoc
abstract mixin class _$CourseModelCopyWith<$Res> implements $CourseModelCopyWith<$Res> {
  factory _$CourseModelCopyWith(_CourseModel value, $Res Function(_CourseModel) _then) = __$CourseModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String category, String type, int durationMinutes, bool isMandatory, String? thumbnailUrl, String? description, String? deadlineDate, double? rating, double? myProgress, bool? isEnrolled, bool? isCompleted, int? assessmentPassScore, int? assessmentAttemptsAllowed, bool? hasAssessment, String? contentUrl
});




}
/// @nodoc
class __$CourseModelCopyWithImpl<$Res>
    implements _$CourseModelCopyWith<$Res> {
  __$CourseModelCopyWithImpl(this._self, this._then);

  final _CourseModel _self;
  final $Res Function(_CourseModel) _then;

/// Create a copy of CourseModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? category = null,Object? type = null,Object? durationMinutes = null,Object? isMandatory = null,Object? thumbnailUrl = freezed,Object? description = freezed,Object? deadlineDate = freezed,Object? rating = freezed,Object? myProgress = freezed,Object? isEnrolled = freezed,Object? isCompleted = freezed,Object? assessmentPassScore = freezed,Object? assessmentAttemptsAllowed = freezed,Object? hasAssessment = freezed,Object? contentUrl = freezed,}) {
  return _then(_CourseModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,isMandatory: null == isMandatory ? _self.isMandatory : isMandatory // ignore: cast_nullable_to_non_nullable
as bool,thumbnailUrl: freezed == thumbnailUrl ? _self.thumbnailUrl : thumbnailUrl // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,deadlineDate: freezed == deadlineDate ? _self.deadlineDate : deadlineDate // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,myProgress: freezed == myProgress ? _self.myProgress : myProgress // ignore: cast_nullable_to_non_nullable
as double?,isEnrolled: freezed == isEnrolled ? _self.isEnrolled : isEnrolled // ignore: cast_nullable_to_non_nullable
as bool?,isCompleted: freezed == isCompleted ? _self.isCompleted : isCompleted // ignore: cast_nullable_to_non_nullable
as bool?,assessmentPassScore: freezed == assessmentPassScore ? _self.assessmentPassScore : assessmentPassScore // ignore: cast_nullable_to_non_nullable
as int?,assessmentAttemptsAllowed: freezed == assessmentAttemptsAllowed ? _self.assessmentAttemptsAllowed : assessmentAttemptsAllowed // ignore: cast_nullable_to_non_nullable
as int?,hasAssessment: freezed == hasAssessment ? _self.hasAssessment : hasAssessment // ignore: cast_nullable_to_non_nullable
as bool?,contentUrl: freezed == contentUrl ? _self.contentUrl : contentUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$CertificateModel {

 int get id; int get courseId; String get courseName; String get issuedDate; String? get expiryDate; String? get downloadUrl;
/// Create a copy of CertificateModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CertificateModelCopyWith<CertificateModel> get copyWith => _$CertificateModelCopyWithImpl<CertificateModel>(this as CertificateModel, _$identity);

  /// Serializes this CertificateModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CertificateModel&&(identical(other.id, id) || other.id == id)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.issuedDate, issuedDate) || other.issuedDate == issuedDate)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseId,courseName,issuedDate,expiryDate,downloadUrl);

@override
String toString() {
  return 'CertificateModel(id: $id, courseId: $courseId, courseName: $courseName, issuedDate: $issuedDate, expiryDate: $expiryDate, downloadUrl: $downloadUrl)';
}


}

/// @nodoc
abstract mixin class $CertificateModelCopyWith<$Res>  {
  factory $CertificateModelCopyWith(CertificateModel value, $Res Function(CertificateModel) _then) = _$CertificateModelCopyWithImpl;
@useResult
$Res call({
 int id, int courseId, String courseName, String issuedDate, String? expiryDate, String? downloadUrl
});




}
/// @nodoc
class _$CertificateModelCopyWithImpl<$Res>
    implements $CertificateModelCopyWith<$Res> {
  _$CertificateModelCopyWithImpl(this._self, this._then);

  final CertificateModel _self;
  final $Res Function(CertificateModel) _then;

/// Create a copy of CertificateModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? courseId = null,Object? courseName = null,Object? issuedDate = null,Object? expiryDate = freezed,Object? downloadUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,courseName: null == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String,issuedDate: null == issuedDate ? _self.issuedDate : issuedDate // ignore: cast_nullable_to_non_nullable
as String,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as String?,downloadUrl: freezed == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CertificateModel].
extension CertificateModelPatterns on CertificateModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CertificateModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CertificateModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CertificateModel value)  $default,){
final _that = this;
switch (_that) {
case _CertificateModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CertificateModel value)?  $default,){
final _that = this;
switch (_that) {
case _CertificateModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int courseId,  String courseName,  String issuedDate,  String? expiryDate,  String? downloadUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CertificateModel() when $default != null:
return $default(_that.id,_that.courseId,_that.courseName,_that.issuedDate,_that.expiryDate,_that.downloadUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int courseId,  String courseName,  String issuedDate,  String? expiryDate,  String? downloadUrl)  $default,) {final _that = this;
switch (_that) {
case _CertificateModel():
return $default(_that.id,_that.courseId,_that.courseName,_that.issuedDate,_that.expiryDate,_that.downloadUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int courseId,  String courseName,  String issuedDate,  String? expiryDate,  String? downloadUrl)?  $default,) {final _that = this;
switch (_that) {
case _CertificateModel() when $default != null:
return $default(_that.id,_that.courseId,_that.courseName,_that.issuedDate,_that.expiryDate,_that.downloadUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CertificateModel implements CertificateModel {
  const _CertificateModel({required this.id, required this.courseId, required this.courseName, required this.issuedDate, this.expiryDate, this.downloadUrl});
  factory _CertificateModel.fromJson(Map<String, dynamic> json) => _$CertificateModelFromJson(json);

@override final  int id;
@override final  int courseId;
@override final  String courseName;
@override final  String issuedDate;
@override final  String? expiryDate;
@override final  String? downloadUrl;

/// Create a copy of CertificateModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CertificateModelCopyWith<_CertificateModel> get copyWith => __$CertificateModelCopyWithImpl<_CertificateModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CertificateModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CertificateModel&&(identical(other.id, id) || other.id == id)&&(identical(other.courseId, courseId) || other.courseId == courseId)&&(identical(other.courseName, courseName) || other.courseName == courseName)&&(identical(other.issuedDate, issuedDate) || other.issuedDate == issuedDate)&&(identical(other.expiryDate, expiryDate) || other.expiryDate == expiryDate)&&(identical(other.downloadUrl, downloadUrl) || other.downloadUrl == downloadUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,courseId,courseName,issuedDate,expiryDate,downloadUrl);

@override
String toString() {
  return 'CertificateModel(id: $id, courseId: $courseId, courseName: $courseName, issuedDate: $issuedDate, expiryDate: $expiryDate, downloadUrl: $downloadUrl)';
}


}

/// @nodoc
abstract mixin class _$CertificateModelCopyWith<$Res> implements $CertificateModelCopyWith<$Res> {
  factory _$CertificateModelCopyWith(_CertificateModel value, $Res Function(_CertificateModel) _then) = __$CertificateModelCopyWithImpl;
@override @useResult
$Res call({
 int id, int courseId, String courseName, String issuedDate, String? expiryDate, String? downloadUrl
});




}
/// @nodoc
class __$CertificateModelCopyWithImpl<$Res>
    implements _$CertificateModelCopyWith<$Res> {
  __$CertificateModelCopyWithImpl(this._self, this._then);

  final _CertificateModel _self;
  final $Res Function(_CertificateModel) _then;

/// Create a copy of CertificateModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? courseId = null,Object? courseName = null,Object? issuedDate = null,Object? expiryDate = freezed,Object? downloadUrl = freezed,}) {
  return _then(_CertificateModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,courseId: null == courseId ? _self.courseId : courseId // ignore: cast_nullable_to_non_nullable
as int,courseName: null == courseName ? _self.courseName : courseName // ignore: cast_nullable_to_non_nullable
as String,issuedDate: null == issuedDate ? _self.issuedDate : issuedDate // ignore: cast_nullable_to_non_nullable
as String,expiryDate: freezed == expiryDate ? _self.expiryDate : expiryDate // ignore: cast_nullable_to_non_nullable
as String?,downloadUrl: freezed == downloadUrl ? _self.downloadUrl : downloadUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$AssessmentQuestionModel {

 int get id; String get question; List<String> get options;
/// Create a copy of AssessmentQuestionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AssessmentQuestionModelCopyWith<AssessmentQuestionModel> get copyWith => _$AssessmentQuestionModelCopyWithImpl<AssessmentQuestionModel>(this as AssessmentQuestionModel, _$identity);

  /// Serializes this AssessmentQuestionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AssessmentQuestionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.question, question) || other.question == question)&&const DeepCollectionEquality().equals(other.options, options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,question,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'AssessmentQuestionModel(id: $id, question: $question, options: $options)';
}


}

/// @nodoc
abstract mixin class $AssessmentQuestionModelCopyWith<$Res>  {
  factory $AssessmentQuestionModelCopyWith(AssessmentQuestionModel value, $Res Function(AssessmentQuestionModel) _then) = _$AssessmentQuestionModelCopyWithImpl;
@useResult
$Res call({
 int id, String question, List<String> options
});




}
/// @nodoc
class _$AssessmentQuestionModelCopyWithImpl<$Res>
    implements $AssessmentQuestionModelCopyWith<$Res> {
  _$AssessmentQuestionModelCopyWithImpl(this._self, this._then);

  final AssessmentQuestionModel _self;
  final $Res Function(AssessmentQuestionModel) _then;

/// Create a copy of AssessmentQuestionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? question = null,Object? options = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [AssessmentQuestionModel].
extension AssessmentQuestionModelPatterns on AssessmentQuestionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AssessmentQuestionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AssessmentQuestionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AssessmentQuestionModel value)  $default,){
final _that = this;
switch (_that) {
case _AssessmentQuestionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AssessmentQuestionModel value)?  $default,){
final _that = this;
switch (_that) {
case _AssessmentQuestionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String question,  List<String> options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AssessmentQuestionModel() when $default != null:
return $default(_that.id,_that.question,_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String question,  List<String> options)  $default,) {final _that = this;
switch (_that) {
case _AssessmentQuestionModel():
return $default(_that.id,_that.question,_that.options);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String question,  List<String> options)?  $default,) {final _that = this;
switch (_that) {
case _AssessmentQuestionModel() when $default != null:
return $default(_that.id,_that.question,_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AssessmentQuestionModel implements AssessmentQuestionModel {
  const _AssessmentQuestionModel({required this.id, required this.question, required final  List<String> options}): _options = options;
  factory _AssessmentQuestionModel.fromJson(Map<String, dynamic> json) => _$AssessmentQuestionModelFromJson(json);

@override final  int id;
@override final  String question;
 final  List<String> _options;
@override List<String> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}


/// Create a copy of AssessmentQuestionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AssessmentQuestionModelCopyWith<_AssessmentQuestionModel> get copyWith => __$AssessmentQuestionModelCopyWithImpl<_AssessmentQuestionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AssessmentQuestionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AssessmentQuestionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.question, question) || other.question == question)&&const DeepCollectionEquality().equals(other._options, _options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,question,const DeepCollectionEquality().hash(_options));

@override
String toString() {
  return 'AssessmentQuestionModel(id: $id, question: $question, options: $options)';
}


}

/// @nodoc
abstract mixin class _$AssessmentQuestionModelCopyWith<$Res> implements $AssessmentQuestionModelCopyWith<$Res> {
  factory _$AssessmentQuestionModelCopyWith(_AssessmentQuestionModel value, $Res Function(_AssessmentQuestionModel) _then) = __$AssessmentQuestionModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String question, List<String> options
});




}
/// @nodoc
class __$AssessmentQuestionModelCopyWithImpl<$Res>
    implements _$AssessmentQuestionModelCopyWith<$Res> {
  __$AssessmentQuestionModelCopyWithImpl(this._self, this._then);

  final _AssessmentQuestionModel _self;
  final $Res Function(_AssessmentQuestionModel) _then;

/// Create a copy of AssessmentQuestionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? question = null,Object? options = null,}) {
  return _then(_AssessmentQuestionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
