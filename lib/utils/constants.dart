
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart';
import '../screens/login.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';


class CustomColor {
  static const Color LIGHT_GREY = Color(0xfff7fafc);
  static const Color LIGHT_GREY_2 = Color(0xffe2e8f0);
  static const Color LIGHT_GREY_3 = Color(0xffcbd5e0);
  static const Color DARK_GREY = Color(0xff4a5568);
  static const Color SUPER_DARK_GREY = Color(0xff2d3748);

  // static const Color PRIMARY = Color(0xff4277FD);
  static const Color PRIMARY = Color(0xff69B7FF);
  static const Color LIGHT_PRIMARY = Color(0xff648ffd);

  // static const Color PRIMARY = Color(0xff2161e7);
  static const Color ACCENT_COLOR = Color(0xff4277FD);
  static const Color RED_COLOR = Color(0xffFF0000);
}

class Constants {
  static const BASE_URL = "https://8160-102-22-162-13.eu.ngrok.io/api";
}

class Utils {
  static String numberFormat(int num) {
    if (num < 1000) return "$num";
    var formatter = NumberFormat('##,000');
    return formatter.format(num);
  }

  static String compactNumber(int num) {
    return NumberFormat.compact().format(num);
  }

  static void showSnackBar({
    required String title,
    required BuildContext context,
    Color color = Colors.red,
  }) {
    final snackBar = SnackBar(
      content: Text(title),
      backgroundColor: color,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static String? validateMobile(String value) {
    String pattern = r'(^(07[8,2,3,9])[0-9]{7}$)';
    RegExp regExp = RegExp(pattern);
    if (value.isEmpty) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }


  static void logout(BuildContext context) {
    Provider.of<AuthProvider>(context, listen: false).logout();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
        ModalRoute.withName("/login"));
  }

  static String generateMd5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }
}
