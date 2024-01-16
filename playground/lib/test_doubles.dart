import 'package:flutter/material.dart';

class UserProfile {
  final String userId;
  final String name;
  final String email;

  UserProfile({
    required this.userId,
    required this.name,
    required this.email,
  });
}

class HttpServer {
  Uri start(int port) {
    return Uri.https('localhost:$port');
  }
}

abstract class Database {
  Future<void> write(UserProfile user);
  Future<UserProfile> read(String userId);
}

abstract class UserProfileService {
  Future<UserProfile> getUserProfile(String userId);
}

class UserRepository {
  UserRepository(this.database);

  final Database database;

  Future<UserProfile> loadUserProfile(String userId) {
    return database.read(userId);
  }
}

class UserProfileWidget extends StatelessWidget {
  final UserProfileService userProfileService;

  const UserProfileWidget(
    this.userProfileService, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserProfile>(
      future: userProfileService.getUserProfile('123'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.name);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
