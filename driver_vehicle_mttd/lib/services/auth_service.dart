import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/app_constants.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreService _firestoreService = FirestoreService();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Check if user is authenticated
  bool get isAuthenticated => _auth.currentUser != null;

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      // Save auth state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.authStateKey, true);
      await prefs.setString(AppConstants.userIdKey, userCredential.user!.uid);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(AppConstants.authStateKey);
      await prefs.remove(AppConstants.userIdKey);
    } catch (e) {
      throw 'Error signing out. Please try again.';
    }
  }

  // Get current user ID
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Register new officer
  Future<UserCredential> registerOfficer({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String stationNumber,
  }) async {
    UserCredential? userCredential;
    
    try {
      // Create Firebase Auth user first (this authenticates the user)
      // Password is automatically hashed by Firebase
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      // Now check if station number already exists (user is now authenticated)
      final stationExists = await _firestoreService.stationNumberExists(stationNumber);
      if (stationExists) {
        // Rollback: Delete the auth user if station number is duplicate
        if (userCredential.user != null) {
          await userCredential.user!.delete();
        }
        throw 'Station number already exists. Please use a different station number.';
      }

      // Create officer profile in Firestore
      await _firestoreService.createOfficerProfile(
        userId: userCredential.user!.uid,
        email: email.trim(),
        firstName: firstName.trim(),
        lastName: lastName.trim(),
        stationNumber: stationNumber.trim(),
      );

      // Save auth state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConstants.authStateKey, true);
      await prefs.setString(AppConstants.userIdKey, userCredential.user!.uid);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      // If auth user was created but something failed, try to clean up
      if (userCredential?.user != null && e.code != 'email-already-in-use') {
        try {
          await userCredential!.user!.delete();
        } catch (_) {
          // Ignore cleanup errors
        }
      }
      throw _handleAuthException(e);
    } catch (e) {
      // If auth user was created but something failed, try to clean up
      if (userCredential?.user != null) {
        try {
          await userCredential!.user!.delete();
        } catch (_) {
          // Ignore cleanup errors
        }
      }
      if (e.toString().contains('Station number')) {
        rethrow;
      }
      throw 'Registration failed: ${e.toString()}';
    }
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No officer found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many failed attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'Password is too weak. Please use a stronger password.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}