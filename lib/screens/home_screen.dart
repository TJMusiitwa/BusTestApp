import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Bus Transport Test App')),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RaisedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QRCodeTest(),
                    )),
                child: Text('Scan QR Code')),
            SizedBox(height: 20),
            RaisedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NFCReadTest(),
                    )),
                child: Text('Read NFC Card'))
          ],
        ),
      ),
    );
  }
}

class NFCReadTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NFC Card Test'),
        automaticallyImplyLeading: true,
      ),
      body: Container(
          child: Center(
              child: GestureDetector(
        child: Column(children: [
          Icon(Icons.nfc, size: 30),
          SizedBox(height: 20),
          Text('Scan Your Card Here')
        ]),
        onTap: () {
          Future.delayed(
              Duration(seconds: 10),
              () => showDialog(
                    context: context,
                    builder: (context) => SimpleDialog(
                      title: Text('Thank you for paying'),
                      children: [Text('Your remaining balance is USh.50,000')],
                    ),
                  ).then((value) => Future.delayed(
                      Duration(seconds: 2), () => Navigator.pop(context))));
        },
      ))),
    );
  }
}

class QRCodeTest extends StatefulWidget {
  const QRCodeTest({Key key}) : super(key: key);

  @override
  _QRCodeTestState createState() => _QRCodeTestState();
}

class _QRCodeTestState extends State<QRCodeTest> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Code Scan')),
      body: Column(
        children: [
          Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
                overlay: QrScannerOverlayShape(
                  borderColor: Colors.red,
                  borderRadius: 10,
                  borderLength: 30,
                  borderWidth: 10,
                  cutOutSize: 300,
                ),
              )),
          Expanded(
              flex: 1, child: Text('Please display your QR code for scanning')),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((event) {
      print(event);
    }).onData((data) {
      print(data);
      showDialog(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text('Thank you for paying'),
          children: [Text('Your remaining balance is USh.50,000')],
        ),
      ).then(
        (value) => Future.delayed(
          Duration(seconds: 2),
          () => Navigator.pop(context),
        ),
      );
    });
  }
}
