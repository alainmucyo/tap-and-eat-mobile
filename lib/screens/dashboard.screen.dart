import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:mobile/screens/validate-students.screen.dart';
import 'package:mobile/widgets/dashboard_summary.dart';
import 'package:mobile/widgets/shared/app_drawer.dart';

import '../widgets/shared/primary_button.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  static const routeName = '/dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
        child: Column(
          children: [
            Center(
              child: Text("Tap & Eat",
                  style: Theme.of(context).textTheme.headline4),
            ),
            SizedBox(height: 5),
            AnimatedTextKit(
              isRepeatingAnimation: true,
              animatedTexts: [
                TypewriterAnimatedText(
                  'Welcome!',
                  textStyle: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Theme.of(context).accentColor,
                  ),
                  speed: const Duration(milliseconds: 500),
                ),
              ],
              totalRepeatCount: 4,
              pause: const Duration(milliseconds: 1000),
              displayFullTextOnTap: true,
              stopPauseOnTap: true,
            ),
            SizedBox(height: 20),
            PrimaryButton(
              text: "VALIDATE STUDENTS",
              onPressed: () {
                Navigator.of(context).pushNamed(ValidateStudentsScreen.routeName);
              },
              block: true,
            ),
            SizedBox(height: 20),
            DashboardSummaryWidget(),
          ],
        ),
      ),
    );
  }
}
