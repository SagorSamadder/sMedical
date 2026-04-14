import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../general/service/cloudinary_service.dart';

class ProfileController extends GetxController {
  void _showUploadError(String message) {
    if (Get.overlayContext != null) {
      Get.snackbar('Error', message);
      return;
    }

    final context = Get.context;
    if (context != null) {
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(content: Text(message)),
      );
      return;
    }

    Get.log(message, isError: true);
  }

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
        .collection('users')
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
      debugPrint(
          '[UserProfile] Upload started. uid=${currentUser?.uid} path=${image.path}');
      final downloadUrl = await CloudinaryService.uploadProfileImage(
        imageFile: image,
        userId: currentUser!.uid,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser!.uid)
          .update({'image': downloadUrl});

      profileImageUrl.value = downloadUrl;
      debugPrint('[UserProfile] Upload success. imageUrl=$downloadUrl');
    } catch (e, st) {
      debugPrint('[UserProfile] Upload failed: $e');
      debugPrint('[UserProfile] StackTrace: $st');
      _showUploadError('Failed to upload image: $e');
    } finally {
      isLoading(false);
    }
  }
}
