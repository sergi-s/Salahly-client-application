import 'dart:core';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';


Future<void> createPlantFoodNotification() async {
  print("gowa function");
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: CreateUniqueId(),
      channelKey: 'basic_channel',
      title: '${Emojis.wheater_droplet} Add some water to your plant!',
      body: 'Water your plant regularly to keep it healthy.',
      notificationLayout: NotificationLayout.Default,
    ),
  );
  print("25er function");
}
Future<void> createWaterReminderNotification({required String title,required String body,
  required NotificationWeekAndTime notificationSchedule}) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: CreateUniqueId(),
      channelKey: 'scheduled_channel',
      title: title,
      body: body,
      notificationLayout: NotificationLayout.Default,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'MARK_DONE',
        label: 'Open',
      )
    ],
    schedule: NotificationCalendar(
      weekday: notificationSchedule.date,
      hour: notificationSchedule.timeofday.hour,
      minute: notificationSchedule.timeofday.minute,
      second: 0,
      millisecond: 0,

    ),
  );
}

Future<void> addReminder({required String title,required String body,
  required NotificationDateAndTime notificationSchedule}) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: CreateUniqueId(),
      channelKey: 'scheduled_channel',
      title: title,
      body: body,
      notificationLayout: NotificationLayout.Default,
    ),
    actionButtons: [
      NotificationActionButton(
        key: 'MARK_DONE',
        label: 'Mark Done',
      )
    ],
    schedule: NotificationCalendar(
      day: notificationSchedule.day!,
      year: notificationSchedule.year!,
      month: notificationSchedule.month!,
      hour: notificationSchedule.timeOfDay!.hour,
      minute: notificationSchedule.timeOfDay!.minute,
      second: 0,
      millisecond: 0,

    ),
  );
}

class NotificationWeekAndTime {
  final int date;
  final TimeOfDay timeofday;

  NotificationWeekAndTime({
    required this.date,
    required this.timeofday,
  });
}

class NotificationDateAndTime {
  int? year, month, week, day;
  TimeOfDay? timeOfDay;

  NotificationDateAndTime(
      {this.year, this.month, this.week, this.day, this.timeOfDay});

}

int CreateUniqueId() {
  return DateTime.now().millisecondsSinceEpoch.remainder(100000);
}