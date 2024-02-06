import 'package:code_todo/app/core/constants.dart';
import 'package:code_todo/app/core/models/user_model.dart';
import 'package:code_todo/app/pages/registration/pods/registration_pods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<ConsumerStatefulWidget> {
  bool enableLoginButton = false;
  bool showLoginError = false;

  @override
  Widget build(BuildContext context) {
    final userLoginNotifier = ref.watch(userLoginProvider.notifier);
    final userLogin = ref.watch(userLoginProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: SizedBox(
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(kDefaultMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                decoration: const InputDecoration(label: Text("Nome")),
                onChanged: (value) => userLoginNotifier.update((state) {
                  // _handleLoginButtonState(state);
                  return state.copyWith(name: value);
                }),
              ),
              const SizedBox(height: kDefaultMarginLarge),
              TextFormField(
                decoration: const InputDecoration(label: Text("Senha")),
                onChanged: (value) => userLoginNotifier.update((state) {
                  // _handleLoginButtonState(state);
                  return state.copyWith(password: value);
                }),
              ),
              const SizedBox(height: kDefaultMarginSmall),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                InkWell(
                    child: Text(
                      "Ainda não tenho uma conta",
                      style: TextStyle(
                        color: Theme.of(context).highlightColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    onTap: () {
                      kNavigatorKey.currentState
                          ?.pushReplacementNamed(Kpages.registration.route);
                    }),
              ]),
              const SizedBox(height: kDefaultMarginLarge),
              ElevatedButton(
                  onPressed: (userLogin.name ?? '').isNotEmpty &&
                          (userLogin.password ?? '').isNotEmpty
                      ? () => _confirmLoginMethod(userLoginNotifier.state, ref)
                      : null,
                  child: const Text("Entrar")),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmLoginMethod(UserModel user, WidgetRef ref) async {
    // TODO - get to backend
    try {
      final database = ref.watch(databaseProvider);

      final usersJsonString = database.getStringList(
            Keys.mockUserList.name,
          ) ??
          [];
      final users =
          usersJsonString.map((usr) => UserModel.fromJson(usr)).toList();

      users.firstWhere(
        (e) => e.name == user.name && e.password == user.password,
        orElse: () => throw Exception('not found'),
      );

      await database.setBool(Keys.hasLoggin.name, true);

      kNavigatorKey.currentState?.pushReplacementNamed(Kpages.home.route);
    } catch (e) {
      debugPrint('[_confirmLoginMethod]>> error on $e');
      const snackBar = SnackBar(
        content: Text("Nome e/ou senha estão incorretos"),
      );

      kSnackBarKey.currentState?.showSnackBar(snackBar);
    }
  }
}
