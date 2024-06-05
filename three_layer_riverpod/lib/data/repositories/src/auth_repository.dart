import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_layer_riverpod/data/models/src/current_user.dart';

import '../../data_sources/data_source.dart';
import '../../interfaces/src/auth_interface.dart';

const online = true;

/// A class that implements [AuthInterface] to provide authentication
///
/// This class uses DataSources to authenticate users
class _AuthRepository implements AuthInterface {
  const _AuthRepository(
    this._authRemoteDataSource,
    this._authLocalDataSource,
  );

  final AuthInterface _authRemoteDataSource;
  final AuthInterface _authLocalDataSource;

  @override
  Future<CurrentUserDataModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    // offline or online
    if (online) {
      return _authRemoteDataSource.loginWithEmailAndPassword(
        email: email,
        password: password,
      );
    } else {
      return _authLocalDataSource.loginWithEmailAndPassword(
        email: email,
        password: password,
      );
    }
  }

  @override
  Future<CurrentUserDataModel> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    return _authRemoteDataSource.registerWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}

// 3. Create a provider for the repository
final authRepositoryProvider = Provider<AuthInterface>(
  (ref) => _AuthRepository(
    ref.watch(authRemoteDataSourceProvider),
    ref.watch(authLocalDataSourceProvider),
  ),
);
