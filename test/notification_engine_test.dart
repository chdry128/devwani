import 'package:flutter_test/flutter_test.dart';
import 'package:devavani/services/notification_service.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Notification Engine Scheduling Tests', () {
    late NotificationService service;

    setUp(() async {
      // Initialize timezone data for tests
      tzdata.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));
      service = NotificationService();
      await service.init();
    });

    tearDown(() async {
      await service.cancelAllReminders();
    });

    test('scheduleDailyMorningReminder creates a pending notification', () async {
      // Schedule 1 minute from now
      final now = tz.TZDateTime.now(tz.local);
      final future = now.add(const Duration(minutes: 1));
      await service.scheduleDailyMorningReminder(
        hour: future.hour,
        minute: future.minute,
        lang: 'hi',
      );

      // Verify via public API — pendingNotificationRequests() is exposed publicly
      final pending = await service.getPendingNotifications();
      expect(pending.any((p) => p.id == NotificationService.morningReminderId), isTrue);
    });

    test('scheduleDailyEveningReminder creates a pending notification', () async {
      final now = tz.TZDateTime.now(tz.local);
      final future = now.add(const Duration(minutes: 1));
      await service.scheduleDailyEveningReminder(
        hour: future.hour,
        minute: future.minute,
        lang: 'hi',
      );

      final pending = await service.getPendingNotifications();
      expect(pending.any((p) => p.id == NotificationService.eveningReminderId), isTrue);
    });
  });
}
