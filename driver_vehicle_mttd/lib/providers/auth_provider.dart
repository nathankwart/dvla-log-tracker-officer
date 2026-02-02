import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';
import '../models/officer.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  User? _user;
  Officer? _officer;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  Officer? get officer => _officer;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _init();
  }

  void _init() {
    _user = _authService.currentUser;
    if (_user != null) {
      _fetchOfficerData(_user!.uid);
    }
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      if (user != null) {
        _fetchOfficerData(user.uid);
      } else {
        _officer = null;
        notifyListeners();
      }
    });
  }

  Future<void> _fetchOfficerData(String userId) async {
    try {
      _officer = await _firestoreService.getOfficerById(userId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching officer data: $e');
      // Don't set error message here to avoid disrupting auth flow
    }
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userCredential = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      if (_user != null) {
        await _fetchOfficerData(_user!.uid);
      }
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      // Extract clean error message (remove "Exception: " prefix if present)
      String errorMsg = e.toString();
      if (errorMsg.startsWith('Exception: ')) {
        errorMsg = errorMsg.substring(11);
      } else if (errorMsg.startsWith('FirebaseAuthException: ')) {
        errorMsg = errorMsg.substring(24);
      }
      _errorMessage = errorMsg;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String stationNumber,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final userCredential = await _authService.registerOfficer(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        stationNumber: stationNumber,
      );
      _user = userCredential.user;
      if (_user != null) {
        await _fetchOfficerData(_user!.uid);
      }
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signOut();
      _user = null;
      _officer = null;
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
