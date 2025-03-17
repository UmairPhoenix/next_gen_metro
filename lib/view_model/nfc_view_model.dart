// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:nfc_manager/nfc_manager.dart';

// import '../utils/app_routes.dart';

// class NfcViewModel extends ChangeNotifier {
//   String tagId = '';
//   String tagData = '';
//   bool isSearchingTag = false;

//   Future<bool> _isNfcAvailable() async {
//     if (!await NfcManager.instance.isAvailable()) {
//       //---NFC is not Available on your device
//       Fluttertoast.showToast(msg: 'NFC is not enabled');
//       return false;
//     }
//     return true;
//   }

//   void startNfcSession(BuildContext context) async {
//     if (!await _isNfcAvailable()) {
//       //---If NFC is not available
//       return;
//     }
//     isSearchingTag = true;
//     Fluttertoast.showToast(msg: 'Searching for NFC tag');
//     notifyListeners();
//     NfcManager.instance.startSession(
//       onDiscovered: (NfcTag tag) async {
//         isSearchingTag = false;
//         notifyListeners();
//         tagData = _getStringPayload(
//           tag.data['ndef']['cachedMessage']['records'][0]['payload'],
//         );
//         tagId = _getTagId(tag.data['nfca']['identifier']);
//         //---Navigate to the NFC Screen
//         Navigator.pushNamed(
//           context,
//           Routes.nfcInfoPage,
//           arguments: {
//             'tagId': tagId,
//             'tagData': tagData,
//           },
//         );
//         await NfcManager.instance.stopSession();
//         notifyListeners();
//       },
//     );
//     notifyListeners();
//   }

//   void stopNfcSession() async {
//     await NfcManager.instance.stopSession();
//   }

//   String _getStringPayload(List<int> payload) {
//     const asciiDecoder = AsciiDecoder();
//     final result = asciiDecoder.convert(payload);
//     return result.replaceRange(0,3, '');
//   }

//   String _getTagId(List<int> id) {
//     String res = '';
//     for (int i = 0; i < id.length; i++) {
//       res = '$res${i == 0 ? '' : ':'}${id[i]}';
//     }
//     return res;
//   }
// }
