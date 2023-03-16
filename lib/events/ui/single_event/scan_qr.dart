import 'package:flutter/material.dart';

class ScanQr extends StatefulWidget {

  static Route route() {
    return MaterialPageRoute(builder: (_) => ScanQr());
  }

  @override
  _ScanQrState createState() => _ScanQrState();
}

class _ScanQrState extends State<ScanQr> {
  TextEditingController ticketController;
  @override
  void initState() {
    super.initState();
    ticketController = TextEditingController();
  }

  @override
  void dispose() {
    ticketController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scan QR Code"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: ticketController,
              decoration: InputDecoration(
                labelText: 'Enter the code manually',
                hintText: "Enter code"
              ),
            ),
            Container(height: 30,),
            Text("Scan Qr Code",style: TextStyle(fontSize: 20),)
          ],
        ),
      ),
    );
  }
}
