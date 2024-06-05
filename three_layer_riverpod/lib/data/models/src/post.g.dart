// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostDataModel _$PostDataModelFromJson(Map<String, dynamic> json) =>
    PostDataModel(
      uid: json['uid'] as String,
      userId: json['userId'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$PostDataModelToJson(PostDataModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'content': instance.content,
      'createdAt': instance.createdAt.toIso8601String(),
    };
