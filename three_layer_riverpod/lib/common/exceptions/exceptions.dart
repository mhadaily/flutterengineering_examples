sealed class AppException implements Exception {
  AppException(
    this.code,
    this.message,
  );

  final String code;
  final String message;

  @override
  String toString() {
    return {
      'code': code,
      'message': message,
    }.toString();
  }
}

class AppFormatException extends AppException {
  AppFormatException({
    String code = 'FORMAT_EXCEPTION',
    String message = 'Error While parsing data!',
  }) : super(code, message);
}

class AppTimeoutException extends AppException {
  AppTimeoutException({
    String code = 'TIMEOUT',
    String message = 'Timeout!',
  }) : super(code, message);
}

class AppNoInternetException extends AppException {
  AppNoInternetException({
    String code = 'NO_INTERNET',
    String message = 'No Internet Connection!',
  }) : super(code, message);
}

class AppFirebaseException extends AppException {
  AppFirebaseException({
    required String code,
    required String message,
  }) : super(code, message);
}

class EmailAlreadyInUseException extends AppException {
  EmailAlreadyInUseException({
    String code = 'EMAIL_ALREADY_IN_USE',
    String message = 'Email already in use',
  }) : super(code, message);
}

class WrongPasswordException extends AppException {
  WrongPasswordException({
    String code = 'WRONG_PASSWORD',
    String message = 'Wrong password',
  }) : super(code, message);
}

class UserNotFoundException extends AppException {
  UserNotFoundException({
    String code = 'USER_NOT_FOUND',
    String message = 'User not found',
  }) : super(code, message);
}

class UnknownException extends AppException {
  UnknownException({
    String code = 'UNKNOWN',
    String message = 'An unknown error occurred',
  }) : super(code, message);
}
