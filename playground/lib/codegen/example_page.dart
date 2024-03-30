import 'package:flutter/material.dart';
import 'package:route_annotations/route_annotations.dart';

part 'example_page.g.dart';

@RouteConfig(name: 'userProfile', path: '/userProfile')
class UserProfilePage extends StatelessWidget {
  const UserProfilePage({
    super.key,
    required this.userId,
  });

  // userId is a field to pass as a query parameter
  @QueryParam('userId')
  final String userId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile')),
      body: Center(child: Text('User ID: $userId')),
    );
  }
}
