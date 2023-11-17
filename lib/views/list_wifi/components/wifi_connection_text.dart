import 'package:flutter/material.dart';

class WifiConnectionText extends StatelessWidget {
  const WifiConnectionText({
    super.key,
    required this.status,
  });

  final bool status;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          status ? Icons.wifi_rounded : Icons.wifi_off_rounded,
          size: 20,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(status ? "Tersambung" : "Tidak tersambung"),
      ],
    );
  }
}
