// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';

// class ListBluetooth extends StatefulWidget {
//   const ListBluetooth({super.key});

//   @override
//   State<ListBluetooth> createState() => _ListBluetoothState();
// }

// class _ListBluetoothState extends State<ListBluetooth> {
//   BluetoothDevice? deviceConnect;
//   BluetoothCharacteristic? dr;
//   BluetoothCharacteristic? dt;
//   BluetoothCharacteristic? dsu;
//   String? commandMessage;
//   String? statusBluetoothMessage;

//   StreamSubscription<List<int>>? dtSubs;
//   StreamSubscription<List<int>>? dsuSubs;
//   bool? _isScan;

//   Future<void> statusBluetooth(characteristic) async {
//     setState(() {
//       dsu = characteristic;
//     });

//     await dsu?.setNotifyValue(true);
//     dsuSubs = dsu?.onValueReceived.listen((value) async {
//       debugPrint(String.fromCharCodes(value));
//       setState(() {
//         statusBluetoothMessage = String.fromCharCodes(value);
//       });
//     });
//   }

//   Future<void> disconnectBluetooth() async {
//     // await charSubs?.cancel();
//     // await dt?.setNotifyValue(false);
//     await deviceConnect?.disconnect();
//     setState(() {
//       commandMessage = null;
//       deviceConnect = null;
//     });
//   }

//   Future<void> scanBluetooth(BuildContext context) async {
//     if (deviceConnect != null) {
//       await deviceConnect?.disconnect();
//     }

//     // Start scanning
//     FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

//     FlutterBluePlus.isScanning.listen((isScanning) {
//       setState(() {
//         _isScan = isScanning;
//       });
//       if (isScanning == false && deviceConnect == null) {
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: const Text('Terdapat Kesalahan !'),
//               content: const Text('Perangkat ble1 tidak ditemukan !'),
//               actions: [
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Text('OK'),
//                 ),
//               ],
//             );
//           },
//         );
//         return;
//       }
//     });

//     // Setup Listener for scan results.
//     StreamSubscription<List<ScanResult>>? subscription;
//     subscription = FlutterBluePlus.scanResults.listen(
//       (results) async {
//         if (results.isNotEmpty) {
//           ScanResult r = results.last; // the most recently found device
//           if (r.advertisementData.advName == "ble1") {
//             setState(() {
//               deviceConnect = r.device;
//             });

//             await subscription?.cancel();
//             await deviceConnect?.connect();
//             await deviceConnect?.requestMtu(512);

//             List<BluetoothService> services =
//                 await deviceConnect!.discoverServices();
//             for (BluetoothService service in services) {
//               for (BluetoothCharacteristic characteristic
//                   in service.characteristics) {
//                 if (characteristic.uuid.toString() ==
//                     '9743963e-2116-427e-8fd0-96f7dee9d2a1') {
//                   setState(() {
//                     dr = characteristic;
//                   });
//                 }
//                 if (characteristic.uuid.toString() ==
//                     '9743963e-2116-427e-8fd0-96f7dee9d2a2') {
//                   setState(() {
//                     dt = characteristic;
//                   });
//                 }
//                 if (characteristic.uuid.toString() ==
//                     '9743963e-2116-427e-8fd0-96f7dee9d2a3') {
//                   statusBluetooth(characteristic);
//                 }
//               }
//             }
//           }
//         }
//       },
//     );
//   }

//   Future<void> requestToServer(String msg) async {
//     setState(() {
//       commandMessage = null;
//     });

//     await dt?.setNotifyValue(true);
//     await dr?.write(utf8.encode(msg));
//     dtSubs = dt?.onValueReceived.listen((value) async {
//       debugPrint(String.fromCharCodes(value));
//       setState(() {
//         commandMessage = String.fromCharCodes(value);
//       });

//       if (commandMessage != null) {
//         await dtSubs?.cancel();
//       }
//     });
//   }

//   // Future<void> stopNotify() async {
//   //   await dtSubs?.cancel();
//   //   await dtSubs?.cancel();
//   //   await dt?.setNotifyValue(false);
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Builder(builder: (context) {
//         if (_isScan == true) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         return SafeArea(
//             child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const SizedBox(
//                 height: 20,
//               ),
//               Text(deviceConnect != null
//                   ? "${deviceConnect?.advName} is connected"
//                   : "App Not Connected"),
//               if (deviceConnect?.advName == "ble1")
//                 Column(
//                   children: [
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Text("Status Bluetooth: $statusBluetoothMessage"),
//                     const SizedBox(
//                       height: 20,
//                     ),

//                     // List wifi
//                     Column(
//                       children: [
//                         const Text("Wifi List:"),
//                         const SizedBox(
//                           height: 5,
//                         ),
//                         Text(
//                           "$commandMessage",
//                           textAlign: TextAlign.center,
//                         ),
//                       ],
//                     ),
//                     // End list wifi

//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Column(
//                       children: [
//                         ElevatedButton(
//                             onPressed: () async {
//                               await requestToServer(
//                                   '{"command": "tes connectifity bluetooth"}');
//                             },
//                             child: const Text("Scan WIFI")),
//                       ],
//                     ),
//                     // const SizedBox(
//                     //   height: 10,
//                     // ),
//                     // ElevatedButton(
//                     //     onPressed: () async {
//                     //       await stopNotify();
//                     //     },
//                     //     child: const Text("Stop Notify WIFI")),
//                   ],
//                 )
//             ],
//           ),
//         ));
//       }),
//       floatingActionButton: Builder(builder: (context) {
//         if (deviceConnect != null) {
//           return ElevatedButton(
//               onPressed: () async {
//                 await disconnectBluetooth();
//               },
//               child: const Text("Disconnect Bluetooth"));
//         }
//         return ElevatedButton(
//             onPressed: () async {
//               if (_isScan != true) {
//                 await scanBluetooth(context);
//               }
//             },
//             child:
//                 Text(_isScan == true ? "Connecting..." : "Connect Bluetooth"));
//       }),
//     );
//   }
// }
