import 'dart:math';

import 'package:aub_gymsystem/Logic/firebasehelper_class.dart';
import 'package:aub_gymsystem/Widgets/role_selectionbtns.dart';
import 'package:aub_gymsystem/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController studentIdController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RoundedLoadingButtonController buttonController =
      RoundedLoadingButtonController();

  String selectedRole = 'student'; // Default role is student

  List<String> roles = [
    "Guest",
    "Student",
    "Faculty",
    'Personal Trainer',
    "Class Instructor"
  ];

  int selectedIndex = 0;

  bool isGuest = true; // Track if the user is signing up as a guest

  // Function to generate a random 6-digit ID
  String generateRandomId() {
    Random random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  // Function to sign up user with email and password
  Future<void> signUpWithEmailAndPassword(
      {required String firstName,
      required String lastName,
      required String email,
      required String phoneNumber,
      required String studentId,
      required String password,
      required String role,
      required bool locked}) async {
    try {
      // Create user with email and password
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification
      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }

      FirebaseFirestore.instance.collection('users').doc(user?.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phoneNumber': phoneNumber,
        'studentId': studentId,
        'role': role, // Add role to user data
        'locked': locked
      });
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: ConstantsClass.themeColor,
          content: Text(
            e.message ?? "Unexpected Error Occurred",
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }
  }

  Future<void> signUp() async {
    String firstName = firstNameController.text;
    String lastName = lastNameController.text;
    String email = emailController.text;
    String phoneNumber = phoneNumberController.text;
    String password = passwordController.text;
    String studentId = studentIdController.text;

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        phoneNumber.isEmpty ||
        password.isEmpty ||
        studentId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: ConstantsClass.themeColor,
          content: const Text(
            'Please fill in all fields',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
      );
      buttonController.reset();
    } else {
      try {
        if (isGuest) {
          // Generate random ID for guest sign-ups
          studentIdController.text = generateRandomId();
        }
        await signUpWithEmailAndPassword(
          firstName: firstName,
          lastName: lastName,
          email: email,
          phoneNumber: phoneNumber,
          studentId: studentIdController.text,
          password: password,
          locked: roles[selectedIndex] == "Student" ? false : true,
          role: roles[selectedIndex].toLowerCase(),
        ).whenComplete(() {
          if (roles[selectedIndex] == 'Personal Trainer') {
            FirebaseHelperClass().addTrainer(
              context,
              "$firstName $lastName",
              FirebaseAuth.instance.currentUser!.uid,
            );
          }
        });
        buttonController.success();
        buttonController.reset();
        // ignore: use_build_context_synchronously
        Navigator.of(context).pop();
      } catch (error) {
        buttonController.reset();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                      ),
                    ),
                  ),
                  if (!isGuest)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: studentIdController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText:
                              selectedIndex == 1 ? 'Student ID' : 'Faculty ID',
                        ),
                      ),
                    ),
                  if (isGuest)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Referral Email',
                        ),
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  RoleSelectionButtons(
                    roles: roles,
                    selectedIndex: selectedIndex,
                    onPressed: (index) {
                      setState(() {
                        selectedIndex = index;
                        isGuest = roles[index] == "Guest";
                      });
                    },
                  ),
                  SizedBox(
                    height: height * 0.05,
                  ),
                  RoundedLoadingButton(
                    onPressed: () async {
                      signUp();
                    },
                    controller: buttonController,
                    color: ConstantsClass.themeColor,
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
