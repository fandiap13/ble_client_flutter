import 'dart:async';
import 'dart:convert';

import 'package:app_settings/app_settings.dart';
import 'package:ble_get_server/class/gatt_response.dart';
import 'package:ble_get_server/controller/main_bluetooth_controller.dart';
import 'package:ble_get_server/utils/utils.dart';
import 'package:ble_get_server/views/list_wifi/list_wifi_screen.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

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
    var locationPermission = await Permission.location.status;
    var locationStatus = await Permission.location.serviceStatus;
    if (locationStatus.isDisabled) {
      AppSettings.openAppSettings(type: AppSettingsType.location);
      return;
    }

    if (locationPermission.isGranted) {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult == ConnectivityResult.wifi) {
        final info = NetworkInfo();
        var ssidWifi = await info.getWifiName();
        var bssid = await info.getWifiBSSID();
        print("================================");
        print(ssidWifi);
        print(bssid);
        print("================================");
        if (ssidWifi != null && bssid != null) {
          ssidController.value.text = ssidWifi.toString().replaceAll('"', '');
          bssidController.value.text = bssid.toString();
        }
      } else {
        // membuka pengaturan wifi
        AppSettings.openAppSettings(type: AppSettingsType.wifi);
      }
    } else {
      openAppSettings();
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
