import 'package:flutter/material.dart';
import 'package:native_barcode_scanner/barcode_scanner.dart';
import 'package:native_barcode_scanner/barcode_scanner.widget.dart';

class ScanQrCode extends StatefulWidget {
  const ScanQrCode({super.key});

  static String routeName = "/scan_qr_code";

  @override
  State<ScanQrCode> createState() => _ScanQrCodeState();
}

class _ScanQrCodeState extends State<ScanQrCode> {
  @override
  Widget build(BuildContext context) {
    return buildWithOverlay(
        context,
        BarcodeScannerWidget(
          scannerType: ScannerType.barcode,
          onTextDetected: (value) => print(value),
          onBarcodeDetected: (barcode) async {
            debugPrint("================================");
            debugPrint(barcode.value);
            debugPrint("================================");

            var cek = barcode.value;
            var regex = RegExp(r'^([^\"]+) \"([^\"]+)\"$');
            var match = regex.firstMatch(cek);

            if (match != null) {
              var nama = match.group(1);
              var password = match.group(2);

              await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Align(
                        alignment: Alignment.center,
                        child: SizedBox(
                          width: double.infinity,
                          child: Card(
                              child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Hasil",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 30),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Text(
                                  "SSID : $nama",
                                  style: const TextStyle(fontSize: 20),
                                ),
                                Text(
                                  "Password : $password",
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          await BarcodeScanner.startScanner();
                                        },
                                        child: const Text(
                                          "Ulangi",
                                          style: TextStyle(fontSize: 20),
                                        )),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          await BarcodeScanner.stopScanner();
                                        },
                                        child: const Text(
                                          "Selesai",
                                          style: TextStyle(fontSize: 20),
                                        ))
                                  ],
                                )
                              ],
                            ),
                          )),
                        ),
                      ),
                    );
                  });
            } else {
              await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Error"),
                      content: const Text("Format barcode tidak sesuai !"),
                      actions: [
                        TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await BarcodeScanner.startScanner();
                            },
                            child: const Text("Ulangi"))
                      ],
                    );
                  });
            }
          },
          onError: (dynamic error) async {
            debugPrint(error.toString());
          },
        ));
  }

  buildWithOverlay(BuildContext builderContext, Widget scannerWidget) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Stack(children: [
              Positioned.fill(child: scannerWidget),
              Align(
                  alignment: Alignment.center,
                  child: Divider(color: Colors.red[400], thickness: 0.8)),
              Center(
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 64),
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 2),
                          borderRadius: BorderRadius.circular(15)))),
            ]),
          ),
        ],
      ),
    );
  }
}
