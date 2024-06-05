import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';

part 'current_user.g.dart';

@JsonSerializable()
class CurrentUserDataModel {
  const CurrentUserDataModel({
    required this.uid,
    this.name,
    this.email,
  });

  final String uid;
  final String? name;
  final String? email;

  factory CurrentUserDataModel.fromFirebaseUser(User user) {
    return CurrentUserDataModel(
      uid: user.uid,
      name: user.displayName,
      email: user.email,
    );
  }

  factory CurrentUserDataModel.fromJson(Map<String, dynamic> json) =>
      _$CurrentUserDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentUserDataModelToJson(this);
}
