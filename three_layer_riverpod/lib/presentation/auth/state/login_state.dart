import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/domain.dart';

final loginStateProvider = AsyncNotifierProvider<_LoginState, bool>(
  () => _LoginState(),
);

class _LoginState extends AsyncNotifier<bool> {
  @override
  bool build() => false;

  loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // loading
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () {
        return ref
            .watch(
              loginUseCaseProvider,
            )
            .loginWithEmailAndPassword(
              email: email,
              password: password,
            );
      },
    );
  }
}
