// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_claim_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ExpenseItemModel {

 int get id; String get category; String get description; double get amount; String get date; String? get receiptUrl; bool? get requiresReceipt; bool? get isPerDiem;
/// Create a copy of ExpenseItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseItemModelCopyWith<ExpenseItemModel> get copyWith => _$ExpenseItemModelCopyWithImpl<ExpenseItemModel>(this as ExpenseItemModel, _$identity);

  /// Serializes this ExpenseItemModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.date, date) || other.date == date)&&(identical(other.receiptUrl, receiptUrl) || other.receiptUrl == receiptUrl)&&(identical(other.requiresReceipt, requiresReceipt) || other.requiresReceipt == requiresReceipt)&&(identical(other.isPerDiem, isPerDiem) || other.isPerDiem == isPerDiem));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,category,description,amount,date,receiptUrl,requiresReceipt,isPerDiem);

@override
String toString() {
  return 'ExpenseItemModel(id: $id, category: $category, description: $description, amount: $amount, date: $date, receiptUrl: $receiptUrl, requiresReceipt: $requiresReceipt, isPerDiem: $isPerDiem)';
}


}

/// @nodoc
abstract mixin class $ExpenseItemModelCopyWith<$Res>  {
  factory $ExpenseItemModelCopyWith(ExpenseItemModel value, $Res Function(ExpenseItemModel) _then) = _$ExpenseItemModelCopyWithImpl;
@useResult
$Res call({
 int id, String category, String description, double amount, String date, String? receiptUrl, bool? requiresReceipt, bool? isPerDiem
});




}
/// @nodoc
class _$ExpenseItemModelCopyWithImpl<$Res>
    implements $ExpenseItemModelCopyWith<$Res> {
  _$ExpenseItemModelCopyWithImpl(this._self, this._then);

  final ExpenseItemModel _self;
  final $Res Function(ExpenseItemModel) _then;

/// Create a copy of ExpenseItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? category = null,Object? description = null,Object? amount = null,Object? date = null,Object? receiptUrl = freezed,Object? requiresReceipt = freezed,Object? isPerDiem = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,receiptUrl: freezed == receiptUrl ? _self.receiptUrl : receiptUrl // ignore: cast_nullable_to_non_nullable
as String?,requiresReceipt: freezed == requiresReceipt ? _self.requiresReceipt : requiresReceipt // ignore: cast_nullable_to_non_nullable
as bool?,isPerDiem: freezed == isPerDiem ? _self.isPerDiem : isPerDiem // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpenseItemModel].
extension ExpenseItemModelPatterns on ExpenseItemModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpenseItemModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpenseItemModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpenseItemModel value)  $default,){
final _that = this;
switch (_that) {
case _ExpenseItemModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpenseItemModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExpenseItemModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String category,  String description,  double amount,  String date,  String? receiptUrl,  bool? requiresReceipt,  bool? isPerDiem)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseItemModel() when $default != null:
return $default(_that.id,_that.category,_that.description,_that.amount,_that.date,_that.receiptUrl,_that.requiresReceipt,_that.isPerDiem);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String category,  String description,  double amount,  String date,  String? receiptUrl,  bool? requiresReceipt,  bool? isPerDiem)  $default,) {final _that = this;
switch (_that) {
case _ExpenseItemModel():
return $default(_that.id,_that.category,_that.description,_that.amount,_that.date,_that.receiptUrl,_that.requiresReceipt,_that.isPerDiem);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String category,  String description,  double amount,  String date,  String? receiptUrl,  bool? requiresReceipt,  bool? isPerDiem)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseItemModel() when $default != null:
return $default(_that.id,_that.category,_that.description,_that.amount,_that.date,_that.receiptUrl,_that.requiresReceipt,_that.isPerDiem);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExpenseItemModel implements ExpenseItemModel {
  const _ExpenseItemModel({required this.id, required this.category, required this.description, required this.amount, required this.date, this.receiptUrl, this.requiresReceipt, this.isPerDiem});
  factory _ExpenseItemModel.fromJson(Map<String, dynamic> json) => _$ExpenseItemModelFromJson(json);

@override final  int id;
@override final  String category;
@override final  String description;
@override final  double amount;
@override final  String date;
@override final  String? receiptUrl;
@override final  bool? requiresReceipt;
@override final  bool? isPerDiem;

/// Create a copy of ExpenseItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseItemModelCopyWith<_ExpenseItemModel> get copyWith => __$ExpenseItemModelCopyWithImpl<_ExpenseItemModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpenseItemModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.date, date) || other.date == date)&&(identical(other.receiptUrl, receiptUrl) || other.receiptUrl == receiptUrl)&&(identical(other.requiresReceipt, requiresReceipt) || other.requiresReceipt == requiresReceipt)&&(identical(other.isPerDiem, isPerDiem) || other.isPerDiem == isPerDiem));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,category,description,amount,date,receiptUrl,requiresReceipt,isPerDiem);

@override
String toString() {
  return 'ExpenseItemModel(id: $id, category: $category, description: $description, amount: $amount, date: $date, receiptUrl: $receiptUrl, requiresReceipt: $requiresReceipt, isPerDiem: $isPerDiem)';
}


}

/// @nodoc
abstract mixin class _$ExpenseItemModelCopyWith<$Res> implements $ExpenseItemModelCopyWith<$Res> {
  factory _$ExpenseItemModelCopyWith(_ExpenseItemModel value, $Res Function(_ExpenseItemModel) _then) = __$ExpenseItemModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String category, String description, double amount, String date, String? receiptUrl, bool? requiresReceipt, bool? isPerDiem
});




}
/// @nodoc
class __$ExpenseItemModelCopyWithImpl<$Res>
    implements _$ExpenseItemModelCopyWith<$Res> {
  __$ExpenseItemModelCopyWithImpl(this._self, this._then);

  final _ExpenseItemModel _self;
  final $Res Function(_ExpenseItemModel) _then;

/// Create a copy of ExpenseItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? category = null,Object? description = null,Object? amount = null,Object? date = null,Object? receiptUrl = freezed,Object? requiresReceipt = freezed,Object? isPerDiem = freezed,}) {
  return _then(_ExpenseItemModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as String,receiptUrl: freezed == receiptUrl ? _self.receiptUrl : receiptUrl // ignore: cast_nullable_to_non_nullable
as String?,requiresReceipt: freezed == requiresReceipt ? _self.requiresReceipt : requiresReceipt // ignore: cast_nullable_to_non_nullable
as bool?,isPerDiem: freezed == isPerDiem ? _self.isPerDiem : isPerDiem // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$ExpenseClaimModel {

 int get id; String get title; double get total; String get status; List<ExpenseItemModel> get items; int? get travelRequestId; String? get travelRequestDestination; String? get createdAt; String? get submittedAt; double? get budgetAmount;
/// Create a copy of ExpenseClaimModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseClaimModelCopyWith<ExpenseClaimModel> get copyWith => _$ExpenseClaimModelCopyWithImpl<ExpenseClaimModel>(this as ExpenseClaimModel, _$identity);

  /// Serializes this ExpenseClaimModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseClaimModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.total, total) || other.total == total)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.travelRequestId, travelRequestId) || other.travelRequestId == travelRequestId)&&(identical(other.travelRequestDestination, travelRequestDestination) || other.travelRequestDestination == travelRequestDestination)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.budgetAmount, budgetAmount) || other.budgetAmount == budgetAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,total,status,const DeepCollectionEquality().hash(items),travelRequestId,travelRequestDestination,createdAt,submittedAt,budgetAmount);

@override
String toString() {
  return 'ExpenseClaimModel(id: $id, title: $title, total: $total, status: $status, items: $items, travelRequestId: $travelRequestId, travelRequestDestination: $travelRequestDestination, createdAt: $createdAt, submittedAt: $submittedAt, budgetAmount: $budgetAmount)';
}


}

/// @nodoc
abstract mixin class $ExpenseClaimModelCopyWith<$Res>  {
  factory $ExpenseClaimModelCopyWith(ExpenseClaimModel value, $Res Function(ExpenseClaimModel) _then) = _$ExpenseClaimModelCopyWithImpl;
@useResult
$Res call({
 int id, String title, double total, String status, List<ExpenseItemModel> items, int? travelRequestId, String? travelRequestDestination, String? createdAt, String? submittedAt, double? budgetAmount
});




}
/// @nodoc
class _$ExpenseClaimModelCopyWithImpl<$Res>
    implements $ExpenseClaimModelCopyWith<$Res> {
  _$ExpenseClaimModelCopyWithImpl(this._self, this._then);

  final ExpenseClaimModel _self;
  final $Res Function(ExpenseClaimModel) _then;

/// Create a copy of ExpenseClaimModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? total = null,Object? status = null,Object? items = null,Object? travelRequestId = freezed,Object? travelRequestDestination = freezed,Object? createdAt = freezed,Object? submittedAt = freezed,Object? budgetAmount = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ExpenseItemModel>,travelRequestId: freezed == travelRequestId ? _self.travelRequestId : travelRequestId // ignore: cast_nullable_to_non_nullable
as int?,travelRequestDestination: freezed == travelRequestDestination ? _self.travelRequestDestination : travelRequestDestination // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as String?,budgetAmount: freezed == budgetAmount ? _self.budgetAmount : budgetAmount // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpenseClaimModel].
extension ExpenseClaimModelPatterns on ExpenseClaimModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpenseClaimModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpenseClaimModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpenseClaimModel value)  $default,){
final _that = this;
switch (_that) {
case _ExpenseClaimModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpenseClaimModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExpenseClaimModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  double total,  String status,  List<ExpenseItemModel> items,  int? travelRequestId,  String? travelRequestDestination,  String? createdAt,  String? submittedAt,  double? budgetAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseClaimModel() when $default != null:
return $default(_that.id,_that.title,_that.total,_that.status,_that.items,_that.travelRequestId,_that.travelRequestDestination,_that.createdAt,_that.submittedAt,_that.budgetAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  double total,  String status,  List<ExpenseItemModel> items,  int? travelRequestId,  String? travelRequestDestination,  String? createdAt,  String? submittedAt,  double? budgetAmount)  $default,) {final _that = this;
switch (_that) {
case _ExpenseClaimModel():
return $default(_that.id,_that.title,_that.total,_that.status,_that.items,_that.travelRequestId,_that.travelRequestDestination,_that.createdAt,_that.submittedAt,_that.budgetAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  double total,  String status,  List<ExpenseItemModel> items,  int? travelRequestId,  String? travelRequestDestination,  String? createdAt,  String? submittedAt,  double? budgetAmount)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseClaimModel() when $default != null:
return $default(_that.id,_that.title,_that.total,_that.status,_that.items,_that.travelRequestId,_that.travelRequestDestination,_that.createdAt,_that.submittedAt,_that.budgetAmount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExpenseClaimModel implements ExpenseClaimModel {
  const _ExpenseClaimModel({required this.id, required this.title, required this.total, required this.status, required final  List<ExpenseItemModel> items, this.travelRequestId, this.travelRequestDestination, this.createdAt, this.submittedAt, this.budgetAmount}): _items = items;
  factory _ExpenseClaimModel.fromJson(Map<String, dynamic> json) => _$ExpenseClaimModelFromJson(json);

@override final  int id;
@override final  String title;
@override final  double total;
@override final  String status;
 final  List<ExpenseItemModel> _items;
@override List<ExpenseItemModel> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int? travelRequestId;
@override final  String? travelRequestDestination;
@override final  String? createdAt;
@override final  String? submittedAt;
@override final  double? budgetAmount;

/// Create a copy of ExpenseClaimModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseClaimModelCopyWith<_ExpenseClaimModel> get copyWith => __$ExpenseClaimModelCopyWithImpl<_ExpenseClaimModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpenseClaimModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseClaimModel&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.total, total) || other.total == total)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.travelRequestId, travelRequestId) || other.travelRequestId == travelRequestId)&&(identical(other.travelRequestDestination, travelRequestDestination) || other.travelRequestDestination == travelRequestDestination)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.submittedAt, submittedAt) || other.submittedAt == submittedAt)&&(identical(other.budgetAmount, budgetAmount) || other.budgetAmount == budgetAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,total,status,const DeepCollectionEquality().hash(_items),travelRequestId,travelRequestDestination,createdAt,submittedAt,budgetAmount);

@override
String toString() {
  return 'ExpenseClaimModel(id: $id, title: $title, total: $total, status: $status, items: $items, travelRequestId: $travelRequestId, travelRequestDestination: $travelRequestDestination, createdAt: $createdAt, submittedAt: $submittedAt, budgetAmount: $budgetAmount)';
}


}

/// @nodoc
abstract mixin class _$ExpenseClaimModelCopyWith<$Res> implements $ExpenseClaimModelCopyWith<$Res> {
  factory _$ExpenseClaimModelCopyWith(_ExpenseClaimModel value, $Res Function(_ExpenseClaimModel) _then) = __$ExpenseClaimModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, double total, String status, List<ExpenseItemModel> items, int? travelRequestId, String? travelRequestDestination, String? createdAt, String? submittedAt, double? budgetAmount
});




}
/// @nodoc
class __$ExpenseClaimModelCopyWithImpl<$Res>
    implements _$ExpenseClaimModelCopyWith<$Res> {
  __$ExpenseClaimModelCopyWithImpl(this._self, this._then);

  final _ExpenseClaimModel _self;
  final $Res Function(_ExpenseClaimModel) _then;

/// Create a copy of ExpenseClaimModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? total = null,Object? status = null,Object? items = null,Object? travelRequestId = freezed,Object? travelRequestDestination = freezed,Object? createdAt = freezed,Object? submittedAt = freezed,Object? budgetAmount = freezed,}) {
  return _then(_ExpenseClaimModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,total: null == total ? _self.total : total // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ExpenseItemModel>,travelRequestId: freezed == travelRequestId ? _self.travelRequestId : travelRequestId // ignore: cast_nullable_to_non_nullable
as int?,travelRequestDestination: freezed == travelRequestDestination ? _self.travelRequestDestination : travelRequestDestination // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String?,submittedAt: freezed == submittedAt ? _self.submittedAt : submittedAt // ignore: cast_nullable_to_non_nullable
as String?,budgetAmount: freezed == budgetAmount ? _self.budgetAmount : budgetAmount // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}


/// @nodoc
mixin _$ExpenseCategoryModel {

 int get id; String get name; bool get requiresReceipt;
/// Create a copy of ExpenseCategoryModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseCategoryModelCopyWith<ExpenseCategoryModel> get copyWith => _$ExpenseCategoryModelCopyWithImpl<ExpenseCategoryModel>(this as ExpenseCategoryModel, _$identity);

  /// Serializes this ExpenseCategoryModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseCategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.requiresReceipt, requiresReceipt) || other.requiresReceipt == requiresReceipt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,requiresReceipt);

@override
String toString() {
  return 'ExpenseCategoryModel(id: $id, name: $name, requiresReceipt: $requiresReceipt)';
}


}

/// @nodoc
abstract mixin class $ExpenseCategoryModelCopyWith<$Res>  {
  factory $ExpenseCategoryModelCopyWith(ExpenseCategoryModel value, $Res Function(ExpenseCategoryModel) _then) = _$ExpenseCategoryModelCopyWithImpl;
@useResult
$Res call({
 int id, String name, bool requiresReceipt
});




}
/// @nodoc
class _$ExpenseCategoryModelCopyWithImpl<$Res>
    implements $ExpenseCategoryModelCopyWith<$Res> {
  _$ExpenseCategoryModelCopyWithImpl(this._self, this._then);

  final ExpenseCategoryModel _self;
  final $Res Function(ExpenseCategoryModel) _then;

/// Create a copy of ExpenseCategoryModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? requiresReceipt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,requiresReceipt: null == requiresReceipt ? _self.requiresReceipt : requiresReceipt // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpenseCategoryModel].
extension ExpenseCategoryModelPatterns on ExpenseCategoryModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpenseCategoryModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpenseCategoryModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpenseCategoryModel value)  $default,){
final _that = this;
switch (_that) {
case _ExpenseCategoryModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpenseCategoryModel value)?  $default,){
final _that = this;
switch (_that) {
case _ExpenseCategoryModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  bool requiresReceipt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseCategoryModel() when $default != null:
return $default(_that.id,_that.name,_that.requiresReceipt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  bool requiresReceipt)  $default,) {final _that = this;
switch (_that) {
case _ExpenseCategoryModel():
return $default(_that.id,_that.name,_that.requiresReceipt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  bool requiresReceipt)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseCategoryModel() when $default != null:
return $default(_that.id,_that.name,_that.requiresReceipt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExpenseCategoryModel implements ExpenseCategoryModel {
  const _ExpenseCategoryModel({required this.id, required this.name, required this.requiresReceipt});
  factory _ExpenseCategoryModel.fromJson(Map<String, dynamic> json) => _$ExpenseCategoryModelFromJson(json);

@override final  int id;
@override final  String name;
@override final  bool requiresReceipt;

/// Create a copy of ExpenseCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseCategoryModelCopyWith<_ExpenseCategoryModel> get copyWith => __$ExpenseCategoryModelCopyWithImpl<_ExpenseCategoryModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpenseCategoryModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseCategoryModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.requiresReceipt, requiresReceipt) || other.requiresReceipt == requiresReceipt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,requiresReceipt);

@override
String toString() {
  return 'ExpenseCategoryModel(id: $id, name: $name, requiresReceipt: $requiresReceipt)';
}


}

/// @nodoc
abstract mixin class _$ExpenseCategoryModelCopyWith<$Res> implements $ExpenseCategoryModelCopyWith<$Res> {
  factory _$ExpenseCategoryModelCopyWith(_ExpenseCategoryModel value, $Res Function(_ExpenseCategoryModel) _then) = __$ExpenseCategoryModelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, bool requiresReceipt
});




}
/// @nodoc
class __$ExpenseCategoryModelCopyWithImpl<$Res>
    implements _$ExpenseCategoryModelCopyWith<$Res> {
  __$ExpenseCategoryModelCopyWithImpl(this._self, this._then);

  final _ExpenseCategoryModel _self;
  final $Res Function(_ExpenseCategoryModel) _then;

/// Create a copy of ExpenseCategoryModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? requiresReceipt = null,}) {
  return _then(_ExpenseCategoryModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,requiresReceipt: null == requiresReceipt ? _self.requiresReceipt : requiresReceipt // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
