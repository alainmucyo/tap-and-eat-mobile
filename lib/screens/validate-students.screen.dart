import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/utils/constants.dart';
import 'package:nfc_manager/nfc_manager.dart';

import '../widgets/shared/app_drawer.dart';
import '../widgets/shared/primary_button.dart';

class ValidateStudentsScreen extends StatefulWidget {
  const ValidateStudentsScreen({Key? key}) : super(key: key);

  static const routeName = '/validate-students';

  @override
  State<ValidateStudentsScreen> createState() => _ValidateStudentsScreenState();
}

class _ValidateStudentsScreenState extends State<ValidateStudentsScreen> {
  ValueNotifier<dynamic> result = ValueNotifier(null);

  String text = "";
  bool status = false;
  bool validated = false;
  bool loading = false;
  bool scanned = false;
  bool scan_mode = false;

  void _tagRead() {
    result.addListener(() {
      if (scanned) return;

      setState(() {
        scanned = true;
        text = Utils.generateMd5(result.value.toString());
        Utils.showSnackBar(title: text, context: context);
      });
    });

    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data;
      NfcManager.instance.stopSession();
    });
  }

  @override
  Widget build(BuildContext context) {
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
              if (!scan_mode && !scanned)
                Text(
                  "Click button below to start scanning",
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center,
                ),

              if (scan_mode && !scanned)
                Center(
                  child: Text(
                    "Tap NFC card to validate student!",
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                ),
              if (scan_mode && scanned)
                Center(
                  child: Text(
                    "NFC card scanned! Tap button to scan a new card",
                    style: Theme.of(context).textTheme.headline5,
                    textAlign: TextAlign.center,
                  ),
                ),
              if ((scan_mode && scanned) || (!scan_mode && !scanned))
                TextButton(
                  onPressed: () {
                    setState(() {
                      scan_mode = true;
                      scanned = false;
                    });
                    _tagRead();
                  },
                  child: const Text(
                    "Scan A New Card",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1),
                  ),
                ),
              const SizedBox(height: 10),

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
              if (scanned)
                PrimaryButton(
                  text: "Validate",
                  block: true,
                  isLoading: loading,
                  onPressed: () async {
                    Utils.showSnackBar(
                        title: text, context: context, color: Colors.green);

                    try {
                      setState(() {
                        loading = true;
                      });
                      await new Dio().post(
                          "${Constants.BASE_URL}/validate-card",
                          data: {"card": text});
                      setState(() {
                        validated = true;
                        status = true;
                        loading = false;
                        scan_mode = false;
                        scanned = false;
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
