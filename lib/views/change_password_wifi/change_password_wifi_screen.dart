import 'package:ble_get_server/controller/change_password_wifi_controller.dart';
import 'package:flutter/material.dart';

class ChangePasswordWifiScreen extends StatelessWidget {
  const ChangePasswordWifiScreen({super.key});
  static String routeName = "/change_password_wifi";

  @override
  Widget build(BuildContext context) {
    final List argument = ModalRoute.of(context)?.settings.arguments as List;
    final changePassWifiC = ChangePasswordWifiController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(argument[0]),
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Mengubah password dari ${argument[0]}"),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    autofocus: true,
                    obscureText: true,
                    controller: changePassWifiC.passwordControler.value,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Password tidak boleh kosong";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(hintText: "Password"),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await changePassWifiC.changePassword(
                                context, argument);
                          }
                        },
                        child: const Text("Simpan")),
                  )
                ],
              ))),
    );
  }
}
