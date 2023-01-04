import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/widgets/shared/input_widget.dart';
import 'package:mobile/widgets/shared/primary_button.dart';
import 'package:nfc_manager/nfc_manager.dart';

import '../widgets/shared/app_drawer.dart';

class AddStudentsScreen extends StatefulWidget {
  const AddStudentsScreen({Key? key}) : super(key: key);

  static const routeName = '/add-students';

  @override
  State<AddStudentsScreen> createState() => _AddStudentsScreenState();
}

class _AddStudentsScreenState extends State<AddStudentsScreen> {
  ValueNotifier<dynamic> result = ValueNotifier(null);
  String text = "";
  String _nfcData = "";
  String names = "";
  String phoneNumber = "";
  String pin = "";
  String confirmPin = "";
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
    var _isLoading = false;
    var _formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Students'),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Asks a user to tap NFC card

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

              /* PrimaryButton(text: "Scan card", onPressed: (){
                _tagRead();
              }),*/
              const SizedBox(height: 10),
              InputWidget(
                  validator: (val) {
                    return null;
                  },
                  label: "Names",
                  onSaved: (val) {
                    names = val!;
                  }),
              const SizedBox(height: 10),
              InputWidget(
                  validator: (val) {
                    return null;
                  },
                  label: "Phone Number",
                  inputType: TextInputType.phone,
                  onSaved: (val) {
                    phoneNumber = val!;
                  }),
              const SizedBox(height: 10),
              InputWidget(
                  validator: (val) {
                    return null;
                  },
                  inputType: TextInputType.number,
                  label: "Pin",
                  onSaved: (val) {
                    pin = val!;
                  }),
              const SizedBox(height: 10),
              InputWidget(
                  validator: (val) {
                    return null;
                  },
                  inputType: TextInputType.number,
                  label: "Confirm Pin",
                  onSaved: (val) {
                    confirmPin = val!;
                  }),
              const SizedBox(height: 10),
              PrimaryButton(
                text: "Save",
                onPressed: () async {
                  Utils.showSnackBar(
                      title: text, context: context, color: Colors.green);

                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    if (pin != confirmPin) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Pin and Confirm Pin do not match"),
                        backgroundColor: Colors.red,
                      ));
                      return;
                    }

                    try {
                      await Dio().post(
                        "${Constants.BASE_URL}/students",
                        data: {
                          "name": names,
                          "phoneNumber": phoneNumber,
                          "pin": pin,
                          "card": text
                        },
                      );

                      Utils.showSnackBar(
                          title: "Student added successfully",
                          context: context,
                          color: Colors.green);
                      setState(() {
                        scan_mode = false;
                        scanned = false;
                      });
                    } catch (e) {
                      Utils.showSnackBar(
                          title: "Something went wrong, try again later",
                          context: context,
                          color: Colors.red);
                      print(e);
                    }
                  }
                },
                block: true,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
