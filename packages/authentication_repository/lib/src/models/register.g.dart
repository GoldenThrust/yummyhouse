// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Register _$RegisterFromJson(Map<String, dynamic> json) => Register(
  message: json['message'] as String,
  user: User.fromJson(json['user'] as Map<String, dynamic>),
  token: json['token'] as String,
);

Map<String, dynamic> _$RegisterToJson(Register instance) => <String, dynamic>{
  'message': instance.message,
  'user': instance.user.toJson(),
  'token': instance.token,
};
