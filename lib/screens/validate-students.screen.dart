import 'package:flutter/material.dart';

import '../widgets/shared/app_drawer.dart';
import '../widgets/shared/primary_button.dart';

class ValidateStudentsScreen extends StatelessWidget {
  const ValidateStudentsScreen({Key? key}) : super(key: key);

  static const routeName = '/validate-students';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validate Students'),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(false)
            Center(
              child: Text(
                "Tap NFC card to validate student!",
                style: Theme.of(context).textTheme.headline5,
                textAlign: TextAlign.center,
              ),
            ),
            Image.asset(
              false
                  ? "images/success.png"
                  : "images/cancel.png",
              width: 120,
              height: 140,
            ),
            const SizedBox(height: 15),
            const Text(
              "Student validated successfully!",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
