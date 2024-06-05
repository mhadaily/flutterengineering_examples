import '../../models/models.dart';

/// Auth Interface for Auth Repository and Data source
///
/// This interface is used to define the methods
/// that will be implemented by the Auth Repository
/// and Data source
///
/// More info:
/// - Here is our ADR [LINK]
abstract interface class AuthInterface {
  /// Register a new user with email and password
  ///
  /// This method will be implemented by the Auth Repository
  /// and Data source
  Future<CurrentUserDataModel> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<CurrentUserDataModel> registerWithEmailAndPassword({
    required String email,
    required String password,
  });
}
