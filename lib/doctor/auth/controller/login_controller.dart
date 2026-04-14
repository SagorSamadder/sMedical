import 'package:s_medi/general/consts/consts.dart';

import '../../home/view/doctor_home.dart';

class LoginController extends GetxController {
  UserCredential? userCredential;
  var isLoading = false.obs;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  loginUser(context) async {
    if (formkey.currentState!.validate()) {
      try {
        isLoading(true);
        userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);

        // Check if the UID exists in the 'doctors' collection
        if (userCredential != null) {
          String currentUserId = FirebaseAuth.instance.currentUser!.uid;
          DocumentSnapshot userDoc = await FirebaseFirestore.instance
              .collection('doctors')
              .doc(currentUserId)
              .get();

          if (!userDoc.exists) {
            isLoading(false);
            Get.snackbar("Login failed", "No doctor account found.",
                snackPosition: SnackPosition.TOP);
            return;
          }

          // Check the user's role
          if (userDoc['role'] == 'doctor') {
            isLoading(false);
            Get.snackbar("Success", "Login Successful",
                snackPosition: SnackPosition.TOP);
            Get.offAll(() => const DoctorHome());
          } else {
            isLoading(false);
            Get.snackbar("Login failed", "You are not a doctor",
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
      return 'please enter an email';
    }
    RegExp emailRefExp = RegExp(r'^[\w\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRefExp.hasMatch(value)) {
      return 'please enter a valid email';
    }
    return null;
  }

  String? validpass(value) {
    if (value!.isEmpty) {
      return 'please enter a password';
    }
    RegExp passRefExp = RegExp(r'^.{8,}$');
    if (!passRefExp.hasMatch(value)) {
      return 'Password Must Contain At Least 8 Characters';
    }
    return null;
  }
}
