import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/nfc-scan.dart';
import 'package:mobile/providers/history_provider.dart';
import 'package:mobile/providers/reports_provider.dart';
import 'package:mobile/screens/add-students.screen.dart';
import 'package:mobile/screens/history.screen.dart';
import 'package:mobile/screens/login.dart';
import 'package:mobile/screens/splash_screen.dart';
import 'package:mobile/screens/topup.screen.dart';
import 'package:mobile/screens/validate-students.screen.dart';
import 'package:mobile/utils/constants.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'screens/dashboard.screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Dio dio = Dio();
    dio.options.baseUrl = Constants.BASE_URL;
    // create theme swatch
    MaterialColor createThemeSwatch(Color color) {
      List strengths = <double>[.05];
      Map<int, Color> swatch = {};
      final int r = color.red, g = color.green, b = color.blue;

      for (int i = 1; i < 10; i++) {
        strengths.add(0.1 * i);
      }
      strengths.forEach((strength) {
        final double ds = 0.5 - strength;
        swatch[(strength * 1000).round()] = Color.fromRGBO(
          r + ((ds < 0 ? r : (255 - r)) * ds).round(),
          g + ((ds < 0 ? g : (255 - g)) * ds).round(),
          b + ((ds < 0 ? b : (255 - b)) * ds).round(),
          1,
        );
      });
      return MaterialColor(color.value, swatch);
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(dio)),
        ChangeNotifierProvider(create: (_) => ReportsProvider(dio)),
        ChangeNotifierProvider(create: (_) => HistoryProvider(dio)),

      ],
      child: MaterialApp(
        title: 'Tap & Eat',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          accentColor: CustomColor.LIGHT_PRIMARY,
          primaryColor: CustomColor.PRIMARY,
          primarySwatch: createThemeSwatch(CustomColor.PRIMARY),
          hintColor: Colors.grey[200],
          textTheme: GoogleFonts.nunitoTextTheme(
            Theme.of(context).textTheme.apply(
                  bodyColor: CustomColor.DARK_GREY,
                  displayColor: CustomColor.DARK_GREY,
                ),
          ),
        ),
        home: AddStudentsScreen(),
        routes: {
          DashboardScreen.routeName: (_) => const DashboardScreen(),
          LoginScreen.routeName: (_) => LoginScreen(),
          ValidateStudentsScreen.routeName: (_) =>
              const ValidateStudentsScreen(),
          AddStudentsScreen.routeName: (_) => const AddStudentsScreen(),
          TopupScreen.routeName: (_) => const TopupScreen(),
          HistoryScreen.routeName: (_) => const HistoryScreen(),
        },
      ),
    );
  }
}
