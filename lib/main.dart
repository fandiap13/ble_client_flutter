import 'package:ble_get_server/views/add_wifi/add_wifi_screen.dart';
import 'package:ble_get_server/views/add_wifi_manual/add_wifi_manual_screen.dart';
import 'package:ble_get_server/views/add_wifi_with_password/add_wifi_with_password_screen.dart';
import 'package:ble_get_server/views/change_password_wifi/change_password_wifi_screen.dart';
import 'package:ble_get_server/views/detail_wifi/detail_wifi_screen.dart';
import 'package:ble_get_server/views/home/home_screen.dart';
import 'package:ble_get_server/views/list_wifi/list_wifi_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Testing Server BLE',
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
      routes: {
        HomeScreen.routeName: (context) => const HomeScreen(),
        ListWifiScreen.routeName: (context) => const ListWifiScreen(),
        DetailWifiScreen.routeName: (context) => const DetailWifiScreen(),
        AddWifiScreen.routeName: (context) => const AddWifiScreen(),
        AddWifiWithPasswordScreen.routeName: (context) =>
            const AddWifiWithPasswordScreen(),
        AddWifiManualScreen.routeName: (context) => const AddWifiManualScreen(),
        ChangePasswordWifiScreen.routeName: (context) =>
            const ChangePasswordWifiScreen(),
      },
    );
  }
}
