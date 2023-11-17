import 'dart:convert';

import 'package:ble_get_server/class/gatt_response.dart';
import 'package:ble_get_server/controller/main_bluetooth_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

enum Status { SCAN, STOP, ERROR }

class AddWifiController {
  final mainBluetooth = MainBluetoothController.instance;
  var listWifi = [].obs;
  RxBool loading = false.obs;
  final statusScanWifi = Status.SCAN.obs;

  Future<void> scanWifi() async {
    final response =
        await mainBluetooth.requestToServer('{"command": "wifi scan start"}');
    GattResponse responseJson = GattResponse.fromJson(jsonDecode(response));
    statusScanWifi.value = Status.SCAN;

    // print(response);
    if (responseJson.status != 'success') {
      statusScanWifi.value = Status.ERROR;
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

  Future<void> stopScanWifi() async {
    final response =
        await mainBluetooth.requestToServer('{"command": "wifi scan stop"}');
    GattResponse responseJson = GattResponse.fromJson(jsonDecode(response));
    statusScanWifi.value = Status.STOP;

    if (responseJson.status != 'success') {
      statusScanWifi.value = Status.ERROR;
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
