import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ble_get_server/utils/utils.dart';
import 'package:ble_get_server/views/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class MainBluetoothController {
  BluetoothAdapterState? bluetoothStatus;
  BluetoothConnectionState? bluetoothConnectionStatus;
  BluetoothCharacteristic? dr;
  BluetoothCharacteristic? dt;
  BluetoothCharacteristic? dsu;
  StreamSubscription<List<int>>? dtSubs;
  StreamSubscription<List<int>>? dsuSubs;

  // monitoring observer variables
  Rx<BluetoothDevice?> deviceConnect = Rx<BluetoothDevice?>(null);
  var streamUpdateBluetoothMessage = "".obs;
  var isScan = false.obs;
  // var loadingNotify = false.obs;
  var processConnect = true.obs;

  static MainBluetoothController? _instance;

  MainBluetoothController._() {
    checkBluetooth();
  }

  static MainBluetoothController get instance {
    _instance ??= MainBluetoothController._();
    return _instance!;
  }

  // status bluetooth on app mobile
  void checkBluetooth() {
    FlutterBluePlus.adapterState.listen((BluetoothAdapterState state) {
      bluetoothStatus = state;
    });
  }

  // status stream update
  Future<void> streamUpdateBluetooth(characteristic) async {
    if (bluetoothStatus == BluetoothAdapterState.off) {
      Fluttertoast.showToast(
          msg: "Bluetooth Mati !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return;
    }
    dsu = characteristic;
    await dsu?.setNotifyValue(true);
    dsuSubs = dsu?.onValueReceived.listen((value) async {
      // process connection finished
      processConnect.value = false;
      // debugPrint(String.fromCharCodes(value));
      streamUpdateBluetoothMessage.value = String.fromCharCodes(value);
    });

    // listening status bluetooth connection on device
    deviceConnect.value?.connectionState
        .listen((BluetoothConnectionState state) async {
      bluetoothConnectionStatus = state;
    });
  }

  // scan device and connect device
  Future<void> scanBluetooth(BuildContext context) async {
    // jika bluetooth mati maka hidupkan
    if (bluetoothStatus == BluetoothAdapterState.off) {
      if (Platform.isAndroid) {
        await FlutterBluePlus.turnOn();
      }
    }

    if (deviceConnect.value != null) {
      await deviceConnect.value?.disconnect();
    }

    // process connection started
    processConnect.value = true;
    // Start scanning
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
    // monitoring status scanning
    StreamSubscription<bool>? subscribeScanning;
    subscribeScanning = FlutterBluePlus.isScanning.listen((isScanning) async {
      isScan.value = isScanning;
      if (isScanning == false && deviceConnect.value == null) {
        await subscribeScanning?.cancel();

        AppUtils.toastMessage(
            msg: "Perangkat ble1 tidak ditemukan !",
            bgColor: Colors.red,
            txtColor: Colors.white);
      }
    });

    // This code to get characteristics ID from device
    StreamSubscription<List<ScanResult>>? subscription;
    subscription = FlutterBluePlus.scanResults.listen(
      (results) async {
        if (results.isNotEmpty) {
          ScanResult r = results.last; // the most recently found device
          if (r.advertisementData.advName == "ble1") {
            deviceConnect.value = r.device;

            await subscription?.cancel();
            await deviceConnect.value?.connect();
            await deviceConnect.value?.requestMtu(500);

            List<BluetoothService> services =
                await deviceConnect.value!.discoverServices();
            for (BluetoothService service in services) {
              for (BluetoothCharacteristic characteristic
                  in service.characteristics) {
                if (characteristic.uuid.toString() ==
                    '9743963e-2116-427e-8fd0-96f7dee9d2a1') {
                  dr = characteristic;
                }
                if (characteristic.uuid.toString() ==
                    '9743963e-2116-427e-8fd0-96f7dee9d2a2') {
                  dt = characteristic;
                }
                if (characteristic.uuid.toString() ==
                    '9743963e-2116-427e-8fd0-96f7dee9d2a3') {
                  streamUpdateBluetooth(characteristic);
                }
              }
            }
          }
        }
      },
    );
  }

  // request to server
  Future<dynamic> requestToServer(String msg) async {
    try {
      // print("================================================");
      // print(bluetoothConnectionStatus);
      // print("================================================");
      if (bluetoothConnectionStatus == BluetoothConnectionState.disconnected) {
        AppUtils.toastMessage(
            msg: "Perangkat Terputus !",
            bgColor: Colors.red,
            txtColor: Colors.white);

        deviceConnect.value = null;
        Get.offAll(() => const HomeScreen());
        return;
      }

      if (bluetoothStatus == BluetoothAdapterState.off) {
        AppUtils.toastMessage(
            msg: "Bluetooth Mati !",
            bgColor: Colors.red,
            txtColor: Colors.white);
        return;
      }
      await dt?.setNotifyValue(true);
      await dr?.write(utf8.encode(msg));

      Completer<dynamic> completer = Completer<dynamic>();
      dtSubs = dt?.onValueReceived.listen((value) async {
        if (value.isNotEmpty) {
          completer.complete(String.fromCharCodes(value));
          await dtSubs?.cancel();
        }
      });

      // Additional condition to wait until loading is false
      // while (loadingNotify.value) {
      //   await Future.delayed(
      //       const Duration(milliseconds: 100)); // Adjust the delay as needed
      // }

      try {
        // Wait for the completion of the listener
        return await completer.future;
      } finally {
        //  Ensure that the listener is canceled even if an exception occurs
        await dtSubs?.cancel();
      }
    } catch (e) {
      AppUtils.toastMessage(
          msg: "Perangkat Mati !", bgColor: Colors.red, txtColor: Colors.white);

      await deviceConnect.value?.disconnect();
      deviceConnect.value = null;
      Get.offAll(() => const HomeScreen());
      return;
    }
  }

  // disconnect form device
  Future<void> disconnectBluetooth() async {
    await deviceConnect.value?.disconnect();
    deviceConnect.value = null;
  }
}
