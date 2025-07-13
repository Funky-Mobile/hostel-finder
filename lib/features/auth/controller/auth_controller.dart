import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hostel_finder/core/app_routes.dart';
import 'package:hostel_finder/core/naviagtor/app_navigator.dart';


class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxBool isLoading = false.obs;


  Future<void> signup({
    required BuildContext context,
    required String fullName,
    required String email,
    required String password,
  }) async {
    isLoading.value = true;

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user?.updateDisplayName(fullName);

      final user = credential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'fullName': fullName,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      if (context.mounted) {
        AppNavigator.popAllUntil(context, AppRoutes.homeScreen);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // Optionally get the existing user
        final user = _auth.currentUser;

        if (context.mounted) {
          AppNavigator.popAllUntil(context, AppRoutes.homeScreen);
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? "Signup failed")),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    isLoading.value = true;

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      if (context.mounted) {
        AppNavigator.popAllUntil(context, AppRoutes.homeScreen);
      }
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        String message = switch (e.code) {
          'user-not-found' => 'No user found for that email.',
          'wrong-password' => 'Incorrect password.',
          _ => e.message ?? 'Login failed'
        };
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unexpected error: $e")),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> loginWithGoogle(BuildContext context) async {
    isLoading.value = true;

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        isLoading.value = false;
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();

        // Save user info to Firestore if new
        if (!userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'fullName': user.displayName ?? '',
            'email': user.email ?? '',
            'createdAt': FieldValue.serverTimestamp(),
          });
        }

        if (context.mounted) {
          AppNavigator.popAllUntil(context, AppRoutes.homeScreen);
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'Google login failed';

      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage = 'An account already exists with a different credential';
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid credentials. Please try again';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Google sign-in is not enabled';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled';
          break;
        case 'user-not-found':
          errorMessage = 'No user found for this account';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided';
          break;
        case 'invalid-verification-code':
          errorMessage = 'Invalid verification code';
          break;
        case 'invalid-verification-id':
          errorMessage = 'Invalid verification ID';
          break;
        default:
          errorMessage = e.message ?? 'Google login failed';
      }

      print('FirebaseAuthException: ${e.code} - ${e.message}');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } on PlatformException catch (e) {
      print('PlatformException: ${e.code} - ${e.message}');

      String errorMessage = 'Platform error occurred';

      switch (e.code) {
        case 'sign_in_failed':
          errorMessage = 'Google sign-in failed. Please try again';
          break;
        case 'network_error':
          errorMessage = 'Network error. Please check your connection';
          break;
        case 'sign_in_canceled':
          errorMessage = 'Sign-in was canceled';
          break;
        default:
          errorMessage = e.message ?? 'Platform error occurred';
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } catch (e) {
      print('General Exception: $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unexpected error: $e")),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }}