import 'dart:convert';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../scanner.dart';

class scan extends StatefulWidget {
  const scan({Key? key}) : super(key: key);

  @override
  State<scan> createState() => _scanState();
}

class _scanState extends State<scan> {
  ScanResult? scanResult;
  final _flashOnController = TextEditingController(text: 'Flash on');
  final _flashOffController = TextEditingController(text: 'Flash off');
  final _cancelController = TextEditingController(text: 'Cancel');

  final _aspectTolerance = 0.00;
  var _numberOfCameras = 0;
  final _selectedCamera = -1;
  final _useAutoFocus = true;
  final _autoEnableFlash = false;

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _numberOfCameras = await BarcodeScanner.numberOfCameras;
      setState(() {});
    });
    _scan();
  }

  Future<void> data(attendData) async {
    try {
      DateTime now = DateTime.now();
      DateTime noon = DateTime(now.year, now.month, now.day, 12, 0);

      if (now.isAfter(noon)) {
        FirebaseFirestore.instance
            .collection('hacktoberfest-2023')
            .doc(attendData)
            .update({
          "afternoon_checkin": "True",
          "afternoon_checkin_time": now,
        }).onError((error, stackTrace) => {throw "Error:$error"});
      }
      if (now.isBefore(noon)) {
        FirebaseFirestore.instance
            .collection('hacktoberfest-2023')
            .doc(attendData)
            .update({
          "morning_checkin": "True",
          "morning_checkin_time": now,
        }).onError((error, stackTrace) => {throw "Error:$error"});
      }
      Navigator.of(context).pop();
    } catch (e) {
      Navigator.of(context).pop();
    }
    //return _items;
  }

  @override
  Widget build(BuildContext context) {
    final scanResult = this.scanResult;
    if (scanResult != null) {
      data(scanResult.rawContent);
    }
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Center(
        child: LoadingAnimationWidget.twistingDots(
          leftDotColor: const Color(0xFF1A1A3F),
          rightDotColor: const Color(0xFFEA3799),
          size: 30,
        ),
      ),
    );
  }

  Future<void> _scan() async {
    try {
      final result = await BarcodeScanner.scan(
        options: ScanOptions(
          restrictFormat: selectedFormats,
          useCamera: _selectedCamera,
          autoEnableFlash: _autoEnableFlash,
          android: AndroidOptions(
            aspectTolerance: _aspectTolerance,
            useAutoFocus: _useAutoFocus,
          ),
        ),
      );
      setState(() => scanResult = result);
    } on PlatformException catch (e) {
      setState(() {
        scanResult = ScanResult(
          type: ResultType.Error,
          format: BarcodeFormat.unknown,
          rawContent: e.code == BarcodeScanner.cameraAccessDenied
              ? 'The user did not grant the camera permission!'
              : 'Unknown error: $e',
        );
      });
    }
  }
}
