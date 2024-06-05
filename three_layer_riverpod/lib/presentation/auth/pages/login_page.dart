import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/common.dart';
import '../../../domain/domain.dart';
import '../state/login_state.dart';

// UI component
class LoginPage extends ConsumerWidget with EmailPasswordValidators {
  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final userNameTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginStateProvider);

    // listen to the changes in the state
    ref.listen(loginStateProvider, (prev, next) {
      if (next.hasValue) {
        if (next.value!) {
          AppRouter.go(context, RouterNames.feedsPage);
        }
      }

      if (next.hasError) {
        final error = next.error;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: error is AppException
                ? Text(error.message)
                : const Text('An error occurred'),
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: loginState.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: userNameTextController,
                        validator: validateEmail,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                        ),
                      ),
                      TextFormField(
                        controller: passwordTextController,
                        validator: validatePassword,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ref
                                .read(loginStateProvider.notifier)
                                .loginWithEmailAndPassword(
                                  email: userNameTextController.text,
                                  password: passwordTextController.text,
                                );
                          }
                        },
                        child: const Text('Login'),
                      ),
                      TextButton(
                        onPressed: () {
                          AppRouter.go(context, RouterNames.forgotPasswordPage);
                        },
                        child: const Text('Forgot Password'),
                      ),
                      TextButton(
                        onPressed: () {
                          AppRouter.go(context, RouterNames.registerPage);
                        },
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
