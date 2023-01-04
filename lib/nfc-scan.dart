import 'package:flutter/material.dart';
import 'package:mobile/utils/constants.dart';
import 'package:nfc_manager/nfc_manager.dart';

class NfcScanner extends StatefulWidget {
  const NfcScanner({Key? key}) : super(key: key);

  @override
  State<NfcScanner> createState() => _NfcScannerState();
}

class _NfcScannerState extends State<NfcScanner> {
  ValueNotifier<dynamic> result = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('NfcManager Plugin Example')),
      body: SafeArea(
        child: FutureBuilder<bool>(
          future: NfcManager.instance.isAvailable(),
          builder: (context, ss) => ss.data != true
              ? Center(child: Text('NfcManager.isAvailable(): ${ss.data}'))
              : Flex(
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
                              Utils.showSnackBar(title: "Card scanned from value listenable builder", context: context);
                              return Text('This is a response: ${value ?? ''}');
                            },
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
        ),
      ),
    );
  }

  void _tagRead() {
    result.addListener(() {
      print(result.value);
      Utils.showSnackBar(
          title: "NFC Scanned from add listener", context: context);
    });

    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      result.value = tag.data;
      NfcManager.instance.stopSession();
    });
  }
}
