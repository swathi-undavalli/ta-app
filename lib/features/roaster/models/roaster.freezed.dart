// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'roaster.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Roaster _$RoasterFromJson(Map<String, dynamic> json) {
  return _Roaster.fromJson(json);
}

/// @nodoc
mixin _$Roaster {
  String get firstName => throw _privateConstructorUsedError;

  String get lastName => throw _privateConstructorUsedError;

  int get age => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RoasterCopyWith<Roaster> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RoasterCopyWith<$Res> {
  factory $RoasterCopyWith(Roaster value, $Res Function(Roaster) then) = _$RoasterCopyWithImpl<$Res, Roaster>;

  @useResult
  $Res call({String firstName, String lastName, int age});
}

/// @nodoc
class _$RoasterCopyWithImpl<$Res, $Val extends Roaster> implements $RoasterCopyWith<$Res> {
  _$RoasterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;

  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? age = null,
  }) {
    return _then(_value.copyWith(
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      age: null == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RoasterImplCopyWith<$Res> implements $RoasterCopyWith<$Res> {
  factory _$$RoasterImplCopyWith(_$RoasterImpl value, $Res Function(_$RoasterImpl) then) =
      __$$RoasterImplCopyWithImpl<$Res>;

  @override
  @useResult
  $Res call({String firstName, String lastName, int age});
}

/// @nodoc
class __$$RoasterImplCopyWithImpl<$Res> extends _$RoasterCopyWithImpl<$Res, _$RoasterImpl>
    implements _$$RoasterImplCopyWith<$Res> {
  __$$RoasterImplCopyWithImpl(_$RoasterImpl _value, $Res Function(_$RoasterImpl) _then) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? firstName = null,
    Object? lastName = null,
    Object? age = null,
  }) {
    return _then(_$RoasterImpl(
      firstName: null == firstName
          ? _value.firstName
          : firstName // ignore: cast_nullable_to_non_nullable
              as String,
      lastName: null == lastName
          ? _value.lastName
          : lastName // ignore: cast_nullable_to_non_nullable
              as String,
      age: null == age
          ? _value.age
          : age // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RoasterImpl implements _Roaster {
  const _$RoasterImpl({required this.firstName, required this.lastName, required this.age});

  factory _$RoasterImpl.fromJson(Map<String, dynamic> json) => _$$RoasterImplFromJson(json);

  @override
  final String firstName;
  @override
  final String lastName;
  @override
  final int age;

  @override
  String toString() {
    return 'Roaster(firstName: $firstName, lastName: $lastName, age: $age)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RoasterImpl &&
            (identical(other.firstName, firstName) || other.firstName == firstName) &&
            (identical(other.lastName, lastName) || other.lastName == lastName) &&
            (identical(other.age, age) || other.age == age));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, firstName, lastName, age);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RoasterImplCopyWith<_$RoasterImpl> get copyWith => __$$RoasterImplCopyWithImpl<_$RoasterImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RoasterImplToJson(
      this,
    );
  }
}

abstract class _Roaster implements Roaster {
  const factory _Roaster({required final String firstName, required final String lastName, required final int age}) =
      _$RoasterImpl;

  factory _Roaster.fromJson(Map<String, dynamic> json) = _$RoasterImpl.fromJson;

  @override
  String get firstName;

  @override
  String get lastName;

  @override
  int get age;

  @override
  @JsonKey(ignore: true)
  _$$RoasterImplCopyWith<_$RoasterImpl> get copyWith => throw _privateConstructorUsedError;
}
