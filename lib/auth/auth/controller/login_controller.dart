import 'package:s_medi/general/consts/consts.dart';
import 'package:s_medi/users/home/view/home.dart';

class LoginController extends GetxController {
  UserCredential? userCredential;
  var isLoading = false.obs;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  //login if user enters valid email and password
  loginUser(context) async {
    if (formkey.currentState!.validate()) {
      try {
        isLoading(true);
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);

        if (userCredential != null) {
          String currentUserId = FirebaseAuth.instance.currentUser!.uid;
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(currentUserId)
              .get();

          if (!userDoc.exists) {
            isLoading(false);
            Get.snackbar("Login failed", "No user account found.",
                snackPosition: SnackPosition.TOP);
            return;
          }
          if (userDoc['role'] == 'user') {
            isLoading(false);
            Get.snackbar("Success", "Login Successful",
                snackPosition: SnackPosition.TOP);
            Get.offAll(const Home());
          } else {
            isLoading(false);
            Get.snackbar("Login failed", "You are not authorized.",
                snackPosition: SnackPosition.TOP);
          }
        }
      } catch (e) {
        isLoading(false);
        Get.snackbar("Login failed", "Wrong email or password",
            snackPosition: SnackPosition.TOP);
      }
    }
  }

  String? validateemail(value) {
    if (value!.isEmpty) {
      return 'Please enter an email';
    }
    RegExp emailRefExp = RegExp(r'^[\w\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRefExp.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validpass(value) {
    if (value!.isEmpty) {
      return 'Please enter a password';
    }
    RegExp passRefExp = RegExp(r'^.{8,}$');
    if (!passRefExp.hasMatch(value)) {
      return 'Password must contain at least 8 characters';
    }
    return null;
  }
}
