// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'storages.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Token _$TokenFromJson(Map<String, dynamic> json) => Token(
  token: json['token'] as String,
  iss: DateTime.parse(json['iss'] as String),
  exp: DateTime.parse(json['exp'] as String),
);

Map<String, dynamic> _$TokenToJson(Token instance) => <String, dynamic>{
  'iss': instance.iss.toIso8601String(),
  'exp': instance.exp.toIso8601String(),
  'token': instance.token,
};

TokenPair _$TokenPairFromJson(Map<String, dynamic> json) => TokenPair(
  access: Token.fromJson(json['access'] as Map<String, dynamic>),
  refresh: Token.fromJson(json['refresh'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TokenPairToJson(TokenPair instance) => <String, dynamic>{
  'access': instance.access,
  'refresh': instance.refresh,
};
