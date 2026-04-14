import 'package:s_medi/general/consts/consts.dart';
import 'dart:developer';

class SignupController extends GetxController {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  UserCredential? userCredential;
  var isLoading = false.obs;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  signupUser(context) async {
    if (formkey.currentState!.validate()) {
      try {
        isLoading(true);
        userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        if (userCredential != null) {
          var store = FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential!.user!.uid);
          await store.set({
            'uid': userCredential!.user!.uid,
            'fullname': nameController.text,
            'password': passwordController.text,
            'email': emailController.text,
            'deviceToken': '',
            'role': 'user',
          });
          VxToast.show(context, msg: "Signup Sucessfull");
        }
        isLoading(false);
      } catch (e) {
        isLoading(false);
        if (e is FirebaseAuthException) {
          if (e.code == 'email-already-in-use') {
            VxToast.show(context, msg: "Allready have an account");
          } else {
            VxToast.show(context, msg: "No internet connection");
          }
        } else {
          VxToast.show(context, msg: "Try after some time ");
        }
        log("$e");
      }
    }
  }

  signout() async {
    await FirebaseAuth.instance.signOut();
  }

  //vlidateemail
  String? validateemail(value) {
    if (value!.isEmpty) {
      return 'please enter an email';
    }
    RegExp emailRefExp = RegExp(r'^[\w\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRefExp.hasMatch(value)) {
      return 'please enter a valied email';
    }
    return null;
  }

  //validate pass
  String? validpass(value) {
    if (value!.isEmpty) {
      return 'Please enter a password';
    }
    // Check for at least one capital letter
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one capital letter';
    }
    // Check for at least one number
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number';
    }
    // Check for at least one special character
    if (!value.contains(RegExp(r'[!@#\$&*~]'))) {
      return 'Password must contain at least one special character (!@#\$&*~)';
    }
    // Check for overall pattern
    RegExp passwordRegExp =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (!passwordRegExp.hasMatch(value)) {
      return 'Your Password Must Contain At Least 8 Characters';
    }

    return null;
  }

  //validate name
  String? validname(value) {
    if (value!.isEmpty) {
      return 'please enter a password';
    }
    RegExp emailRefExp = RegExp(r'^.{5,}$');
    if (!emailRefExp.hasMatch(value)) {
      return 'Password enter a valid name';
    }
    return null;
  }
}
