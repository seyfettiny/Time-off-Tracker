import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:timeofftracker/ui/view/home_view.dart';
import 'package:timeofftracker/ui/widgets/custom_button.dart';
import 'package:timeofftracker/ui/widgets/custom_textfield.dart';
import 'package:timeofftracker/ui/widgets/google_signin_button.dart';
import 'package:timeofftracker/viewmodel/signupview_viewmodel.dart';
import 'package:validators/validators.dart';

class SignupView extends HookConsumerWidget {
  const SignupView({super.key});

  static const routeName = '/signupView';
  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signupViewVM = ref.watch(signupViewVMProvider.notifier);
    final nameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 16, bottom: 16),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Kayıt Ol',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                CustomTextField(
                  title: 'Tam adınız',
                  hintText: 'Tam adınızı girin',
                  controller: nameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Lütfen adınızı girin';
                    } else if (!RegExp(r"^[a-zA-ZğüşıöçĞÜŞİÖÇ\s\'-]+$")
                        .hasMatch(value)) {
                      return 'Lütfen geçerli bir ad girin';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  title: 'Email',
                  hintText: 'Email girin',
                  controller: emailController,
                  validator: (value) {
                    if (isNull(value)) {
                      return 'Email boş bırakılamaz';
                    } else if (!isEmail(value!)) {
                      return 'Email formatı yanlış';
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  title: 'Şifre',
                  hintText: 'Şifre oluştur',
                  obscureText: true,
                  controller: passwordController,
                  validator: (value) {
                    if (isNull(value)) {
                      return 'Şifre boş bırakılamaz';
                    } else if (!isLength(value!, 8)) {
                      return 'Şifre en az 8 karakter olmalı';
                    }
                    return null;
                  },
                ),
                Container(
                  padding: const EdgeInsets.only(bottom: 16),
                  alignment: Alignment.centerLeft,
                  child: const Text('Minimum 8 karakter'),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: CustomButton(
                    title: 'Kayıt Ol',
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      signupViewVM
                          .signUpWithEmail(
                        nameController.text,
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
                  title: 'Google ile kayıt ol',
                  onPressed: () {
                    signupViewVM.signUpWithGoogle().then((value) {
                      context.go(HomeView.routeName);
                    });
                  },
                ),
                GestureDetector(
                  onTap: () {
                    FocusManager.instance.primaryFocus!.unfocus();
                    context.pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 32.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Hesabınız var mı? ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          'Giriş Yap',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
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
    );
  }
}
