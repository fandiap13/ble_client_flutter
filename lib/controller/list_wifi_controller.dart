import 'dart:convert';

import 'package:ble_get_server/class/gatt_response.dart';
import 'package:ble_get_server/controller/main_bluetooth_controller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ListWifiController {
  final mainBluetoothController = MainBluetoothController.instance;
  var listWifi = [].obs;
  // var connectedWifi = [].obs;
  var loading = true.obs;

  Future<void> getListWifi() async {
    listWifi.clear();
    // connectedWifi.clear();
    loading.value = true;
    // await Future.delayed(const Duration(seconds: 1));
    final response = await mainBluetoothController
        .requestToServer('{"command": "show registered wifi"}');

    // print(response);
    GattResponse responseJson = GattResponse.fromJson(jsonDecode(response));
    if (responseJson.status == 'success') {
      // filter where connection state is true
      // connectedWifi.addAll(
      //     responseJson.payload.where((data) => data[3] == "true").toList());
      // print(connectedWifi);
      // filter where connection state is false
      listWifi.addAll(
          responseJson.payload.where((data) => data[3] == "false").toList());
      // print(listWifi);
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
    loading.value = false;
  }

  Future<void> stopScan() async {
    // final response =
    await mainBluetoothController
        .requestToServer('{"command": "wifi scan stop"}');

    // if (response != null) {
    //   GattResponse responseJson = GattResponse.fromJson(jsonDecode(response));
    //   if (responseJson.status == 'success') {
    //     print("berhasil");
    //     print(responseJson.payload);
    //   }
    // }

    // loading.value = false;
  }
}
