import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class UserRepository {
  // UserRepository methods
}

class UserProfileWidget extends StatefulWidget {
  final UserRepository userRepository;

  const UserProfileWidget(this.userRepository, {super.key});

  @override
  State<UserProfileWidget> createState() => UserProfileWidgetState();
}

class UserProfileWidgetState extends State<UserProfileWidget> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    // Widget build logic
    return const SizedBox();
  }
}

//1.
class DummyUserRepository extends UserRepository {}

void main() {
  testWidgets('UserProfileWidget should render correctly', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        //2.
        home: UserProfileWidget(DummyUserRepository()),
      ),
    );
    //3.
    final widget = tester.state<UserProfileWidgetState>(
      find.byType(
        UserProfileWidget,
      ),
    );

    //4.
    expect(
      widget.count,
      0,
      reason: 'initial state must be 0 in this widget',
    );
  });
}
