import 'package:flutter/material.dart';
import 'package:three_layer_riverpod/data/data.dart';

@immutable
class Post extends PostDataModel {
  const Post({
    required super.uid,
    required super.userId,
    required super.content,
    required super.createdAt,
  });

  // business logic
  get excerpt => content.length > 100 ? content.substring(0, 100) : content;

  factory Post.fromDataModel(PostDataModel dataModel) {
    return Post(
      uid: dataModel.uid,
      userId: dataModel.userId,
      content: dataModel.content,
      createdAt: dataModel.createdAt,
    );
  }

  PostDataModel toDataModel() {
    return PostDataModel(
      uid: uid,
      userId: userId,
      content: content,
      createdAt: createdAt,
    );
  }
}
