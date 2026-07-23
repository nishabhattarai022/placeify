// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminStats {

 int get totalVendors; int get pendingCount; int get totalUsers; double get platformGmv; int get approvedCount; int get declinedCount; int get suspendedCount; List<AdminAuditLogEntry> get recentActivity; List<VendorApplication> get recentApplications; int get totalTransactions; int get refundCount; double get refundValue; int get pendingRefundCount; int get successfulRefundCount; int get codCount; int get esewaCount; double get paymentSuccessRate; double get dailyRevenue; double get monthlyRevenue;
/// Create a copy of AdminStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminStatsCopyWith<AdminStats> get copyWith => _$AdminStatsCopyWithImpl<AdminStats>(this as AdminStats, _$identity);

  /// Serializes this AdminStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminStats&&(identical(other.totalVendors, totalVendors) || other.totalVendors == totalVendors)&&(identical(other.pendingCount, pendingCount) || other.pendingCount == pendingCount)&&(identical(other.totalUsers, totalUsers) || other.totalUsers == totalUsers)&&(identical(other.platformGmv, platformGmv) || other.platformGmv == platformGmv)&&(identical(other.approvedCount, approvedCount) || other.approvedCount == approvedCount)&&(identical(other.declinedCount, declinedCount) || other.declinedCount == declinedCount)&&(identical(other.suspendedCount, suspendedCount) || other.suspendedCount == suspendedCount)&&const DeepCollectionEquality().equals(other.recentActivity, recentActivity)&&const DeepCollectionEquality().equals(other.recentApplications, recentApplications)&&(identical(other.totalTransactions, totalTransactions) || other.totalTransactions == totalTransactions)&&(identical(other.refundCount, refundCount) || other.refundCount == refundCount)&&(identical(other.refundValue, refundValue) || other.refundValue == refundValue)&&(identical(other.pendingRefundCount, pendingRefundCount) || other.pendingRefundCount == pendingRefundCount)&&(identical(other.successfulRefundCount, successfulRefundCount) || other.successfulRefundCount == successfulRefundCount)&&(identical(other.codCount, codCount) || other.codCount == codCount)&&(identical(other.esewaCount, esewaCount) || other.esewaCount == esewaCount)&&(identical(other.paymentSuccessRate, paymentSuccessRate) || other.paymentSuccessRate == paymentSuccessRate)&&(identical(other.dailyRevenue, dailyRevenue) || other.dailyRevenue == dailyRevenue)&&(identical(other.monthlyRevenue, monthlyRevenue) || other.monthlyRevenue == monthlyRevenue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,totalVendors,pendingCount,totalUsers,platformGmv,approvedCount,declinedCount,suspendedCount,const DeepCollectionEquality().hash(recentActivity),const DeepCollectionEquality().hash(recentApplications),totalTransactions,refundCount,refundValue,pendingRefundCount,successfulRefundCount,codCount,esewaCount,paymentSuccessRate,dailyRevenue,monthlyRevenue]);

@override
String toString() {
  return 'AdminStats(totalVendors: $totalVendors, pendingCount: $pendingCount, totalUsers: $totalUsers, platformGmv: $platformGmv, approvedCount: $approvedCount, declinedCount: $declinedCount, suspendedCount: $suspendedCount, recentActivity: $recentActivity, recentApplications: $recentApplications, totalTransactions: $totalTransactions, refundCount: $refundCount, refundValue: $refundValue, pendingRefundCount: $pendingRefundCount, successfulRefundCount: $successfulRefundCount, codCount: $codCount, esewaCount: $esewaCount, paymentSuccessRate: $paymentSuccessRate, dailyRevenue: $dailyRevenue, monthlyRevenue: $monthlyRevenue)';
}


}

/// @nodoc
abstract mixin class $AdminStatsCopyWith<$Res>  {
  factory $AdminStatsCopyWith(AdminStats value, $Res Function(AdminStats) _then) = _$AdminStatsCopyWithImpl;
@useResult
$Res call({
 int totalVendors, int pendingCount, int totalUsers, double platformGmv, int approvedCount, int declinedCount, int suspendedCount, List<AdminAuditLogEntry> recentActivity, List<VendorApplication> recentApplications, int totalTransactions, int refundCount, double refundValue, int pendingRefundCount, int successfulRefundCount, int codCount, int esewaCount, double paymentSuccessRate, double dailyRevenue, double monthlyRevenue
});




}
/// @nodoc
class _$AdminStatsCopyWithImpl<$Res>
    implements $AdminStatsCopyWith<$Res> {
  _$AdminStatsCopyWithImpl(this._self, this._then);

  final AdminStats _self;
  final $Res Function(AdminStats) _then;

/// Create a copy of AdminStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalVendors = null,Object? pendingCount = null,Object? totalUsers = null,Object? platformGmv = null,Object? approvedCount = null,Object? declinedCount = null,Object? suspendedCount = null,Object? recentActivity = null,Object? recentApplications = null,Object? totalTransactions = null,Object? refundCount = null,Object? refundValue = null,Object? pendingRefundCount = null,Object? successfulRefundCount = null,Object? codCount = null,Object? esewaCount = null,Object? paymentSuccessRate = null,Object? dailyRevenue = null,Object? monthlyRevenue = null,}) {
  return _then(_self.copyWith(
totalVendors: null == totalVendors ? _self.totalVendors : totalVendors // ignore: cast_nullable_to_non_nullable
as int,pendingCount: null == pendingCount ? _self.pendingCount : pendingCount // ignore: cast_nullable_to_non_nullable
as int,totalUsers: null == totalUsers ? _self.totalUsers : totalUsers // ignore: cast_nullable_to_non_nullable
as int,platformGmv: null == platformGmv ? _self.platformGmv : platformGmv // ignore: cast_nullable_to_non_nullable
as double,approvedCount: null == approvedCount ? _self.approvedCount : approvedCount // ignore: cast_nullable_to_non_nullable
as int,declinedCount: null == declinedCount ? _self.declinedCount : declinedCount // ignore: cast_nullable_to_non_nullable
as int,suspendedCount: null == suspendedCount ? _self.suspendedCount : suspendedCount // ignore: cast_nullable_to_non_nullable
as int,recentActivity: null == recentActivity ? _self.recentActivity : recentActivity // ignore: cast_nullable_to_non_nullable
as List<AdminAuditLogEntry>,recentApplications: null == recentApplications ? _self.recentApplications : recentApplications // ignore: cast_nullable_to_non_nullable
as List<VendorApplication>,totalTransactions: null == totalTransactions ? _self.totalTransactions : totalTransactions // ignore: cast_nullable_to_non_nullable
as int,refundCount: null == refundCount ? _self.refundCount : refundCount // ignore: cast_nullable_to_non_nullable
as int,refundValue: null == refundValue ? _self.refundValue : refundValue // ignore: cast_nullable_to_non_nullable
as double,pendingRefundCount: null == pendingRefundCount ? _self.pendingRefundCount : pendingRefundCount // ignore: cast_nullable_to_non_nullable
as int,successfulRefundCount: null == successfulRefundCount ? _self.successfulRefundCount : successfulRefundCount // ignore: cast_nullable_to_non_nullable
as int,codCount: null == codCount ? _self.codCount : codCount // ignore: cast_nullable_to_non_nullable
as int,esewaCount: null == esewaCount ? _self.esewaCount : esewaCount // ignore: cast_nullable_to_non_nullable
as int,paymentSuccessRate: null == paymentSuccessRate ? _self.paymentSuccessRate : paymentSuccessRate // ignore: cast_nullable_to_non_nullable
as double,dailyRevenue: null == dailyRevenue ? _self.dailyRevenue : dailyRevenue // ignore: cast_nullable_to_non_nullable
as double,monthlyRevenue: null == monthlyRevenue ? _self.monthlyRevenue : monthlyRevenue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminStats].
extension AdminStatsPatterns on AdminStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminStats value)  $default,){
final _that = this;
switch (_that) {
case _AdminStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminStats value)?  $default,){
final _that = this;
switch (_that) {
case _AdminStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalVendors,  int pendingCount,  int totalUsers,  double platformGmv,  int approvedCount,  int declinedCount,  int suspendedCount,  List<AdminAuditLogEntry> recentActivity,  List<VendorApplication> recentApplications,  int totalTransactions,  int refundCount,  double refundValue,  int pendingRefundCount,  int successfulRefundCount,  int codCount,  int esewaCount,  double paymentSuccessRate,  double dailyRevenue,  double monthlyRevenue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminStats() when $default != null:
return $default(_that.totalVendors,_that.pendingCount,_that.totalUsers,_that.platformGmv,_that.approvedCount,_that.declinedCount,_that.suspendedCount,_that.recentActivity,_that.recentApplications,_that.totalTransactions,_that.refundCount,_that.refundValue,_that.pendingRefundCount,_that.successfulRefundCount,_that.codCount,_that.esewaCount,_that.paymentSuccessRate,_that.dailyRevenue,_that.monthlyRevenue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalVendors,  int pendingCount,  int totalUsers,  double platformGmv,  int approvedCount,  int declinedCount,  int suspendedCount,  List<AdminAuditLogEntry> recentActivity,  List<VendorApplication> recentApplications,  int totalTransactions,  int refundCount,  double refundValue,  int pendingRefundCount,  int successfulRefundCount,  int codCount,  int esewaCount,  double paymentSuccessRate,  double dailyRevenue,  double monthlyRevenue)  $default,) {final _that = this;
switch (_that) {
case _AdminStats():
return $default(_that.totalVendors,_that.pendingCount,_that.totalUsers,_that.platformGmv,_that.approvedCount,_that.declinedCount,_that.suspendedCount,_that.recentActivity,_that.recentApplications,_that.totalTransactions,_that.refundCount,_that.refundValue,_that.pendingRefundCount,_that.successfulRefundCount,_that.codCount,_that.esewaCount,_that.paymentSuccessRate,_that.dailyRevenue,_that.monthlyRevenue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalVendors,  int pendingCount,  int totalUsers,  double platformGmv,  int approvedCount,  int declinedCount,  int suspendedCount,  List<AdminAuditLogEntry> recentActivity,  List<VendorApplication> recentApplications,  int totalTransactions,  int refundCount,  double refundValue,  int pendingRefundCount,  int successfulRefundCount,  int codCount,  int esewaCount,  double paymentSuccessRate,  double dailyRevenue,  double monthlyRevenue)?  $default,) {final _that = this;
switch (_that) {
case _AdminStats() when $default != null:
return $default(_that.totalVendors,_that.pendingCount,_that.totalUsers,_that.platformGmv,_that.approvedCount,_that.declinedCount,_that.suspendedCount,_that.recentActivity,_that.recentApplications,_that.totalTransactions,_that.refundCount,_that.refundValue,_that.pendingRefundCount,_that.successfulRefundCount,_that.codCount,_that.esewaCount,_that.paymentSuccessRate,_that.dailyRevenue,_that.monthlyRevenue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminStats implements AdminStats {
  const _AdminStats({required this.totalVendors, required this.pendingCount, required this.totalUsers, required this.platformGmv, required this.approvedCount, required this.declinedCount, required this.suspendedCount, final  List<AdminAuditLogEntry> recentActivity = const <AdminAuditLogEntry>[], final  List<VendorApplication> recentApplications = const <VendorApplication>[], this.totalTransactions = 0, this.refundCount = 0, this.refundValue = 0, this.pendingRefundCount = 0, this.successfulRefundCount = 0, this.codCount = 0, this.esewaCount = 0, this.paymentSuccessRate = 0, this.dailyRevenue = 0, this.monthlyRevenue = 0}): _recentActivity = recentActivity,_recentApplications = recentApplications;
  factory _AdminStats.fromJson(Map<String, dynamic> json) => _$AdminStatsFromJson(json);

@override final  int totalVendors;
@override final  int pendingCount;
@override final  int totalUsers;
@override final  double platformGmv;
@override final  int approvedCount;
@override final  int declinedCount;
@override final  int suspendedCount;
 final  List<AdminAuditLogEntry> _recentActivity;
@override@JsonKey() List<AdminAuditLogEntry> get recentActivity {
  if (_recentActivity is EqualUnmodifiableListView) return _recentActivity;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentActivity);
}

 final  List<VendorApplication> _recentApplications;
@override@JsonKey() List<VendorApplication> get recentApplications {
  if (_recentApplications is EqualUnmodifiableListView) return _recentApplications;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentApplications);
}

@override@JsonKey() final  int totalTransactions;
@override@JsonKey() final  int refundCount;
@override@JsonKey() final  double refundValue;
@override@JsonKey() final  int pendingRefundCount;
@override@JsonKey() final  int successfulRefundCount;
@override@JsonKey() final  int codCount;
@override@JsonKey() final  int esewaCount;
@override@JsonKey() final  double paymentSuccessRate;
@override@JsonKey() final  double dailyRevenue;
@override@JsonKey() final  double monthlyRevenue;

/// Create a copy of AdminStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminStatsCopyWith<_AdminStats> get copyWith => __$AdminStatsCopyWithImpl<_AdminStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminStats&&(identical(other.totalVendors, totalVendors) || other.totalVendors == totalVendors)&&(identical(other.pendingCount, pendingCount) || other.pendingCount == pendingCount)&&(identical(other.totalUsers, totalUsers) || other.totalUsers == totalUsers)&&(identical(other.platformGmv, platformGmv) || other.platformGmv == platformGmv)&&(identical(other.approvedCount, approvedCount) || other.approvedCount == approvedCount)&&(identical(other.declinedCount, declinedCount) || other.declinedCount == declinedCount)&&(identical(other.suspendedCount, suspendedCount) || other.suspendedCount == suspendedCount)&&const DeepCollectionEquality().equals(other._recentActivity, _recentActivity)&&const DeepCollectionEquality().equals(other._recentApplications, _recentApplications)&&(identical(other.totalTransactions, totalTransactions) || other.totalTransactions == totalTransactions)&&(identical(other.refundCount, refundCount) || other.refundCount == refundCount)&&(identical(other.refundValue, refundValue) || other.refundValue == refundValue)&&(identical(other.pendingRefundCount, pendingRefundCount) || other.pendingRefundCount == pendingRefundCount)&&(identical(other.successfulRefundCount, successfulRefundCount) || other.successfulRefundCount == successfulRefundCount)&&(identical(other.codCount, codCount) || other.codCount == codCount)&&(identical(other.esewaCount, esewaCount) || other.esewaCount == esewaCount)&&(identical(other.paymentSuccessRate, paymentSuccessRate) || other.paymentSuccessRate == paymentSuccessRate)&&(identical(other.dailyRevenue, dailyRevenue) || other.dailyRevenue == dailyRevenue)&&(identical(other.monthlyRevenue, monthlyRevenue) || other.monthlyRevenue == monthlyRevenue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,totalVendors,pendingCount,totalUsers,platformGmv,approvedCount,declinedCount,suspendedCount,const DeepCollectionEquality().hash(_recentActivity),const DeepCollectionEquality().hash(_recentApplications),totalTransactions,refundCount,refundValue,pendingRefundCount,successfulRefundCount,codCount,esewaCount,paymentSuccessRate,dailyRevenue,monthlyRevenue]);

@override
String toString() {
  return 'AdminStats(totalVendors: $totalVendors, pendingCount: $pendingCount, totalUsers: $totalUsers, platformGmv: $platformGmv, approvedCount: $approvedCount, declinedCount: $declinedCount, suspendedCount: $suspendedCount, recentActivity: $recentActivity, recentApplications: $recentApplications, totalTransactions: $totalTransactions, refundCount: $refundCount, refundValue: $refundValue, pendingRefundCount: $pendingRefundCount, successfulRefundCount: $successfulRefundCount, codCount: $codCount, esewaCount: $esewaCount, paymentSuccessRate: $paymentSuccessRate, dailyRevenue: $dailyRevenue, monthlyRevenue: $monthlyRevenue)';
}


}

/// @nodoc
abstract mixin class _$AdminStatsCopyWith<$Res> implements $AdminStatsCopyWith<$Res> {
  factory _$AdminStatsCopyWith(_AdminStats value, $Res Function(_AdminStats) _then) = __$AdminStatsCopyWithImpl;
@override @useResult
$Res call({
 int totalVendors, int pendingCount, int totalUsers, double platformGmv, int approvedCount, int declinedCount, int suspendedCount, List<AdminAuditLogEntry> recentActivity, List<VendorApplication> recentApplications, int totalTransactions, int refundCount, double refundValue, int pendingRefundCount, int successfulRefundCount, int codCount, int esewaCount, double paymentSuccessRate, double dailyRevenue, double monthlyRevenue
});




}
/// @nodoc
class __$AdminStatsCopyWithImpl<$Res>
    implements _$AdminStatsCopyWith<$Res> {
  __$AdminStatsCopyWithImpl(this._self, this._then);

  final _AdminStats _self;
  final $Res Function(_AdminStats) _then;

/// Create a copy of AdminStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalVendors = null,Object? pendingCount = null,Object? totalUsers = null,Object? platformGmv = null,Object? approvedCount = null,Object? declinedCount = null,Object? suspendedCount = null,Object? recentActivity = null,Object? recentApplications = null,Object? totalTransactions = null,Object? refundCount = null,Object? refundValue = null,Object? pendingRefundCount = null,Object? successfulRefundCount = null,Object? codCount = null,Object? esewaCount = null,Object? paymentSuccessRate = null,Object? dailyRevenue = null,Object? monthlyRevenue = null,}) {
  return _then(_AdminStats(
totalVendors: null == totalVendors ? _self.totalVendors : totalVendors // ignore: cast_nullable_to_non_nullable
as int,pendingCount: null == pendingCount ? _self.pendingCount : pendingCount // ignore: cast_nullable_to_non_nullable
as int,totalUsers: null == totalUsers ? _self.totalUsers : totalUsers // ignore: cast_nullable_to_non_nullable
as int,platformGmv: null == platformGmv ? _self.platformGmv : platformGmv // ignore: cast_nullable_to_non_nullable
as double,approvedCount: null == approvedCount ? _self.approvedCount : approvedCount // ignore: cast_nullable_to_non_nullable
as int,declinedCount: null == declinedCount ? _self.declinedCount : declinedCount // ignore: cast_nullable_to_non_nullable
as int,suspendedCount: null == suspendedCount ? _self.suspendedCount : suspendedCount // ignore: cast_nullable_to_non_nullable
as int,recentActivity: null == recentActivity ? _self._recentActivity : recentActivity // ignore: cast_nullable_to_non_nullable
as List<AdminAuditLogEntry>,recentApplications: null == recentApplications ? _self._recentApplications : recentApplications // ignore: cast_nullable_to_non_nullable
as List<VendorApplication>,totalTransactions: null == totalTransactions ? _self.totalTransactions : totalTransactions // ignore: cast_nullable_to_non_nullable
as int,refundCount: null == refundCount ? _self.refundCount : refundCount // ignore: cast_nullable_to_non_nullable
as int,refundValue: null == refundValue ? _self.refundValue : refundValue // ignore: cast_nullable_to_non_nullable
as double,pendingRefundCount: null == pendingRefundCount ? _self.pendingRefundCount : pendingRefundCount // ignore: cast_nullable_to_non_nullable
as int,successfulRefundCount: null == successfulRefundCount ? _self.successfulRefundCount : successfulRefundCount // ignore: cast_nullable_to_non_nullable
as int,codCount: null == codCount ? _self.codCount : codCount // ignore: cast_nullable_to_non_nullable
as int,esewaCount: null == esewaCount ? _self.esewaCount : esewaCount // ignore: cast_nullable_to_non_nullable
as int,paymentSuccessRate: null == paymentSuccessRate ? _self.paymentSuccessRate : paymentSuccessRate // ignore: cast_nullable_to_non_nullable
as double,dailyRevenue: null == dailyRevenue ? _self.dailyRevenue : dailyRevenue // ignore: cast_nullable_to_non_nullable
as double,monthlyRevenue: null == monthlyRevenue ? _self.monthlyRevenue : monthlyRevenue // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
