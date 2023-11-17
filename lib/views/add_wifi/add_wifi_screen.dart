import 'dart:convert';

import 'package:ble_get_server/controller/add_wifi_controller.dart';
import 'package:ble_get_server/controller/main_bluetooth_controller.dart';
import 'package:ble_get_server/views/add_wifi_manual/add_wifi_manual_screen.dart';
import 'package:ble_get_server/views/add_wifi_with_password/add_wifi_with_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddWifiScreen extends StatefulWidget {
  const AddWifiScreen({super.key});

  static String routeName = "/add_wifi";

  @override
  State<AddWifiScreen> createState() => _AddWifiScreenState();
}

class _AddWifiScreenState extends State<AddWifiScreen> {
  final mainBluetooth = MainBluetoothController.instance;
  final addWifiC = AddWifiController();

  @override
  void initState() {
    addWifiC.scanWifi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah WiFi"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.blueGrey)),
                  onPressed: () {
                    Navigator.pushNamed(context, AddWifiManualScreen.routeName);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Tambah manual")),
            ),
            const SizedBox(
              height: 20,
            ),
            Obx(() {
              var response =
                  jsonDecode(mainBluetooth.streamUpdateBluetoothMessage.value);
              if (response is Map && (response['payload'] is List)) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: response['payload'].length,
                    itemBuilder: (context, index) {
                      var data = response['payload'][index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context, AddWifiWithPasswordScreen.routeName,
                              arguments: data);
                        },
                        child: ListTile(
                          leading: const Icon(Icons.wifi_rounded),
                          title: Text(data[0].toString()),
                          subtitle: Text(data[1].toString()),
                        ),
                      );
                    },
                  ),
                );
              }
              return const Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                      child: Text(
                    "Tidak ada",
                    style: TextStyle(fontSize: 20),
                  )),
                ],
              );
            }),
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: () async {
              if (addWifiC.statusScanWifi == Status.SCAN) {
                await addWifiC.stopScanWifi();
              } else {
                await addWifiC.scanWifi();
              }
            },
            child: Obx(
              () => Row(
                children: [
                  if (addWifiC.statusScanWifi == Status.SCAN) ...[
                    const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        )),
                    const SizedBox(
                      width: 10,
                    ),
                  ],
                  Text(
                      addWifiC.statusScanWifi == Status.SCAN ? "Stop" : "Start")
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
