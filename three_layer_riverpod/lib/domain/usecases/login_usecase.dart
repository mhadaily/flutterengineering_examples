import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data.dart';

/// This is the use case class for login.
///
/// This class will be used to login a user with email and password.
/// It will also be used to login a user with Apple and Google.
/// This class will be used in the presentation layer.
abstract interface class LoginUseCase {
  Future<bool> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<bool> loginWithApple();
  Future<bool> loginWithGoogle();
}

class _LoginUseCase implements LoginUseCase {
  _LoginUseCase(
    this._authRepository,
  );

  final AuthInterface _authRepository;

  @override
  Future<bool> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final user = await _authRepository.loginWithEmailAndPassword(
      email: email,
      password: password,
    );
    // return AppUser.fromCurrentUserDataModel(user);
    return user.email != null;
  }

  @override
  Future<bool> loginWithGoogle() {
    throw UnimplementedError();
  }

  @override
  Future<bool> loginWithApple() {
    throw UnimplementedError();
  }
}

// 3. Create a provider for the use case
final loginUseCaseProvider = Provider<LoginUseCase>(
  (ref) => _LoginUseCase(
   ref.watch(authRepositoryProvider),
  ),
);
