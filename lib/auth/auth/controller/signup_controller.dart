import 'package:s_medi/general/consts/consts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class SignupController extends GetxController {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var categoryController = TextEditingController();
  var timeController = TextEditingController();
  var aboutController = TextEditingController();
  var addressController = TextEditingController();
  var serviceController = TextEditingController();
  UserCredential? userCredential;
  var isLoading = false.obs;
  RxString selectedRole = 'user'.obs;
  RxString selectedCategory = 'Body'.obs;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  void setRole(String? role) {
    if (role == null) return;
    selectedRole.value = role;
  }

  void showDropdownMenu(BuildContext context) {
    final List<PopupMenuEntry<String>> items = [
      const PopupMenuItem(value: 'Body', child: Text('Body')),
      const PopupMenuItem(value: 'Ear', child: Text('Ear')),
      const PopupMenuItem(value: 'Liver', child: Text('Liver')),
      const PopupMenuItem(value: 'Lungs', child: Text('Lungs')),
      const PopupMenuItem(value: 'Heart', child: Text('Heart')),
      const PopupMenuItem(value: 'Kidny', child: Text('Kidny')),
      const PopupMenuItem(value: 'Eye', child: Text('Eye')),
      const PopupMenuItem(value: 'Stomac', child: Text('Stomac')),
      const PopupMenuItem(value: 'Tooth', child: Text('Tooth')),
    ];

    showMenu(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(
          Offset.zero,
          Offset.zero,
        ),
        Offset.zero & MediaQuery.of(context).size,
      ),
      items: items,
    ).then((value) {
      if (value != null) {
        selectedCategory.value = value;
        categoryController.text = value;
      }
    });
  }

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
          if (selectedRole.value == 'doctor') {
            var doctorStore = FirebaseFirestore.instance
                .collection('doctors')
                .doc(userCredential!.user!.uid);
            await doctorStore.set({
              'docId': userCredential!.user!.uid,
              'docName': nameController.text,
              'docPassword': passwordController.text,
              'docEmail': emailController.text,
              'docAbout': aboutController.text,
              'docAddress': addressController.text,
              'docCategory': categoryController.text,
              'docPhone': phoneController.text,
              'docRating': '0',
              'docService': serviceController.text,
              'docTimeing': timeController.text,
              'deviceToken': "",
              'status': "approved",
              'role': "doctor",
            });
          } else {
            var userStore = FirebaseFirestore.instance
                .collection('users')
                .doc(userCredential!.user!.uid);
            await userStore.set({
              'uid': userCredential!.user!.uid,
              'fullname': nameController.text,
              'password': passwordController.text,
              'email': emailController.text,
              'deviceToken': '',
              'role': 'user',
            });
          }

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('currentUserType', selectedRole.value);
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('currentUserType');
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

  String? validfield(value) {
    if (value!.isEmpty) {
      return 'please fil this document';
    }
    RegExp emailRefExp = RegExp(r'^.{2,}$');
    if (!emailRefExp.hasMatch(value)) {
      return 'please fil this document';
    }
    return null;
  }
}
