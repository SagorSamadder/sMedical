import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController extends GetxController {
  @override
  void onInit() {
    getData = getUserData();
    super.onInit();
  }

  var isLoading = false.obs;
  var currentUser = FirebaseAuth.instance.currentUser;
  var username = ''.obs;
  var email = ''.obs;
  var profileImageUrl = ''.obs;
  Future? getData;

  final ImagePicker _picker = ImagePicker();

  getUserData() async {
    isLoading(true);
    DocumentSnapshot<Map<String, dynamic>> user = await FirebaseFirestore
        .instance
        .collection('doctors')
        .doc(currentUser!.uid)
        .get();
    var userData = user.data();
    username.value = userData!['fullname'] ?? "";
    email.value = currentUser!.email ?? "";
    profileImageUrl.value = userData['image'] ?? "";
    isLoading(false);
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      await uploadImage(imageFile);
    }
  }

  Future<void> uploadImage(File image) async {
    isLoading(true);
    try {
      // Upload the image to Firebase Storage
      String fileName = 'profile_images/${currentUser!.uid}.jpg';
      UploadTask uploadTask =
          FirebaseStorage.instance.ref(fileName).putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // Update the user document with the new image URL
      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(currentUser!.uid)
          .update({'image': downloadUrl});

      profileImageUrl.value =
          downloadUrl; // Update local variable with new image URL
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload image: $e');
    } finally {
      isLoading(false);
    }
  }
}
