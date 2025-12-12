import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/print_debug.dart';

late SharedPreferences sharedStorage;
late SharedPref sharedPref;

class SharedPref {
  static const String _notificationPreferencePrefix = 'notification_preference';

  final String suffix;

  SharedPref(this.suffix);

  static Future<void> init(String suffix) async {
    try {
      sharedPref = SharedPref(suffix);
      sharedStorage = await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  /// use in logout
  Future<void> clear() async {
    await sharedStorage.clear();
  }

  /// Save notification preference for a specific topic
  Future<void> saveNotificationPreference(String topic, bool enabled) async {
    try {
      final key = '${_notificationPreferencePrefix}_$topic';
      printDebug('SHARED_PREF: Saving notification preference for topic $topic: $enabled with key: $key');
      await sharedStorage.setBool(key, enabled);
      printDebug('SHARED_PREF: Successfully saved notification preference for topic $topic');
    } catch (e, trace) {
      printDebug('SHARED_PREF: Error saving notification preference for topic $topic: $e');
      printDebug('SHARED_PREF: Stack trace: $trace');
    }
  }

  /// Get notification preference for a specific topic
  bool getNotificationPreference(String topic, {bool defaultValue = true}) {
    final key = '${_notificationPreferencePrefix}_$topic';
    printDebug('SHARED_PREF: Getting notification preference for topic $topic with key: $key');
    final enabled = sharedStorage.getBool(key);
    final result = enabled ?? defaultValue;
    printDebug('SHARED_PREF: Notification preference for topic $topic: $result');
    return result;
  }
}
