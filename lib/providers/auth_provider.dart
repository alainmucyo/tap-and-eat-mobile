import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../utils/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  final Dio http;

  AuthProvider(this.http);

  bool get isAuth {
    print(token != null);
    return token != null;
  }

  String? get token {
    if (_token != null && _token!.isNotEmpty) return _token;
    return null;
  }

  Future<void> _authenticate(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
    _token = token;
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    print("Logging in");
    print(username);
    print(password);
    try {

      final response = await http.post(
          "/login",
          data: {
            "email": username,
            "password": password,
          });
      // _authenticate(response.data["access_token"]);
      _authenticate("This is a really super secret token");
    } on DioError catch (e) {
      print(e.response!.data);
      throw HttpException(e.response!.data["message"]);
    }catch(e){
      print(e);
      throw HttpException("Something went wrong");
    }
  }

  Future<void> logout() async {
    _token = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    prefs.clear();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("token")) return false;
    final extractedToken = prefs.getString("token");

    _token = extractedToken;
    notifyListeners();
    return true;
  }
}
