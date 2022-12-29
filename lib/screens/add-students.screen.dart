import 'package:flutter/material.dart';
import 'package:mobile/widgets/shared/input_widget.dart';
import 'package:mobile/widgets/shared/primary_button.dart';

import '../widgets/shared/app_drawer.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';

class AddStudentsScreen extends StatefulWidget {
  const AddStudentsScreen({Key? key}) : super(key: key);

  static const routeName = '/add-students';

  @override
  State<AddStudentsScreen> createState() => _AddStudentsScreenState();
}

class _AddStudentsScreenState extends State<AddStudentsScreen> {
  String text = "";
  String _nfcData = "";

  Future<void> _checkNfcSupport() async {
    NFCAvailability nfcAvailability =
        await FlutterNfcReader.checkNFCAvailability();

    setState(() {
      _nfcData = nfcAvailability.toString();
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
    });
  }

  @override
  Widget build(BuildContext context) {
    FlutterNfcReader.read().then((response) {
      setState(() {
        text = response.content?.toString() ?? "No content";
      });
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Students'),
        centerTitle: true,
      ),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            // Asks a user to tap NFC card
            Text(_nfcData),
            Text(text),
            Text("Tap NFC card to add student",
                style: Theme.of(context).textTheme.headline6),
            SizedBox(height: 20),
            InputWidget(
                validator: (val) {
                  return null;
                },
                label: "Names",
                onSaved: (val) {}),
            SizedBox(height: 10),
            InputWidget(
                validator: (val) {
                  return null;
                },
                label: "Phone Number",
                onSaved: (val) {}),
            SizedBox(height: 10),
            InputWidget(
                validator: (val) {
                  return null;
                },
                label: "Pin",
                onSaved: (val) {}),
            SizedBox(height: 10),
            InputWidget(
                validator: (val) {
                  return null;
                },
                label: "Confirm Pin",
                onSaved: (val) {}),
            SizedBox(height: 10),
            PrimaryButton(text: "Save", onPressed: () {}, block: true),
          ],
        ),
      ),
    );
  }
}
