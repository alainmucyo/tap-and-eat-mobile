import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:mobile/utils/constants.dart';
import 'package:mobile/widgets/shared/input_widget.dart';
import 'package:mobile/widgets/shared/primary_button.dart';
import 'package:nfc_manager/nfc_manager.dart';

import '../widgets/shared/app_drawer.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';

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

  Future<void> _checkNfcSupport() async {
    NFCAvailability nfcAvailability =
        await FlutterNfcReader.checkNFCAvailability();

    setState(() {
      _nfcData = nfcAvailability.toString();
    });

    FlutterNfcReader.onTagDiscovered().listen((onData) {
      print(onData.id);
      print(onData.content);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkNfcSupport().then((value) {
      FlutterNfcReader.onTagDiscovered().listen((onData) {
        print(onData.id);
        print(onData.content);
        print(onData.error);
        setState(() {
          text = onData.content?.toString() ?? "Nothing";
        });
      });
    });
  }

  void read() {
    FlutterNfcReader.onTagDiscovered().listen((onData) {
      print(onData.id);
      print(onData.content);
      Utils.showSnackBar(title: "Card found", context: context);
    });
  }

  void readCard(){
    FlutterNfcReader.read().then((value) {
      print(value);
      Utils.showSnackBar(title: "Card found", context: context);
    });
  }

  void _tagRead() {
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data;
      NfcManager.instance.stopSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    read();
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
              Flex(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                direction: Axis.vertical,
                children: [
                  Flexible(
                    flex: 2,
                    child: Container(
                      margin: EdgeInsets.all(4),
                      constraints: BoxConstraints.expand(),
                      decoration: BoxDecoration(border: Border.all()),
                      child: SingleChildScrollView(
                        child: ValueListenableBuilder<dynamic>(
                          valueListenable: result,
                          builder: (context, value, _) {
                            setState(() {
                              text = value.toString();
                            });
                              return Text('Card scanned');
                          }
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    child: GridView.count(
                      padding: EdgeInsets.all(4),
                      crossAxisCount: 2,
                      childAspectRatio: 4,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      children: [
                        ElevatedButton(
                            child: Text('Tag Read'), onPressed: _tagRead),

                      ],
                    ),
                  ),
                ],
              ),
              Text(_nfcData),
              Text("Card number"+text),
              Text("Tap NFC card to add student ",
                  style: Theme.of(context).textTheme.headline6),
              SizedBox(height: 20),
              InputWidget(
                  validator: (val) {
                    return null;
                  },
                  label: "Card Number",
                  onSaved: (val) {
                    text = val!;
                  }),
              SizedBox(height: 20),
              InputWidget(
                  validator: (val) {
                    return null;
                  },
                  label: "Names",
                  onSaved: (val) {
                    names = val!;
                  }),
              SizedBox(height: 10),
              InputWidget(
                  validator: (val) {
                    return null;
                  },
                  label: "Phone Number",
                  inputType: TextInputType.phone,
                  onSaved: (val) {
                    phoneNumber = val!;
                  }),
              SizedBox(height: 10),
              InputWidget(
                  validator: (val) {
                    return null;
                  },
                  inputType: TextInputType.number,
                  label: "Pin",
                  onSaved: (val) {
                    pin = val!;
                  }),
              SizedBox(height: 10),
              InputWidget(
                  validator: (val) {
                    return null;
                  },
                  inputType: TextInputType.number,
                  label: "Confirm Pin",
                  onSaved: (val) {
                    confirmPin = val!;
                  }),
              SizedBox(height: 10),
              PrimaryButton(
                text: "Save",
                onPressed: () async {
                  readCard();
                  return;
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

                      Utils.showSnackBar(title: "Student added successfully", context: context,color: Colors.green);
                    } catch (e) {

                      Utils.showSnackBar(title: "Something went wrong, try again later", context: context,color: Colors.red);
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
