import 'package:s_medi/general/consts/consts.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var userName = '....'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    try {
      isLoading.value = true;
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();

      if (userDoc.exists) {
        userName.value = userDoc.data()?['fullname'] ?? 'user';
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>>
      getDoctorList() async {
    final doctorsSnapshot = await FirebaseFirestore.instance
        .collection('doctors')
        .where('status', isEqualTo: 'approved')
        .get();

    final doctors = doctorsSnapshot.docs;

    // Sort by highest rating first using safe numeric parsing.
    doctors.sort((a, b) {
      final aRating =
          double.tryParse((a.data()['docRating'] ?? '0').toString()) ?? 0;
      final bRating =
          double.tryParse((b.data()['docRating'] ?? '0').toString()) ?? 0;
      return bRating.compareTo(aRating);
    });

    return doctors.take(5).toList();
  }
}
