import 'dart:async';
import 'dart:convert';

import 'package:android_flutter_wifi/android_flutter_wifi.dart';
import 'package:ble_get_server/class/gatt_response.dart';
import 'package:ble_get_server/controller/main_bluetooth_controller.dart';
import 'package:ble_get_server/utils/utils.dart';
import 'package:ble_get_server/views/list_wifi/list_wifi_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AddWifiManualController {
  final passwordControler = TextEditingController().obs;
  final ssidController = TextEditingController().obs;
  final bssidController = TextEditingController().obs;
  final mainBluetoothController = MainBluetoothController.instance;
  // late Timer _timer;

  // // connected wifi info
  // Future<void> getInfoWifiFromPhone() async {
  //   _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
  //     ActiveWifiNetwork activeWifiNetwork =
  //         await AndroidFlutterWifi.getActiveWifiInfo();

  //     if (activeWifiNetwork.ssid != null && activeWifiNetwork.bssid != null) {
  //       String stringWithoutQuotes =
  //           activeWifiNetwork.ssid.toString().replaceAll('"', '');

  //       ssidController.value.text = stringWithoutQuotes.toString();
  //       bssidController.value.text = activeWifiNetwork.bssid.toString();
  //     }
  //     // print(activeWifiNetwork.ssid);
  //   });
  // }

  // Future<void> stopInfoWifi() async {
  //   _timer.cancel();
  // }

  Future<void> getInfoWifiFromPhone() async {
    ActiveWifiNetwork activeWifiNetwork =
        await AndroidFlutterWifi.getActiveWifiInfo();

    if (activeWifiNetwork.ssid != null && activeWifiNetwork.bssid != null) {
      String stringWithoutQuotes =
          activeWifiNetwork.ssid.toString().replaceAll('"', '');

      ssidController.value.text = stringWithoutQuotes.toString();
      bssidController.value.text = activeWifiNetwork.bssid.toString();
    } else {
      AppUtils.toastMessage(
          msg: "Belum ada WiFi yang tersambung !",
          bgColor: Colors.red,
          txtColor: Colors.white);
    }
  }

  Future<void> addWifi(BuildContext context) async {
    String data =
        '{"command": "register wifi", "payload": {"ssid": "${ssidController.value.text}", "bssid": "${bssidController.value.text}", "password": "${passwordControler.value.text}"}}';

    final response = await mainBluetoothController.requestToServer(data);
    GattResponse responseJson = GattResponse.fromJson(jsonDecode(response));

    if (responseJson.status == 'success') {
      passwordControler.value.text = "";
      ssidController.value.text = "";

      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, ListWifiScreen.routeName);

      Fluttertoast.showToast(
          msg: "Wifi berhasil ditambahkan !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      Fluttertoast.showToast(
          msg: responseJson.payload.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
