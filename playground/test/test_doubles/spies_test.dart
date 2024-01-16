import 'package:flutter_test/flutter_test.dart';

class LoggerService {
  void log(String message) {
    // Actual logging logic
  }
}

class UserManager {
  final LoggerService logger;

  UserManager(this.logger);

  void deleteUser(String userId) {
    // User deletion logic
    logger.log('User $userId deleted');
  }
}

class SpyLoggerService extends LoggerService {
  int logCallCount = 0;

  @override
  void log(String message) {
    logCallCount++;
    super.log(message); // Calling the real log method
  }
}

void main() {
  test('UserManager should call LoggerService when deleting a user', () {
    final spyLogger = SpyLoggerService();
    final userManager = UserManager(spyLogger);

    userManager.deleteUser('123');

    expect(spyLogger.logCallCount, 1); // Verifying that log was called once
  });
}
