import 'dart:convert';

import 'package:ble_get_server/class/gatt_response.dart';
import 'package:ble_get_server/controller/list_wifi_controller.dart';
import 'package:ble_get_server/controller/main_bluetooth_controller.dart';
import 'package:ble_get_server/views/add_wifi/add_wifi_screen.dart';
import 'package:ble_get_server/views/detail_wifi/detail_wifi_screen.dart';
import 'package:ble_get_server/views/home/home_screen.dart';
import 'package:ble_get_server/views/list_wifi/components/list_wifi_component.dart';
import 'package:ble_get_server/views/list_wifi/components/wifi_connection_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListWifiScreen extends StatefulWidget {
  const ListWifiScreen({super.key});

  static String routeName = "/list_wifi";

  @override
  State<ListWifiScreen> createState() => _ListWifiScreenState();
}

class _ListWifiScreenState extends State<ListWifiScreen> {
  final myBluetoothController = MainBluetoothController.instance;
  final listWifiController = ListWifiController();

  @override
  void initState() {
    listWifiController.getListWifi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WiFi yang terdaftar"),
        automaticallyImplyLeading: false,
        actions: [
          TextButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, HomeScreen.routeName);
              },
              icon: const Icon(
                Icons.home_rounded,
                color: Colors.white,
              ),
              label: const Text(
                "Back to home",
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.blueGrey)),
                  onPressed: () async {
                    Navigator.pushNamed(context, AddWifiScreen.routeName);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Tambah Wifi")),
              const SizedBox(
                height: 10,
              ),
              Obx(
                () {
                  GattResponse connectedWifi = GattResponse.fromJson(jsonDecode(
                      myBluetoothController
                          .streamUpdateBluetoothMessage.value));
                  if (connectedWifi.status == 'connected') {
                    // {"ssid":"Widya Imersif", "bssid":"00:11:22:33:44:55", "priority":"false", "connectivity":"true"}
                    List dataConnect = [
                      connectedWifi.payload['ssid'],
                      connectedWifi.payload['bssid'],
                      connectedWifi.payload['priority'],
                      connectedWifi.payload['connectivity'],
                    ];
                    return ListTile(
                      title: Text(connectedWifi.payload['ssid']),
                      subtitle: WifiConnectionText(
                          status: bool.parse(
                              connectedWifi.payload['connectivity'])),
                      trailing: InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, DetailWifiScreen.routeName,
                              arguments: dataConnect);
                        },
                        child: const Icon(
                          Icons.info_outline_rounded,
                          size: 30,
                          color: Colors.blue,
                        ),
                      ),
                    );
                  }
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Tidak ada WIFI yang tersambung"),
                  );
                },
              ),
              const Divider(),
              Expanded(
                child:
                    ListWifiComponent(listWifiController: listWifiController),
              ),
              const SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Obx(() => ElevatedButton.icon(
            onPressed: () async {
              await listWifiController.getListWifi();
            },
            icon: listWifiController.loading.value == true
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ))
                : const Icon(Icons.refresh),
            label: const Text("Refresh"),
          )),
    );
  }
}
