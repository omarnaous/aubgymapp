import 'package:aub_gymsystem/Pages/intro_page.dart';
import 'package:aub_gymsystem/Pages/main_page.dart';
import 'package:aub_gymsystem/Pages/verification_page.dart';
import 'package:aub_gymsystem/constants.dart';
import 'package:aub_gymsystem/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: ConstantsClass.themeColor,
        ),
        useMaterial3: true,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data?.emailVerified == false &&
                snapshot.data?.email != 'aubadmin@gmail.com') {
              return const VerificationPage();
            }

            // User is signed in and email is verified, navigate to the main page
            return const MainPage();
          } else {
            // User is not signed in or email is not verified, show the intro page
            return const IntroPage();
          }
        },
      ),
    );
  }
}
