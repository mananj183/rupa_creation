import 'dart:convert';
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../modal/http_exception.dart';

class Auth with ChangeNotifier {
  String? _userEmailId;
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _authTimer;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  String? get userEmailId {
    return _userEmailId;
  }

  Future<void> _authenticate(
      String email, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCzfWFnJt8H827n5F7XmAxw_NJ5P4V3bwY';
    try {
      var response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'email': '$email@rupacreation.com',
            'password': 'Chiru@69',
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      _userEmailId = email;
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expiryDate': _expiryDate!.toIso8601String(),
          'userEmailId': _userEmailId,
        },
      );
      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signup(String email, String name) async {
    try{
      FirebaseAuth auth = FirebaseAuth.instance;
      UserCredential userCredential =
      await auth.createUserWithEmailAndPassword(
          email: '$email@rupacreation.com', password: 'Chiru@69');
      if (userCredential.user != null) {
        DatabaseReference userRef = FirebaseDatabase.instance.ref().child( 'users');
        String uid = userCredential.user!.uid;
        // int dt = DateTime.now().millisecondsSinceEpoch;
        await userRef.child(uid).set({
          'fullName': name,
          'email': email,
          // 'date': dt,
        });
        await login(email);
      }

    }catch(e){
      rethrow;
    }
  }

  Future<void> login(String email) async {
    return _authenticate(email, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData =
        json.decode(prefs.getString('userData')!);
    final expiryDate =
        DateTime.parse(extractedUserData['expiryDate'].toString());
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'].toString();
    _userId = extractedUserData['userId'].toString();
    _expiryDate = expiryDate;
    _userEmailId = extractedUserData['userEmailId'].toString();
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    _userEmailId = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
