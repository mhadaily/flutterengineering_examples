import 'package:flutter/material.dart';

import '../../data/data.dart';

@immutable
class AppUser {
  const AppUser({
    required this.id,
    this.firstName,
    this.lastName,
    this.avatarUrl = 'https://via.placeholder.com/150',
    this.email,
  });

  final String id;
  final String? firstName;
  final String? lastName;
  final String avatarUrl;
  final String? email;

  get fullName => '$firstName $lastName';

  factory AppUser.fromCurrentUserDataModel(
    CurrentUserDataModel currentUserDataModel,
  ) {
    return AppUser(
      id: currentUserDataModel.uid,
      firstName: currentUserDataModel.name,
      lastName: currentUserDataModel.name,
      email: currentUserDataModel.email,
    );
  }

  toCurrentUserDataModel() {
    return CurrentUserDataModel(
      uid: id,
      name: fullName,
      email: email,
    );
  }
}
