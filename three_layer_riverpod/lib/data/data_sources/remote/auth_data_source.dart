import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:three_layer_riverpod/data/models/src/current_user.dart';

import '../../../common/common.dart';
import '../../interfaces/interfaces.dart';

/// A class that implements [AuthInterface] to provide authentication
///
/// This class uses Firebase Authentication to authenticate users
class _AuthRemoteDataSource implements AuthInterface {
  const _AuthRemoteDataSource(
    this._authService,
  );

  /// An instance of [FirebaseAuth] to authenticate users
  final FirebaseAuth _authService;

  @override
  Future<CurrentUserDataModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user!;
      final userJson = {
        'uid': user.uid,
        'name': user.displayName,
        'email': user.email,
      };
      return CurrentUserDataModel.fromJson(userJson);
    } on FirebaseAuthException catch (e) {
      throw AppFirebaseException(
        code: e.code,
        message: e.message ?? 'Error loading user data',
      );
    } on FormatException catch (_) {
      throw AppFormatException();
    } on SocketException catch (_) {
      throw AppNoInternetException();
    } on TimeoutException catch (_) {
      throw AppTimeoutException();
    } catch (e) {
      throw UnknownException(message: e.toString());
    }
  }

  @override
  Future<CurrentUserDataModel> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) {
    // TODO: implement registerWithEmailAndPassword
    throw UnimplementedError();
  }
}

// 3. Create a provider for the data source
final authRemoteDataSourceProvider = Provider<AuthInterface>(
  (ref) => _AuthRemoteDataSource(
    ref.watch(httpClient),
  ),
);

final httpClient = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);
