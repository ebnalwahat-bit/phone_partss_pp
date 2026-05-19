import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class LocalizationService {
  static const Locale arabic = Locale('ar');
  static const Locale english = Locale('en');
  static const Locale french = Locale('fr');
  static const Locale spanish = Locale('es');
  static const Locale german = Locale('de');
  static const Locale russian = Locale('ru');
  static const Locale chinese = Locale('zh');
  static const Locale persian = Locale('fa');

  static const List<Locale> supportedLocales = [
    arabic,
    english,
    french,
    spanish,
    german,
    russian,
    chinese,
    persian,
  ];

  static const LocalizationsDelegate<MyLocalizations> delegate =
      _MyLocalizationsDelegate();

  static final List<LocalizationsDelegate<dynamic>>
      localizationsDelegates = [
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  static Future<Map<String, String>> loadTranslations(
    String localeCode,
  ) async {
    final String jsonString =
        await rootBundle.loadString(
      'assets/l10n/$localeCode.json',
    );

    final Map<String, dynamic> map =
        json.decode(jsonString);

    return map.map(
      (key, value) => MapEntry(
        key,
        value.toString(),
      ),
    );
  }
}

class _MyLocalizationsDelegate
    extends LocalizationsDelegate<MyLocalizations> {
  const _MyLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return LocalizationService.supportedLocales.any(
      (supportedLocale) =>
          supportedLocale.languageCode ==
          locale.languageCode,
    );
  }

  @override
  Future<MyLocalizations> load(
    Locale locale,
  ) async {
    final translations =
        await LocalizationService.loadTranslations(
      locale.languageCode,
    );

    return MyLocalizations(translations);
  }

  @override
  bool shouldReload(
    covariant LocalizationsDelegate<MyLocalizations> old,
  ) {
    return false;
  }
}

class MyLocalizations {
  final Map<String, String> _translations;

  MyLocalizations(this._translations);

  String translate(String key) {
    return _translations[key] ?? key;
  }
}

extension Translate on BuildContext {
  String tr(String key) {
    final localization =
        Localizations.of<MyLocalizations>(
      this,
      MyLocalizations,
    );

    return localization?.translate(key) ?? key;
  }
}
