import 'package:shared_preferences/shared_preferences.dart';

class WaterTrackerService {
  static const String _dailyIntakeKey = 'daily_water_intake';
  static const String _dailyGoalKey = 'daily_water_goal';
  static const String _lastResetKey = 'last_reset_date';

  static const double defaultDailyGoal = 2000.0; // 2 liters in ml
  static const double glassSize = 250.0; // 250 ml per glass

  static Future<double> getDailyIntake() async {
    final prefs = await SharedPreferences.getInstance();
    final lastReset = prefs.getString(_lastResetKey);
    final today = DateTime.now().toIso8601String().split('T')[0];

    if (lastReset != today) {
      // Reset intake for new day
      await prefs.setDouble(_dailyIntakeKey, 0.0);
      await prefs.setString(_lastResetKey, today);
      return 0.0;
    }

    return prefs.getDouble(_dailyIntakeKey) ?? 0.0;
  }

  static Future<double> getDailyGoal() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_dailyGoalKey) ?? defaultDailyGoal;
  }

  static Future<void> setDailyGoal(double goal) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_dailyGoalKey, goal);
  }

  static Future<void> addWater(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    final current = await getDailyIntake();
    await prefs.setDouble(_dailyIntakeKey, current + amount);
  }

  static Future<void> resetDailyIntake() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_dailyIntakeKey, 0.0);
    await prefs.setString(
      _lastResetKey,
      DateTime.now().toIso8601String().split('T')[0],
    );
  }
}
