import 'package:ble_get_server/controller/home_controller.dart';
import 'package:ble_get_server/controller/main_bluetooth_controller.dart';
import 'package:ble_get_server/views/list_wifi/list_wifi_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static String routeName = "/home";

  @override
  Widget build(BuildContext context) {
    final mainBluetoothController = MainBluetoothController.instance;
    final homeC = HomeControler();

    return SafeArea(
        child: Scaffold(
            body: Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: Obx(
        () => Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Testing Server BLE",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(mainBluetoothController.deviceConnect.value != null
                ? "${mainBluetoothController.deviceConnect.value?.advName} is connected"
                : "App Not Connected"),
            const SizedBox(
              height: 10,
            ),

            // Percabangan
            if (mainBluetoothController.deviceConnect.value != null &&
                mainBluetoothController.processConnect.value == false) ...[
              TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(context, ListWifiScreen.routeName);
                  },
                  icon: const Icon(Icons.wifi_rounded),
                  label: const Text("Pengaturan WIFI")),
              TextButton.icon(
                  onPressed: () async {
                    await homeC.testBluetooth();
                  },
                  icon: const Icon(Icons.online_prediction_outlined),
                  label: const Text("Testing LED")),
              if (homeC.statusLed.value != "") ...[
                const SizedBox(
                  height: 10,
                ),
                Text("Status LED: ${homeC.statusLed.value}"),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.network(
                    homeC.statusLed.value == "ON"
                        ? "https://cdn.icon-icons.com/icons2/2248/PNG/512/led_off_icon_138425.png"
                        : "https://cdn.icon-icons.com/icons2/2248/PNG/512/led_variant_off_icon_138422.png",
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
              ElevatedButton(
                  onPressed: () async {
                    await mainBluetoothController.disconnectBluetooth();
                  },
                  child: const Text("Disconnect Bluetooth")),
            ] else ...[
              ElevatedButton(
                  onPressed: () async {
                    if (mainBluetoothController.isScan.value != true) {
                      await mainBluetoothController.scanBluetooth(context);
                    }
                  },
                  child: Text(mainBluetoothController.isScan.value == true
                      ? "Connecting..."
                      : "Connect Bluetooth")),
            ],
          ],
        ),
      ),
    )));
  }
}
