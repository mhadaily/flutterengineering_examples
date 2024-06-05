import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_layer_riverpod/data/models/src/current_user.dart';

import '../../interfaces/src/auth_interface.dart';

class _AuthLocalDataSource implements AuthInterface {
  @override
  Future<CurrentUserDataModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    // todo: implement
    throw UnimplementedError();
  }

  @override
  Future<CurrentUserDataModel> registerWithEmailAndPassword(
      {required String email, required String password}) {
    // TODO: implement registerWithEmailAndPassword
    throw UnimplementedError();
  }
}

// 3. Create a provider for the data source
final authLocalDataSourceProvider = Provider<AuthInterface>(
  (ref) => _AuthLocalDataSource(),
);
