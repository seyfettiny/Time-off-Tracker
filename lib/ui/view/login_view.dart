import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:timeofftracker/ui/view/signup_view.dart';
import 'package:timeofftracker/ui/widgets/custom_button.dart';
import 'package:timeofftracker/ui/widgets/custom_textfield.dart';
import 'package:timeofftracker/ui/widgets/google_signin_button.dart';
import 'package:timeofftracker/viewmodel/loginview_viewmodel.dart';

import 'home_view.dart';

class LoginView extends HookConsumerWidget {
  const LoginView({super.key});

  static const routeName = '/loginView';

  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final loginViewViewModel = ref.watch(loginViewVMProvider.notifier);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        resizeToAvoidBottomInset: false,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Logo and title
                SizedBox.square(
                  dimension: MediaQuery.of(context).size.width * 0.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        'assets/images/logo_icon.png',
                        scale: 3,
                      ),
                      Image.asset(
                        'assets/images/logo_pepteam.png',
                        scale: 3,
                      ),
                      const Text(
                        'İzin Portalı',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
                // Login form
                SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Container(
                      height: 400,
                      margin: const EdgeInsets.symmetric(vertical: 44),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextField(
                            title: 'Email',
                            hintText: 'Email girin',
                            controller: emailController,
                          ),
                          CustomTextField(
                            title: 'Şifre',
                            hintText: '••••••••',
                            obscureText: true,
                            controller: passwordController,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Şifremi unuttum',
                                style: TextStyle(
                                  fontSize: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .fontSize,
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: CustomButton(
                              title: 'Giriş Yap',
                              isLoading: loginViewViewModel.isLoading,
                              onPressed: () {
                                loginViewViewModel
                                    .signInWithEmail(
                                  emailController.text,
                                  passwordController.text,
                                )
                                    .then((value) {
                                  context.go(HomeView.routeName);
                                });
                              },
                            ),
                          ),
                          GoogleSignInWidget(
                            title: 'Google ile giriş yap',
                            onPressed: () {
                              loginViewViewModel
                                  .signInWithGoogle()
                                  .then((value) {
                                context.go(HomeView.routeName);
                              });
                            },
                          ),
                          GestureDetector(
                            onTap: () {
                              FocusManager.instance.primaryFocus!.unfocus();
                              context.push(SignupView.routeName);
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(top: 32.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Hesabınız yok mu? ',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    'Kaydol',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
