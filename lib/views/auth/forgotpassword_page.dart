import 'package:chattodo_test/constants.dart';
import 'package:chattodo_test/views/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  static String route = 'forgotpassword-page';

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String? email;
  bool isSaved = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AuthController>(builder: (auth) {
        if (auth.isLoading) {
          return Center(
              child: CircularProgressIndicator(color: AppConstant.kcPrimary));
        } else {
          return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Center(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Email address',
                          border: OutlineInputBorder(),
                        ),
                        cursorColor: AppConstant.kcPrimary,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.username],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email address require';
                          } else if (!RegExp(
                                  r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                              .hasMatch(value)) {
                            return 'Email address not valid';
                          } else {
                            setState(() {
                              email = value;
                            });
                            return null;
                          }
                        },
                      ),
                      SizedBox(height: 40.h),
                      ElevatedButton(
                          onPressed: () async {
                            final navigator = Navigator.of(context);
                            final snack = ScaffoldMessenger.of(context);
                            _formKey.currentState?.save();
                            if (_formKey.currentState!.validate()) {
                              await auth.forgotPassword(email!);
                              if (!auth.isError) {
                                navigator.pushReplacementNamed(LoginPage.route);
                              } else {
                                navigator.pushReplacementNamed(LoginPage.route);
                                snack.showSnackBar(SnackBar(
                                    content: Text(auth.errorMsg ??
                                        'someting want wrong')));
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              shadowColor: Colors.transparent,
                              elevation: 0,
                              backgroundColor: AppConstant.kcPrimary,
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(50)),
                          child: const Text('Send Reset password link')),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
              ),
            ),
          ]);
        }
      }),
    );
  }
}
