import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/widgets/shared/input_widget.dart';

import '../widgets/shared/app_drawer.dart';
import '../widgets/shared/primary_button.dart';

class ValidateStudentsScreen extends StatefulWidget {
  const ValidateStudentsScreen({Key? key}) : super(key: key);

  static const routeName = '/validate-students';

  @override
  State<ValidateStudentsScreen> createState() => _ValidateStudentsScreenState();
}

class _ValidateStudentsScreenState extends State<ValidateStudentsScreen> {
  String text = "";
  bool status = false;
  bool validated = false;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    TextEditingController card = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Validate Students'),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (true)
                Center(
                  child: Text(
                    "Tap NFC card to validate student!",
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                ),
              SizedBox(height: 10),
              InputWidget(
                  validator: (value) {
                    return null;
                  },
                  label: "Card Number",
                  controller: card,
                  onSaved: (val) {}),
              if (validated)
                Image.asset(
                  status ? "images/success.png" : "images/cancel.png",
                  width: 120,
                  height: 140,
                ),
              const SizedBox(height: 15),
              if (validated && status)
                const Text(
                  "Student validated successfully!",
                  style: TextStyle(fontSize: 18),
                ),
              if (validated && !status)
                const Text(
                  "Student validation failed!",
                  style: TextStyle(fontSize: 18),
                ),
              const SizedBox(height: 50),
              PrimaryButton(
                text: "Validate",
                block: true,
                isLoading: loading,
                onPressed: () async {
                  try {
                    setState(() {
                      loading = true;
                    });
                    await new Dio().post("${Constants.BASE_URL}/validate-card",
                        data: {"card": card.text});
                    setState(() {
                      validated = true;
                      status = true;
                      loading = false;
                    });
                  } on DioError catch (e) {
                    Utils.showSnackBar(
                        title: e.response!.data["message"], context: context);
                    setState(() {
                      validated = true;
                      status = false;
                      loading = false;
                    });
                  } catch (e) {
                    setState(() {
                      validated = true;
                      status = false;
                      loading = false;
                    });
                  } finally {
                    setState(() {
                      loading = false;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
