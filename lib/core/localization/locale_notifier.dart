import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleNotifier extends ValueNotifier<Locale> {
  static const _prefKey = 'app_locale';

  LocaleNotifier(Locale value) : super(value);

  Future<void> load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final code = prefs.getString(_prefKey);
      if (code != null) value = Locale(code);
    } on PlatformException catch (e) {
      debugPrint('SharedPreferences platform error when loading locale: $e');
    } catch (e) {
      debugPrint('Unexpected error when loading locale: $e');
    }
  }

  Future<void> setLocale(Locale locale) async {
    value = locale;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefKey, locale.languageCode);
    } on PlatformException catch (e) {
      debugPrint('SharedPreferences platform error when saving locale: $e');
    } catch (e) {
      debugPrint('Unexpected error when saving locale: $e');
    }
  }
}

final localeNotifier = LocaleNotifier(const Locale('en'));
