import 'dart:convert';

import 'package:ble_get_server/class/gatt_response.dart';
import 'package:ble_get_server/controller/main_bluetooth_controller.dart';
import 'package:ble_get_server/views/list_wifi/list_wifi_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class AddWifiWithPasswordController {
  final passwordControler = TextEditingController().obs;
  final mainBluetoothController = MainBluetoothController.instance;

  Future<void> addWifi(argument, BuildContext context) async {
    String data =
        '{"command": "register wifi", "payload": {"ssid": "${argument[0]}", "bssid": "${argument[1]}", "password": "${passwordControler.value.text}"}}';

    final response = await mainBluetoothController.requestToServer(data);
    GattResponse responseJson = GattResponse.fromJson(jsonDecode(response));

    if (responseJson.status == 'success') {
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

    passwordControler.value.text = "";
  }
}
