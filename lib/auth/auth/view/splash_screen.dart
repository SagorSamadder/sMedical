import 'package:s_medi/doctor/home/view/doctor_home.dart';
import 'package:s_medi/general/consts/consts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:s_medi/users/home/view/home.dart';

import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _goNext();
  }

  Future<String> _resolveUserType(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final savedType = prefs.getString('currentUserType');
    if (savedType == 'doctor' || savedType == 'user') {
      return savedType!;
    }

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    if (userDoc.exists && userDoc['role'] == 'user') {
      await prefs.setString('currentUserType', 'user');
      return 'user';
    }

    final doctorDoc =
        await FirebaseFirestore.instance.collection('doctors').doc(uid).get();
    if (doctorDoc.exists && doctorDoc['role'] == 'doctor') {
      await prefs.setString('currentUserType', 'doctor');
      return 'doctor';
    }

    return 'user';
  }

  Future<void> _goNext() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('currentUserType');
      if (!mounted) return;
      Get.offAll(() => const LoginView());
      return;
    }

    final userType = await _resolveUserType(user.uid);
    if (!mounted) return;

    if (userType == 'doctor') {
      Get.offAll(() => const DoctorHome());
    } else {
      Get.offAll(() => const Home());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                "assets/icon.png",
                width: context.screenWidth * .45,
              ),
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 18),
                child: Text(
                  'Build by Sagor Samadder',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
