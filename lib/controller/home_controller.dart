import 'dart:convert';

import 'package:ble_get_server/class/gatt_response.dart';
import 'package:ble_get_server/controller/main_bluetooth_controller.dart';
import 'package:ble_get_server/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeControler {
  final mainBluetooth = MainBluetoothController.instance;
  var statusLed = "".obs;

  Future<void> testBluetooth() async {
    final response = await mainBluetooth
        .requestToServer('{"command":"tes connectifity bluetooth"}');

    GattResponse responseJson = GattResponse.fromJson(jsonDecode(response));
    if (responseJson.status == 'success') {
      statusLed.value = responseJson.payload['status'].toUpperCase();
    } else {
      statusLed.value = "";
      AppUtils.toastMessage(
          msg: responseJson.payload.toString(),
          bgColor: Colors.red,
          txtColor: Colors.white);
    }
  }
}
