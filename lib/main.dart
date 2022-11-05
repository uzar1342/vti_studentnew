import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vti_student/configs/shared_prefs_keys.dart';
import 'package:vti_student/home/profile/feedback_page.dart';
import 'package:vti_student/home/video_lectures/single_video.dart';

import 'package:vti_student/initialScreens/splash_page.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   // runZonedGuarded(() {
//   //   runApp(MyApp());
//   // }, FirebaseCrashlytics.instance.recordError);
//   runZonedGuarded<Future<void>>(() async {
//     WidgetsFlutterBinding.ensureInitialized();
//     await Firebase.initializeApp();
//     // The following lines are the same as previously explained in "Handling uncaught errors"
//     FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

//     runApp(MyApp());
//   }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
// }

void main() async {

  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {



  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VTI Students',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: GoogleFonts.poppins().fontFamily,
        //canvasColor: Colors.transparent,
      ),
      home: const SplashPage(),
    );
  }
}
