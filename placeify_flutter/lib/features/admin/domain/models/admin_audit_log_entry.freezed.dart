// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_audit_log_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
AdminAuditAction _$AdminAuditActionFromJson(
  Map<String, dynamic> json
) {
        switch (json['kind']) {
                  case 'application':
          return ApplicationAuditAction.fromJson(
            json
          );
                case 'vendor':
          return VendorAuditAction.fromJson(
            json
          );
        
          default:
            throw CheckedFromJsonException(
  json,
  'kind',
  'AdminAuditAction',
  'Invalid union type "${json['kind']}"!'
);
        }
      
}

/// @nodoc
mixin _$AdminAuditAction {



  /// Serializes this AdminAuditAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminAuditAction);
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AdminAuditAction()';
}


}

/// @nodoc
class $AdminAuditActionCopyWith<$Res>  {
$AdminAuditActionCopyWith(AdminAuditAction _, $Res Function(AdminAuditAction) __);
}


/// Adds pattern-matching-related methods to [AdminAuditAction].
extension AdminAuditActionPatterns on AdminAuditAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ApplicationAuditAction value)?  application,TResult Function( VendorAuditAction value)?  vendor,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ApplicationAuditAction() when application != null:
return application(_that);case VendorAuditAction() when vendor != null:
return vendor(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ApplicationAuditAction value)  application,required TResult Function( VendorAuditAction value)  vendor,}){
final _that = this;
switch (_that) {
case ApplicationAuditAction():
return application(_that);case VendorAuditAction():
return vendor(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ApplicationAuditAction value)?  application,TResult? Function( VendorAuditAction value)?  vendor,}){
final _that = this;
switch (_that) {
case ApplicationAuditAction() when application != null:
return application(_that);case VendorAuditAction() when vendor != null:
return vendor(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( ApplicationDecision decision)?  application,TResult Function( AuditAction action)?  vendor,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ApplicationAuditAction() when application != null:
return application(_that.decision);case VendorAuditAction() when vendor != null:
return vendor(_that.action);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( ApplicationDecision decision)  application,required TResult Function( AuditAction action)  vendor,}) {final _that = this;
switch (_that) {
case ApplicationAuditAction():
return application(_that.decision);case VendorAuditAction():
return vendor(_that.action);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( ApplicationDecision decision)?  application,TResult? Function( AuditAction action)?  vendor,}) {final _that = this;
switch (_that) {
case ApplicationAuditAction() when application != null:
return application(_that.decision);case VendorAuditAction() when vendor != null:
return vendor(_that.action);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class ApplicationAuditAction implements AdminAuditAction {
  const ApplicationAuditAction({required this.decision, final  String? $type}): $type = $type ?? 'application';
  factory ApplicationAuditAction.fromJson(Map<String, dynamic> json) => _$ApplicationAuditActionFromJson(json);

 final  ApplicationDecision decision;

@JsonKey(name: 'kind')
final String $type;


/// Create a copy of AdminAuditAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ApplicationAuditActionCopyWith<ApplicationAuditAction> get copyWith => _$ApplicationAuditActionCopyWithImpl<ApplicationAuditAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ApplicationAuditActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ApplicationAuditAction&&(identical(other.decision, decision) || other.decision == decision));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,decision);

@override
String toString() {
  return 'AdminAuditAction.application(decision: $decision)';
}


}

/// @nodoc
abstract mixin class $ApplicationAuditActionCopyWith<$Res> implements $AdminAuditActionCopyWith<$Res> {
  factory $ApplicationAuditActionCopyWith(ApplicationAuditAction value, $Res Function(ApplicationAuditAction) _then) = _$ApplicationAuditActionCopyWithImpl;
@useResult
$Res call({
 ApplicationDecision decision
});




}
/// @nodoc
class _$ApplicationAuditActionCopyWithImpl<$Res>
    implements $ApplicationAuditActionCopyWith<$Res> {
  _$ApplicationAuditActionCopyWithImpl(this._self, this._then);

  final ApplicationAuditAction _self;
  final $Res Function(ApplicationAuditAction) _then;

/// Create a copy of AdminAuditAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? decision = null,}) {
  return _then(ApplicationAuditAction(
decision: null == decision ? _self.decision : decision // ignore: cast_nullable_to_non_nullable
as ApplicationDecision,
  ));
}


}

/// @nodoc
@JsonSerializable()

class VendorAuditAction implements AdminAuditAction {
  const VendorAuditAction({required this.action, final  String? $type}): $type = $type ?? 'vendor';
  factory VendorAuditAction.fromJson(Map<String, dynamic> json) => _$VendorAuditActionFromJson(json);

 final  AuditAction action;

@JsonKey(name: 'kind')
final String $type;


/// Create a copy of AdminAuditAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VendorAuditActionCopyWith<VendorAuditAction> get copyWith => _$VendorAuditActionCopyWithImpl<VendorAuditAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VendorAuditActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VendorAuditAction&&(identical(other.action, action) || other.action == action));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,action);

@override
String toString() {
  return 'AdminAuditAction.vendor(action: $action)';
}


}

/// @nodoc
abstract mixin class $VendorAuditActionCopyWith<$Res> implements $AdminAuditActionCopyWith<$Res> {
  factory $VendorAuditActionCopyWith(VendorAuditAction value, $Res Function(VendorAuditAction) _then) = _$VendorAuditActionCopyWithImpl;
@useResult
$Res call({
 AuditAction action
});




}
/// @nodoc
class _$VendorAuditActionCopyWithImpl<$Res>
    implements $VendorAuditActionCopyWith<$Res> {
  _$VendorAuditActionCopyWithImpl(this._self, this._then);

  final VendorAuditAction _self;
  final $Res Function(VendorAuditAction) _then;

/// Create a copy of AdminAuditAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? action = null,}) {
  return _then(VendorAuditAction(
action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as AuditAction,
  ));
}


}


/// @nodoc
mixin _$AdminAuditLogEntry {

 String get id; AdminAuditAction get action; String get actorAdminId; String get targetUserId; DateTime get timestamp; String? get note;
/// Create a copy of AdminAuditLogEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminAuditLogEntryCopyWith<AdminAuditLogEntry> get copyWith => _$AdminAuditLogEntryCopyWithImpl<AdminAuditLogEntry>(this as AdminAuditLogEntry, _$identity);

  /// Serializes this AdminAuditLogEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminAuditLogEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.action, action) || other.action == action)&&(identical(other.actorAdminId, actorAdminId) || other.actorAdminId == actorAdminId)&&(identical(other.targetUserId, targetUserId) || other.targetUserId == targetUserId)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,action,actorAdminId,targetUserId,timestamp,note);

@override
String toString() {
  return 'AdminAuditLogEntry(id: $id, action: $action, actorAdminId: $actorAdminId, targetUserId: $targetUserId, timestamp: $timestamp, note: $note)';
}


}

/// @nodoc
abstract mixin class $AdminAuditLogEntryCopyWith<$Res>  {
  factory $AdminAuditLogEntryCopyWith(AdminAuditLogEntry value, $Res Function(AdminAuditLogEntry) _then) = _$AdminAuditLogEntryCopyWithImpl;
@useResult
$Res call({
 String id, AdminAuditAction action, String actorAdminId, String targetUserId, DateTime timestamp, String? note
});


$AdminAuditActionCopyWith<$Res> get action;

}
/// @nodoc
class _$AdminAuditLogEntryCopyWithImpl<$Res>
    implements $AdminAuditLogEntryCopyWith<$Res> {
  _$AdminAuditLogEntryCopyWithImpl(this._self, this._then);

  final AdminAuditLogEntry _self;
  final $Res Function(AdminAuditLogEntry) _then;

/// Create a copy of AdminAuditLogEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? action = null,Object? actorAdminId = null,Object? targetUserId = null,Object? timestamp = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as AdminAuditAction,actorAdminId: null == actorAdminId ? _self.actorAdminId : actorAdminId // ignore: cast_nullable_to_non_nullable
as String,targetUserId: null == targetUserId ? _self.targetUserId : targetUserId // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of AdminAuditLogEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminAuditActionCopyWith<$Res> get action {
  
  return $AdminAuditActionCopyWith<$Res>(_self.action, (value) {
    return _then(_self.copyWith(action: value));
  });
}
}


/// Adds pattern-matching-related methods to [AdminAuditLogEntry].
extension AdminAuditLogEntryPatterns on AdminAuditLogEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminAuditLogEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminAuditLogEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminAuditLogEntry value)  $default,){
final _that = this;
switch (_that) {
case _AdminAuditLogEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminAuditLogEntry value)?  $default,){
final _that = this;
switch (_that) {
case _AdminAuditLogEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  AdminAuditAction action,  String actorAdminId,  String targetUserId,  DateTime timestamp,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminAuditLogEntry() when $default != null:
return $default(_that.id,_that.action,_that.actorAdminId,_that.targetUserId,_that.timestamp,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  AdminAuditAction action,  String actorAdminId,  String targetUserId,  DateTime timestamp,  String? note)  $default,) {final _that = this;
switch (_that) {
case _AdminAuditLogEntry():
return $default(_that.id,_that.action,_that.actorAdminId,_that.targetUserId,_that.timestamp,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  AdminAuditAction action,  String actorAdminId,  String targetUserId,  DateTime timestamp,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _AdminAuditLogEntry() when $default != null:
return $default(_that.id,_that.action,_that.actorAdminId,_that.targetUserId,_that.timestamp,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminAuditLogEntry implements AdminAuditLogEntry {
  const _AdminAuditLogEntry({required this.id, required this.action, required this.actorAdminId, required this.targetUserId, required this.timestamp, this.note});
  factory _AdminAuditLogEntry.fromJson(Map<String, dynamic> json) => _$AdminAuditLogEntryFromJson(json);

@override final  String id;
@override final  AdminAuditAction action;
@override final  String actorAdminId;
@override final  String targetUserId;
@override final  DateTime timestamp;
@override final  String? note;

/// Create a copy of AdminAuditLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminAuditLogEntryCopyWith<_AdminAuditLogEntry> get copyWith => __$AdminAuditLogEntryCopyWithImpl<_AdminAuditLogEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminAuditLogEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminAuditLogEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.action, action) || other.action == action)&&(identical(other.actorAdminId, actorAdminId) || other.actorAdminId == actorAdminId)&&(identical(other.targetUserId, targetUserId) || other.targetUserId == targetUserId)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,action,actorAdminId,targetUserId,timestamp,note);

@override
String toString() {
  return 'AdminAuditLogEntry(id: $id, action: $action, actorAdminId: $actorAdminId, targetUserId: $targetUserId, timestamp: $timestamp, note: $note)';
}


}

/// @nodoc
abstract mixin class _$AdminAuditLogEntryCopyWith<$Res> implements $AdminAuditLogEntryCopyWith<$Res> {
  factory _$AdminAuditLogEntryCopyWith(_AdminAuditLogEntry value, $Res Function(_AdminAuditLogEntry) _then) = __$AdminAuditLogEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, AdminAuditAction action, String actorAdminId, String targetUserId, DateTime timestamp, String? note
});


@override $AdminAuditActionCopyWith<$Res> get action;

}
/// @nodoc
class __$AdminAuditLogEntryCopyWithImpl<$Res>
    implements _$AdminAuditLogEntryCopyWith<$Res> {
  __$AdminAuditLogEntryCopyWithImpl(this._self, this._then);

  final _AdminAuditLogEntry _self;
  final $Res Function(_AdminAuditLogEntry) _then;

/// Create a copy of AdminAuditLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? action = null,Object? actorAdminId = null,Object? targetUserId = null,Object? timestamp = null,Object? note = freezed,}) {
  return _then(_AdminAuditLogEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,action: null == action ? _self.action : action // ignore: cast_nullable_to_non_nullable
as AdminAuditAction,actorAdminId: null == actorAdminId ? _self.actorAdminId : actorAdminId // ignore: cast_nullable_to_non_nullable
as String,targetUserId: null == targetUserId ? _self.targetUserId : targetUserId // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of AdminAuditLogEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdminAuditActionCopyWith<$Res> get action {
  
  return $AdminAuditActionCopyWith<$Res>(_self.action, (value) {
    return _then(_self.copyWith(action: value));
  });
}
}

// dart format on
