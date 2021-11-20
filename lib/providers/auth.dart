import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _tokenDuration;
  String _userId;
  Timer _timer;

  bool get isLogedIn {
    if(getToken != null)
      return true;

    return false;
  }

  String get getToken {
    if(_tokenDuration != null && _tokenDuration.isAfter(DateTime.now()) && _token != null) {
      return _token;
    }else {
      return null;
    }
  }

  String get getUser {
    if(getToken != null)
      return _userId;

    return null;
  }

  Future<void> signUp(String email, String password) async {
    final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDdOk-WbM-7lM_qz9YsXLJZ35jSH5FXmFQ');
    try{
      final response = await http.post(url, body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true
      }));
      final res = json.decode(response.body);
      if(res['error'] != null){
        throw HttpException(res['error']['message']);
      }
    }catch(error){
      throw(error);
    }
  }

  Future<void> logIn(String email, String password) async {
    print(email);
    print(password);
    final url = Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDdOk-WbM-7lM_qz9YsXLJZ35jSH5FXmFQ');
    try{
      final response = await http.post(url, body: json.encode({
        'email': email,
        'password': password,
        'returnSecureToken': true
      }));
      final res = json.decode(response.body);
      if(res['error'] != null){
        throw HttpException(res['error']['message']);
      }
      _token = res['idToken'];
      _userId = res['localId'];
      _tokenDuration = DateTime.now().add(Duration(seconds: int.parse(res['expiresIn'])));
      _expiredDurationLogout();
      notifyListeners();
      // Postavljanje autologina
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'tokenDuration': _tokenDuration.toIso8601String(),
        'userId': _userId
      });
      prefs.setString('userData', userData);

    }catch(error){
      print(error);
     throw(error);
    }
  }

  Future<bool> autoLogin() async{
    final prefs = await SharedPreferences.getInstance();

    print('prefs check');
    if(prefs.containsKey('userData'))
      return false;

    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
    final tokenDuration = DateTime.parse(extractedUserData['tokenDuration']);
    print('autologin token check');
    if(tokenDuration.isBefore(DateTime.now()))
      return false;
    print('autologin before token check');
    _token = extractedUserData['token'];
    _tokenDuration = tokenDuration;
    _userId = extractedUserData['userId'];
    notifyListeners();
    _expiredDurationLogout();

    return true;
  }

  Future<void> logOut() async{
    _token = null;
    _userId = null;
    _tokenDuration = null;
    if(_timer != null){
      _timer.cancel();
      _timer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('userData');
    prefs.clear(); //moze i ovo al ce pobrisati kompletan prefs.
  }

  void _expiredDurationLogout(){
    if(_timer != null){
      _timer.cancel();
    }
    final timeToExpiry = _tokenDuration.difference(DateTime.now()).inSeconds;
    _timer = Timer(Duration(seconds: timeToExpiry), logOut);
  }
}