import 'package:code_todo/app/pages/registration/registration_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const double kDefaultMargin = 30.0;
const double kDefaultMarginLarge = 45.0;
const double kDefaultMarginSmall = 15.0;
const double kDefaultMarginVerySmall = 5.0;

final databaseProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

enum Keys {
  hasLoggin,
  userName,
  userPassword,
  mockUserPassword,
  mockUserName,
  mockUserList,
}

enum Kpages {
  home,
  registration,
  login;

  const Kpages();
  String get route => '/$name';
}

Map<String, WidgetBuilder> routes = {
  Kpages.home.route: (_) => const Placeholder(),
  Kpages.registration.route: (_) => const RegistrationPage(),
  Kpages.login.route: (_) => const Placeholder(),
};
