import 'dart:convert';

import 'package:ble_get_server/class/gatt_response.dart';
import 'package:ble_get_server/controller/main_bluetooth_controller.dart';
import 'package:ble_get_server/utils/utils.dart';
import 'package:ble_get_server/views/list_wifi/list_wifi_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailWifiController {
  final mainBluetooth = MainBluetoothController.instance;
  RxBool isLoading = false.obs;
  List arguments = [].obs;

  Future<void> connectWIFI(BuildContext context) async {
    isLoading.value = true;
    final response = await mainBluetooth.requestToServer(
        '{"command":"wifi connect","payload":{"ssid":"${arguments[0]}","bssid":"${arguments[1]}"}}');
    GattResponse responseJson = GattResponse.fromJson(jsonDecode(response));
    if (responseJson.status == 'success') {
      Navigator.pushNamed(context, ListWifiScreen.routeName);

      AppUtils.toastMessage(
          msg: "Prioritas berhasil disambungkan",
          bgColor: Colors.green,
          txtColor: Colors.white);
    } else {
      AppUtils.toastMessage(
          msg: responseJson.payload.toString(),
          bgColor: Colors.red,
          txtColor: Colors.white);
    }
    isLoading.value = false;
  }

  Future<void> reconnectWIFI(BuildContext context) async {
    isLoading.value = true;
    final response = await mainBluetooth.requestToServer(
        '{"command":"wifi reconnect","payload":{"ssid":"${arguments[0]}","bssid":"${arguments[1]}"}}');
    GattResponse responseJson = GattResponse.fromJson(jsonDecode(response));
    if (responseJson.status == 'success') {
      Navigator.pushNamed(context, ListWifiScreen.routeName);

      AppUtils.toastMessage(
          msg: "WIFI berhasil disambungkan ulang",
          bgColor: Colors.green,
          txtColor: Colors.white);
    } else {
      AppUtils.toastMessage(
          msg: responseJson.payload.toString(),
          bgColor: Colors.red,
          txtColor: Colors.white);
    }
    isLoading.value = false;
  }

  Future<void> setPriorityWIFI(BuildContext context) async {
    isLoading.value = true;
    final response = await mainBluetooth.requestToServer(
        '{"command":"add priority wifi","payload":{"ssid":"${arguments[0]}","bssid":"${arguments[1]}"}}');
    GattResponse responseJson = GattResponse.fromJson(jsonDecode(response));
    if (responseJson.status == 'success') {
      reloadData(responseJson);

      AppUtils.toastMessage(
          msg: "Prioritas berhasil ditambahkan",
          bgColor: Colors.green,
          txtColor: Colors.white);
    } else {
      AppUtils.toastMessage(
          msg: responseJson.payload.toString(),
          bgColor: Colors.red,
          txtColor: Colors.white);
    }
    isLoading.value = false;
  }

  Future<void> removePriorityWIFI(BuildContext context) async {
    isLoading.value = true;
    final response = await mainBluetooth.requestToServer(
        '{"command":"remove priority wifi","payload":{"ssid":"${arguments[0]}","bssid":"${arguments[1]}"}}');
    GattResponse responseJson = GattResponse.fromJson(jsonDecode(response));
    if (responseJson.status == 'success') {
      reloadData(responseJson);

      AppUtils.toastMessage(
          msg: "Prioritas berhasil dihapus",
          bgColor: Colors.green,
          txtColor: Colors.white);
    } else {
      AppUtils.toastMessage(
          msg: responseJson.payload.toString(),
          bgColor: Colors.red,
          txtColor: Colors.white);
    }
    isLoading.value = false;
  }

  Future<void> forgetWIFI(BuildContext context) async {
    if (bool.parse(arguments[3]) == true) {
      AppUtils.toastMessage(
          msg: "WIFI masih tersambung",
          bgColor: Colors.red,
          txtColor: Colors.white,
          time: 5);
      return;
    }
    isLoading.value = true;

    final response = await mainBluetooth.requestToServer(
        '{"command":"forget wifi","payload":{"ssid":"${arguments[0]}","bssid":"${arguments[1]}"}}');
    GattResponse responseJson = GattResponse.fromJson(jsonDecode(response));
    if (responseJson.status == 'success') {
      Navigator.pushNamed(context, ListWifiScreen.routeName);
      AppUtils.toastMessage(
          msg: "WIFI berhasil dihapus",
          bgColor: Colors.green,
          txtColor: Colors.white);
    } else {
      AppUtils.toastMessage(
          msg: responseJson.payload.toString(),
          bgColor: Colors.red,
          txtColor: Colors.white);
    }
    isLoading.value = false;
  }

  Future<void> disconnectWIFI(BuildContext context) async {
    isLoading.value = true;
    final response = await mainBluetooth.requestToServer(
        '{"command":"wifi disconnect","payload":{"ssid":"${arguments[0]}","bssid":"${arguments[1]}"}}');
    GattResponse responseJson = GattResponse.fromJson(jsonDecode(response));
    // print(response);
    if (responseJson.status == 'success') {
      Navigator.pushNamed(context, ListWifiScreen.routeName);

      AppUtils.toastMessage(
          msg: "WIFI berhasil terputus",
          bgColor: Colors.green,
          txtColor: Colors.white);
    } else {
      AppUtils.toastMessage(
          msg: responseJson.payload.toString(),
          bgColor: Colors.red,
          txtColor: Colors.white);
    }
    isLoading.value = false;
  }

  void reloadData(GattResponse responseJson) {
    List<String> responseArguments = [
      responseJson.payload['ssid'],
      responseJson.payload['bssid'],
      responseJson.payload['priority'],
      responseJson.payload['connectivity']
    ];

    arguments.clear();
    arguments.addAll(responseArguments);
  }
}
