import 'package:ble_get_server/controller/detail_wifi_controller.dart';
import 'package:ble_get_server/views/change_password_wifi/change_password_wifi_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailWifiScreen extends StatefulWidget {
  const DetailWifiScreen({super.key});

  static String routeName = "/detail_wifi";

  @override
  State<DetailWifiScreen> createState() => _DetailWifiScreenState();
}

class _DetailWifiScreenState extends State<DetailWifiScreen> {
  final detailWifiC = DetailWifiController();

  @override
  Widget build(BuildContext context) {
    detailWifiC.arguments
        .addAll(ModalRoute.of(context)?.settings.arguments as List);

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text("Detail ${detailWifiC.arguments[0]}")),
      ),
      body: Obx(() {
        if (detailWifiC.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        bool prioritas = bool.parse(detailWifiC.arguments[2]);
        bool connectionStat = bool.parse(detailWifiC.arguments[3]);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Pengaturan",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton.icon(
                  onPressed: () {
                    Navigator.pushNamed(
                        context, ChangePasswordWifiScreen.routeName,
                        arguments: detailWifiC.arguments);
                  },
                  icon: const Icon(Icons.edit),
                  label: const Text("Ubah Password")),
              TextButton.icon(
                  onPressed: () async {
                    if (connectionStat) {
                      await detailWifiC.reconnectWIFI(context);
                    } else {
                      await detailWifiC.connectWIFI(context);
                    }
                  },
                  icon: Icon(connectionStat
                      ? Icons.refresh_outlined
                      : Icons.wifi_outlined),
                  label: Text(
                      connectionStat ? "Sambungkan Ulang" : "Sambungkan WiFi")),
              TextButton.icon(
                  onPressed: () async {
                    if (!prioritas) {
                      await detailWifiC.setPriorityWIFI(context);
                    } else {
                      await detailWifiC.removePriorityWIFI(context);
                    }
                  },
                  icon: Icon(prioritas
                      ? Icons.remove_circle_outline_rounded
                      : Icons.star_rounded),
                  label: Text(
                      prioritas ? "Hapus Prioritas" : "Jadikan Prioritas")),
              if (connectionStat == true)
                // jika koneksi masih tersambung putuskan jaringan akan mucul
                TextButton.icon(
                    onPressed: () async {
                      await detailWifiC.disconnectWIFI(context);
                    },
                    icon: const Icon(Icons.wifi_off_rounded),
                    label: const Text("Putuskan Jaringan Ini")),
              TextButton.icon(
                  onPressed: () async {
                    await detailWifiC.forgetWIFI(context);
                  },
                  icon: const Icon(Icons.remove_circle_rounded),
                  label: const Text("Hapus Jaringan Ini")),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Status WiFi",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text("Tersambung, Tidak ada internet !")
            ],
          ),
        );
      }),
    );
  }
}
