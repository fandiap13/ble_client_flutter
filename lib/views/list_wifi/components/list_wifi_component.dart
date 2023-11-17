import 'package:ble_get_server/controller/list_wifi_controller.dart';
import 'package:ble_get_server/views/detail_wifi/detail_wifi_screen.dart';
import 'package:ble_get_server/views/list_wifi/components/wifi_connection_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListWifiComponent extends StatelessWidget {
  const ListWifiComponent({
    super.key,
    required this.listWifiController,
  });

  final ListWifiController listWifiController;

  @override
  Widget build(BuildContext context) {
    return CupertinoScrollbar(
      child: Obx(
        () => ListView.builder(
          itemCount: listWifiController.listWifi.length,
          itemBuilder: (context, index) {
            var data = listWifiController.listWifi[index];
            bool connectionStat = bool.parse(data[3]);
            return ListTile(
              title: Text(data[0]),
              subtitle: WifiConnectionText(status: connectionStat),
              trailing: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, DetailWifiScreen.routeName,
                      arguments: data);
                },
                child: const Icon(
                  Icons.info_outline_rounded,
                  size: 30,
                  color: Colors.blue,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
