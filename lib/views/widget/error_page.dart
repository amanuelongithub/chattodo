import 'package:chattodo_test/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ErrorPage extends StatelessWidget {
  final IconData? icon;
  final String msg;
  final VoidCallback? onPressed;
  const ErrorPage({super.key, this.icon, required this.msg, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Center(
              child: SingleChildScrollView(
                child: Column(mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 120.sp),
                  SizedBox(height: 20.h),
                  Text(msg),
                  SizedBox(height: 60.h),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60.0),
                    child: ElevatedButton(onPressed: onPressed, style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), shadowColor: Colors.transparent, elevation: 0, backgroundColor: AppConstant.kcPrimary,foregroundColor: Colors.white,minimumSize: const Size.fromHeight(50)),child: const Text('Retry')),
                  ),                      
                  ]),
              ));}
}