import 'dart:typed_data';

import 'package:chattodo_test/constants.dart';
import 'package:chattodo_test/views/auth/login_page.dart';
import 'package:chattodo_test/views/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  static String route = 'signup-page';

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? username;
  String? email;
  String? pwd;
  bool isSaved = false;
  Uint8List? file;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<AuthController>(builder: (auth) {
        if (auth.isLoading) {
          return Center(
              child: CircularProgressIndicator(color: AppConstant.kcPrimary));
        }
        //  else if (auth.isError) {
        //   return ErrorPage(msg: auth.errorMsg ?? 'Someting went wrong',icon:Icons.error_outline_outlined,onPressed: (){
        //     auth.resetData();
        //     Navigator.pushNamedAndRemoveUntil(context,LoginPage.route, (route) => false);
        //   });
        // } 
        else {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                final pickedImage = await pickImage();
                                setState(() => file = pickedImage!);
                              },
                              child: file != null
                                  ? CircleAvatar(
                                      radius: 50,
                                      backgroundImage: MemoryImage(file!),
                                    )
                                  : const CircleAvatar(
                                      radius: 51,
                                      backgroundColor: Colors.grey,
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Colors.white,
                                        child: Icon(
                                          Icons.add_a_photo,
                                          size: 40,
                                          color: Color.fromARGB(
                                              255, 163, 163, 163),
                                        ),
                                      ),
                                    ),
                            ),
                            const SizedBox(height: 40),
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'User name',
                                border: OutlineInputBorder(),
                              ),
                              autofillHints: const [AutofillHints.password],
                              keyboardType: TextInputType.visiblePassword,
                              cursorColor: AppConstant.kcPrimary,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'User name is empty';
                                } else {
                                  setState(() {
                                    username = value;
                                  });
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
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
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 5.h),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(),
                                Text('Forgot password'),
                              ],
                            ),
                            SizedBox(height: 40.h),
                            ElevatedButton(
                                onPressed: () async {
                                  final navigator = Navigator.of(context);
                                  final snack = ScaffoldMessenger.of(context);
                                  _formKey.currentState?.save();
                                  if (_formKey.currentState!.validate()) {
                                    if (file != null) {
                                      await auth.signUp(file!, username!, email!, pwd!);
                                      if(!auth.isError){
                                        
                                        navigator.pushReplacementNamed(HomePage.route);
                                      }else{
                                      snack.showSnackBar(SnackBar(content: Text(auth.errorMsg??'someting want wrong')));
                                      }
                                    } else {
                                      snack.showSnackBar(const SnackBar(content: Text('Please select a profile picture')));
                                    }
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    shadowColor: Colors.transparent,
                                    elevation: 0,
                                    backgroundColor: AppConstant.kcPrimary,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size.fromHeight(50)),
                                child: const Text('Signup')),
                            SizedBox(height: 60.h),
                            GestureDetector(
                                onTap: () => Navigator.pushReplacementNamed(
                                    context, LoginPage.route),
                                child: const Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Colors.blue),
                                )),
                            SizedBox(height: 10.h),
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
          );
        }
      }),
    );
  }
}
