import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'constants.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final database = ref.watch(databaseProvider);
    final hasLoggin = database.getBool(Keys.hasLoggin.name) ?? false;

    return MaterialApp(
      routes: routes,
      debugShowCheckedModeBanner: false,
      navigatorKey: kNavigatorKey,
      scaffoldMessengerKey: kSnackBarKey,
      theme: ThemeData(
        highlightColor: Colors.deepOrangeAccent,
        primarySwatch: Colors.deepPurple,
        useMaterial3: false,
      ),
      initialRoute: hasLoggin ? Kpages.home.route : Kpages.registration.route,
    );
  }
}
