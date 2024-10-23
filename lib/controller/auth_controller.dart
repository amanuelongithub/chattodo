import 'package:get/get.dart';

class AuthController extends GetxController {
  final bool isLoading = false;
  final bool isError = false;
  final String? errorMsg = null;

  Future<void> login()async {
   await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: pwd!,
      ); 
  }
}
