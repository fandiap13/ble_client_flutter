import 'package:app_settings/app_settings.dart';
import 'package:ble_get_server/controller/add_wifi_manual_controller.dart';
import 'package:ble_get_server/views/scan_qr_code/scan_qr_code.dart';
import 'package:flutter/material.dart';

class AddWifiManualScreen extends StatefulWidget {
  const AddWifiManualScreen({super.key});
  static String routeName = "/add_wifi_manual";

  @override
  State<AddWifiManualScreen> createState() => _AddWifiManualScreenState();
}

class _AddWifiManualScreenState extends State<AddWifiManualScreen> {
  final addWifiManual = AddWifiManualController();
  final formKey = GlobalKey<FormState>();

  // @override
  // void initState() {
  //   super.initState();
  //   addWifiManual.getInfoWifiFromPhone();
  // }

  // @override
  // void dispose() {
  //   addWifiManual.stopInfoWifi();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Manual"),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      autofocus: true,
                      controller: addWifiManual.ssidController.value,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "SSID tidak boleh kosong";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(hintText: "SSID"),
                    ),
                    TextButton.icon(
                        onPressed: () async {
                          addWifiManual.getInfoWifiFromPhone();
                        },
                        icon: const Icon(Icons.settings),
                        label: const Text(
                            "Pakai WiFi yang tersambung di smartphone")),
                    // TextButton.icon(
                    //     onPressed: () {
                    //       Navigator.pushNamed(context, ScanQrCode.routeName);
                    //     },
                    //     icon: const Icon(Icons.qr_code),
                    //     label: const Text("Scan QR Code")),
                    // TextButton.icon(
                    //     onPressed: () async {
                    //       AppSettings.openAppSettings(
                    //           type: AppSettingsType.wifi);
                    //     },
                    //     icon: const Icon(Icons.settings),
                    //     label: const Text("Buka pengaturan WIFI")),
                    TextFormField(
                      controller: addWifiManual.bssidController.value,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "BSSID tidak boleh kosong";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(hintText: "BSSID"),
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: addWifiManual.passwordControler.value,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password tidak boleh kosong";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(hintText: "Password"),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              await addWifiManual.addWifi(context);
                            }
                          },
                          child: const Text("Simpan")),
                    )
                  ],
                ))),
      ),
    );
  }
}
