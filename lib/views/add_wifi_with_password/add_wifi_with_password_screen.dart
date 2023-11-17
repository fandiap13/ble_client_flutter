import 'package:ble_get_server/controller/add_wifi_with_password_controller.dart';
import 'package:flutter/material.dart';

class AddWifiWithPasswordScreen extends StatelessWidget {
  const AddWifiWithPasswordScreen({super.key});
  static String routeName = "/add_wifi_with_password";

  @override
  Widget build(BuildContext context) {
    final List argument = ModalRoute.of(context)?.settings.arguments as List;
    final addWifiPass = AddWifiWithPasswordController();
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
                children: [
                  TextFormField(
                    autofocus: true,
                    obscureText: true,
                    controller: addWifiPass.passwordControler.value,
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
                            await addWifiPass.addWifi(argument, context);
                          }
                        },
                        child: const Text("Simpan")),
                  )
                ],
              ))),
    );
  }
}
