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
                  _handleLoginButtonState(state);
                  return state.copyWith(name: value);
                }),
              ),
              const SizedBox(
                height: kDefaultMarginLarge,
              ),
              TextFormField(
                decoration: const InputDecoration(label: Text("Senha")),
                onChanged: (value) => userLoginNotifier.update((state) {
                  _handleLoginButtonState(state);
                  return state.copyWith(password: value);
                }),
              ),
              const SizedBox(
                height: kDefaultMarginSmall,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                GestureDetector(
                    child: const Text(
                      "Ainda não tenho uma conta",
                      style: TextStyle(
                          color: Colors.blueAccent,
                          decoration: TextDecoration.underline),
                    ),
                    onTap: () {
                      navigatorKey.currentState
                          ?.pushReplacementNamed(Kpages.registration.route);
                    }),
              ]),
              const SizedBox(
                height: kDefaultMarginLarge,
              ),
              ElevatedButton(
                  onPressed: enableLoginButton
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
    final database = ref.watch(databaseProvider);

    final usersJsonString =
        database.getStringList(Keys.mockUserList.name) ?? [];
    final users = usersJsonString.map((usr) => UserModel.fromJson(usr));

    for (var usr in users) {
      if (usr.name == user.name && usr.password == user.password) {
        await database.setBool(Keys.hasLoggin.name, true);
        navigatorKey.currentState?.pushReplacementNamed(Kpages.home.route);
        return;
      }
    }

    const snackBar = SnackBar(
      content: Text("Nome e/ou senha estão incorretos"),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _handleLoginButtonState(UserModel user) {
    setState(() {
      enableLoginButton = user.name != null && user.password != null;
    });
  }
}
