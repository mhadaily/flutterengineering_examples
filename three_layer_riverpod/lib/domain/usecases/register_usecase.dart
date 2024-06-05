import '../../data/data.dart';

abstract interface class RegisterUseCase {
  Future<bool> registerWithEmailAndPassword({
    required String email,
    required String password,
  });
}

class _RegisterUseCase implements RegisterUseCase {
  _RegisterUseCase(
    this._authRepository,
  );

  final AuthInterface _authRepository;

  @override
  Future<bool> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final user = await _authRepository.registerWithEmailAndPassword(
      email: email,
      password: password,
    );
    return user.email != null;
  }
}
