// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:code_todo/app/core/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:code_todo/app/core/constants.dart';

import 'pods/registration_pods.dart';

class RegistrationPage extends ConsumerStatefulWidget {
  const RegistrationPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RegistrationPageState();
}

class _RegistrationPageState extends ConsumerState<RegistrationPage> {
  bool validPasswords = false;
  final confirmPasswordEC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final userLoginNotifier = ref.watch(userLoginProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro'),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(kDefaultMargin),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: const BoxDecoration(shape: BoxShape.circle),
              ),
              const SizedBox(height: kDefaultMargin),
              TextFormField(
                onChanged: (value) => userLoginNotifier.update((state) {
                  return state.copyWith(name: value);
                }),
                decoration: const InputDecoration(
                  labelText: 'Nome',
                ),
              ),
              const SizedBox(height: kDefaultMargin),
              TextFormField(
                onChanged: (value) => userLoginNotifier.update((state) {
                  return state.copyWith(password: value);
                }),
                decoration: const InputDecoration(
                  labelText: 'Senha',
                ),
              ),
              const SizedBox(height: kDefaultMargin),
              TextFormField(
                controller: confirmPasswordEC,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (userLoginNotifier.state.password != value) {
                    Future.microtask(() => setState(() {
                          validPasswords = false;
                        }));
                    return 'As senhas estão diferentes';
                  }
                  Future.microtask(() => setState(() {
                        validPasswords = true;
                      }));

                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Confirmar Senha',
                ),
              ),
              const SizedBox(height: kDefaultMarginLarge),
              ElevatedButton(
                onPressed: userLoginNotifier.state.name != null &&
                        userLoginNotifier.state.password != null &&
                        validPasswords
                    ? () => _confirmationMethod(
                          userLoginNotifier.state,
                          confirmPasswordEC.text,
                          ref,
                        )
                    : null,
                child: const Text('Concluir'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmationMethod(
    UserModel user,
    String confirmation,
    WidgetRef ref,
  ) async {
    //TODO - post to backend
    final database = ref.watch(databaseProvider);
    await database.setBool(Keys.hasLoggin.name, true);

    //Mock
    await database.setString(Keys.mockUserName.name, user.name!);
    await database.setString(Keys.mockUserPassword.name, user.password!);

    final users = database.getStringList(Keys.mockUserList.name) ?? [];
    users.add(user.toJson());
    await database.setStringList(Keys.mockUserList.name, users);

    navigatorKey.currentState?.pushReplacementNamed(Kpages.login.route);
    return;
  }
}
