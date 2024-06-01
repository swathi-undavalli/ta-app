// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'roaster.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RoasterImpl _$$RoasterImplFromJson(Map<String, dynamic> json) => _$RoasterImpl(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      age: (json['age'] as num).toInt(),
    );

Map<String, dynamic> _$$RoasterImplToJson(_$RoasterImpl instance) => <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'age': instance.age,
    };
