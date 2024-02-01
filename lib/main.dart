import 'package:code_todo/app/core/app_widget.dart';
import 'package:code_todo/app/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

//3.16.9

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

void main() async {
  runApp(const LoadingPage());
  final prefs = await SharedPreferences.getInstance();
  return runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(prefs),
      ],
      child: const App(),
    ),
  );
}
