import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'list/list.dart';
class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  State<Scanner> createState() => _ScannerState();
}
class _ScannerState extends State<Scanner> {
  ScanResult? scanResult;
  String dropdownvalue_class = '___Select___';
  var batch =  ["___Select___","Morning","Afternoon","Both"];
  final _flashOnController = TextEditingController(text: 'Flash on');
  final _flashOffController = TextEditingController(text: 'Flash off');
  final _cancelController = TextEditingController(text: 'Cancel');
  DateTime time=DateTime.now();
  DateTime dt2 = DateTime.parse("2022-10-22 21:00:00");
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
  }
  List _items = [];

// Fetch content from the json file
//   Future<void> readJson() async {
//     final String response = await rootBundle.loadString('assets/file.json');
//     final data = await json.decode(response);
//     setState(() {
//       _items = data["items"];
//     });
//     for (int i=0;_items.length>i;i++) {
//       FirebaseFirestore.instance
//           .collection('hacktober-2022').doc(_items[i]["email"])
//           .set({
//         "Name":_items[i]["name"],
//         "Email": _items[i]["email"],
//         //"RollNo": _items[i]["formData"]["rollNo"],
//         "Morning-Session":"",
//         "Afternoon-Session":""
//       });
//
//     }
//     //print(_items[0]["formData"][0]["gender"]);
//   }

  Future<void> data(attendData) async {
    final jsondata=await json.decode(attendData);

    print(jsondata["id"]);
     // setState(() {
     //   _items = data["key"];
     // });
     if(dt2.isBefore(DateTime.now())) {
       FirebaseFirestore.instance
           .collection('hacktober-2022').doc(jsondata["email"])
           .update({
           "Morning-Session":"Attended",
       });
       //return _items;
     }
     else{
       FirebaseFirestore.instance
           .collection('hacktober-2022').doc(jsondata["email"])
           .update({
         "Afternoon-Session":"Attended"
       });
     }
  }
  @override
  Widget build(BuildContext context) {
    final scanResult = this.scanResult;
    if(scanResult!=null) {
      data(scanResult.rawContent);
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Hacktober Attendence'),
          actions: [
            IconButton(
              icon: const Icon(Icons.camera),
              tooltip: 'Scan',
              onPressed: _scan,
            )
          ],
        ),
        body: SingleChildScrollView(
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
              children:[
                SizedBox(
                  height: 20,
                ),Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16),
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0))),
                    ),
                    value: dropdownvalue_class,
                    hint: const Text("Source"),
                    icon: Icon(Icons.keyboard_arrow_down),

                    items: batch.map((String items) {
                      return DropdownMenuItem(
                          value: items,
                          child: Text(items)
                      );
                    }
                    ).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        parcel.clear();
                        dropdownvalue_class = newValue.toString();
                      });
                    },

                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16,),
                  child: Column(
                      children:[Package_list(dropdownvalue_class),
                      Text("data")]
                  ),
                ),
              ],
          ),
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
          autoEnableFlash:_autoEnableFlash,
          android:AndroidOptions(
            aspectTolerance:_aspectTolerance,
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