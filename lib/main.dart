import 'package:firebase_core/firebase_core.dart';
import 'package:s_medi/firebase_options.dart';
import 'package:s_medi/general/consts/consts.dart';

import 'auth/auth/view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smadical',
      theme: ThemeData(
        primaryColor: AppColors.primeryColor,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff4B2EAD)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
