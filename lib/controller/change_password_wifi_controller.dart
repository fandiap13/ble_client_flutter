import 'dart:convert';

import 'package:ble_get_server/class/gatt_response.dart';
import 'package:ble_get_server/controller/main_bluetooth_controller.dart';
import 'package:ble_get_server/views/detail_wifi/detail_wifi_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ChangePasswordWifiController {
  final passwordControler = TextEditingController().obs;
  final mainBluetoothController = MainBluetoothController.instance;

  Future<void> changePassword(BuildContext context, argument) async {
    String data =
        '{"command": "change password wifi", "payload": {"ssid": "${argument[0]}", "bssid": "${argument[1]}", "newPassword": "${passwordControler.value.text}"}}';

    final response = await mainBluetoothController.requestToServer(data);
    GattResponse responseJson = GattResponse.fromJson(jsonDecode(response));

    if (responseJson.status == 'success') {
      // ignore: use_build_context_synchronously
      Navigator.pushNamedAndRemoveUntil(
        context,
        DetailWifiScreen.routeName,
        (route) =>
            false, // This predicate determines when to stop removing routes
        arguments: argument,
      );

      Fluttertoast.showToast(
          msg: "Password wifi berhasil diubah !",
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
