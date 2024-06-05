import 'package:json_annotation/json_annotation.dart';

part 'post.g.dart';

@JsonSerializable()
class PostDataModel {
  const PostDataModel({
    required this.uid,
    required this.userId,
    required this.content,
    required this.createdAt,
  });

  @JsonKey(includeToJson: false)
  final String uid;

  final String userId;
  final String content;
  final DateTime createdAt;

  factory PostDataModel.fromJson(Map<String, dynamic> json) =>
      _$PostDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$PostDataModelToJson(this);
}
