import 'package:s_medi/general/consts/consts.dart';
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
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  RxString selectedValue = "Body".obs;

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
        selectedValue.value = value;
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
          var store = FirebaseFirestore.instance
              .collection('doctors')
              .doc(userCredential!.user!.uid);
          await store.set({
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
          VxToast.show(context, msg: "Signup Sucessfull");
        }
        isLoading(false);
      } catch (e) {
        isLoading(false);
        // Check the type of exception and show a toast accordingly
        if (e is FirebaseAuthException) {
          if (e.code == 'email-already-in-use') {
            // The email address is already in use by another account
            VxToast.show(context, msg: "Allready have an account");
          } else {
            // Handle other FirebaseAuth exceptions
            VxToast.show(context, msg: "No internet connection");
          }
        } else {
          // Handle other exceptions (not related to FirebaseAuth)
          VxToast.show(context, msg: "Try after some time ");
        }
        log("$e");
      }
    }
  }

  storeUserData(
      String uid, String fullname, String email, String password) async {
    var store = FirebaseFirestore.instance.collection('users').doc(uid);
    await store.set({
      'uid': uid,
      'fullname': fullname,
      'password': email,
      'email': password,
    });
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
