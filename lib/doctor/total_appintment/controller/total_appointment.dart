import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TotalAppointmentController extends GetxController {
  var userImage = ''.obs; 

  Future<QuerySnapshot<Map<String, dynamic>>> getAppointments() async {
    return FirebaseFirestore.instance
        .collection('appointments')
        .where('appWith', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        .get();
  }

 
}
