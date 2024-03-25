import 'package:aub_gymsystem/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  bool _isVerified = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Email Verification'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _isVerified
                    ? 'Email Verified!'
                    : 'Email verification sent to ${FirebaseAuth.instance.currentUser?.email}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  // Reload the user to check if the email is verified
                  await FirebaseAuth.instance.currentUser?.reload();
                  setState(() {
                    _isVerified =
                        FirebaseAuth.instance.currentUser?.emailVerified ??
                            false;
                  });

                  if (!_isVerified) {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Email is not verified!'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  } else {
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                    // ignore: use_build_context_synchronously
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const MyApp();
                    }));
                  }
                },
                child: const Text('Continue'),
              ),
              const SizedBox(height: 10),
              if (!_isVerified)
                TextButton(
                  onPressed: () {
                    FirebaseAuth.instance.currentUser?.sendEmailVerification();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Verification email sent!'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  },
                  child: const Text('Send Another Verification Email'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
