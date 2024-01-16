abstract interface class INotificationService {
  void sendMessage(String message, String receiver);
}

class EmailService implements INotificationService {
  @override
  void sendMessage(String message, String receiver) {
    print("Sending email to $receiver: $message");
  }
}

class SmsService implements INotificationService {
  @override
  void sendMessage(String message, String receiver) {
    print("Sending SMS to $receiver: $message");
  }
}

// Fake notification service for testing
class FakeNotificationService implements INotificationService {
  @override
  void sendMessage(String message, String receiver) {
    print("Fake service sending to $receiver: $message");
  }
}


class Notification {
  INotificationService _notificationService;

  Notification(this._notificationService);

  void notifyUser(String message, String receiver) {
    _notificationService.sendMessage(message, receiver);
  }
}

void main() {
  INotificationService emailService = EmailService();
  Notification notification = Notification(emailService);
  notification.notifyUser("Hello, user!", "user@example.com");

  INotificationService smsService = SmsService();
  Notification smsNotification = Notification(smsService);
  smsNotification.notifyUser("Hello, user!", "123456789");
}
