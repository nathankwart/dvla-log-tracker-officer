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
      // Handle generic errors with better messages
      final errorString = e.toString().toLowerCase();
      if (errorString.contains('network') || errorString.contains('socket')) {
        throw 'Network connection failed. Please check your internet connection and try again.';
      } else if (errorString.contains('timeout')) {
        throw 'Request timed out. Please check your connection and try again.';
      } else if (errorString.contains('recaptcha') || errorString.contains('captcha')) {
        throw 'Authentication service error. Please try again in a moment.';
      } else if (errorString.contains('permission') || errorString.contains('unauthorized')) {
        throw 'Authentication failed. Please check your credentials and try again.';
      }
      throw 'Unable to sign in. Please check your email and password, then try again.';
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
        return 'No account found with this email address. Please check your email or create a new account.';
      case 'wrong-password':
        return 'Incorrect password. Please check your password and try again.';
      case 'invalid-email':
        return 'Invalid email address. Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact your administrator.';
      case 'too-many-requests':
        return 'Too many failed login attempts. Please wait a few minutes and try again.';
      case 'network-request-failed':
        return 'Network connection failed. Please check your internet connection and try again.';
      case 'email-already-in-use':
        return 'An account with this email already exists. Please use a different email or sign in instead.';
      case 'weak-password':
        return 'Password is too weak. Please use a stronger password (at least 6 characters).';
      case 'operation-not-allowed':
        return 'Email/password authentication is not enabled. Please contact support.';
      case 'invalid-credential':
        return 'Invalid email or password. Please check your credentials and try again.';
      case 'user-mismatch':
        return 'The provided credentials do not match an existing user.';
      case 'requires-recent-login':
        return 'This operation requires recent authentication. Please sign out and sign in again.';
      default:
        // Check error message for common issues
        final message = e.message?.toLowerCase() ?? '';
        if (message.contains('network') || message.contains('connection')) {
          return 'Network error. Please check your internet connection and try again.';
        } else if (message.contains('timeout')) {
          return 'Request timed out. Please try again.';
        } else if (message.contains('recaptcha') || message.contains('captcha')) {
          return 'Authentication service temporarily unavailable. Please try again in a moment.';
        }
        return 'Login failed: ${e.message ?? 'Please check your credentials and try again.'}';
    }
  }
}