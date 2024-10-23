import 'package:chattodo_test/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;
  String? pwd;
  Map<String, String>? user;
  bool isSaved = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AuthController>(builder: (auth) {
        if (auth.isLoading) {
          return Center(
              child: CircularProgressIndicator(color: AppConstant.kcPrimary));
        } else if (auth.isError) {
          return Center(
              child: Column(
            children: [
              Icon(Icons.error_outline_outlined, size: 120.sp),
              SizedBox(height: 20.h),
              Text(auth.errorMsg ?? 'someting went wrong')
            ],
          ));
        } else {
          return Column(children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
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
                  SizedBox(height: 20.h),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.visibility_off),
                    ),
                    autofillHints: const [AutofillHints.password],
                    keyboardType: TextInputType.visiblePassword,
                    cursorColor: AppConstant.kcPrimary,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is empty';
                      } else {
                        setState(() {
                          pwd = value;
                        });
                        return 'Password is empty';
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
          ]);
        }
      }),
    );
  }
}
