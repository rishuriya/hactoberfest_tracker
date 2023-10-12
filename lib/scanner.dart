import 'dart:async';
import 'dart:convert';
import 'dart:io' show File, Platform;
import 'dart:typed_data';

import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hactoberfest_tracker/Home.dart';
import 'package:hactoberfest_tracker/scan/scanning.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'list/list.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  ScanResult? scanResult;
  var _selectedDate = DateTime.now();
  var date = DateTime.now();
  int _selectedIndex = 0;
  int _selectedIndexGender = 2;
  final List<String> _options = ['Present', 'Absent', 'Both'];
  final List<String> _gender = ['Male', 'Female', 'Both'];
  // final List work_date = [
  //   "09-11-22",
  //   "10-11-22",
  //   "11-11-22",
  //   "12-11-22",
  //   "13-11-22",
  //   "14-11-22",
  //   "15-11-22",
  //   "16-11-22",
  //   "17-11-22",
  //   "18-11-22",
  //   "19-11-22",
  //   "20-11-22",
  //   "21-11-22",
  //   "22-11-22",
  //   "23-11-22",
  //   "24-11-22",
  //   "25-11-22",
  //   "26-11-22",
  //   "27-11-22",
  //   "28-11-22",
  //   "29-11-22",
  //   "30-11-22",
  //   "01-12-22",
  //   "02-12-22",
  //   "03-12-22",
  //   "04-12-22",
  //   "05-12-22",
  //   "06-12-22",
  //   "07-12-22",
  //   "08-12-22",
  //   "09-12-22",
  //   "10-12-22",
  //   "11-12-22"
  // ];
  String dropdownvalue_class = '___Select___';
  var batch = ["___Select___", "Morning", "Afternoon", "Both"];
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
    //readJson();
    parcel.clear();
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
//       for(int i=0;_items.length>i;i++) {
//
//         FirebaseFirestore.instance
//             .collection('hacktoberfest-2023').doc(_items[i]["id"])
//             .update({
//           // "Gender":_items[i]["Gender"],
//           // "Hostel":_items[i]["Hostel"],
//           // "id": _items[i]["id"],
//           // "Name": _items[i]["Name"],
//           // "Email": _items[i]["Email"],
//           // "RollNo": _items[i]["RollNo"].toString(),
//           // "WhatsappNo": _items[i]["WhatsappNo"].toString(),
//           // "RoomNo":_items[i]["RoomNo"].toString()
//           // "Percentage":_items[i]["Percentage"],
//           // "Present":_items[i]["Present"],
//           // "10-12-22":_items[i]["10-22-22"],
//           "13-12-22":"False"
//         }).onError((error, stackTrace) => print(error));
// print(_items[i]["Name"]);
//     }
//
//   }

  @override
  Widget build(BuildContext context) {
    var _currentIndex = 2;
    final scanResult = this.scanResult;
    var _choiceIndex;
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.amber,
            title: const Text('amFOSS'),
          ),
          body: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              const SizedBox(
                height: 10,
              ),
              buildDateField(context),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 50,
                child: _buildChips(),
              ),
              const SizedBox(
                height: 15,
                child: Divider(
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 50,
                child: _genderChips(),
              ),
              const SizedBox(height: 15),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: Column(children: [
                  Package_list(_selectedIndex, _selectedIndexGender,
                      DateFormat('dd-MM-yy').format(_selectedDate)),
                ]),
              ),
            ],
          ),

          // floatingActionButton: FloatingActionButton.extended(
          //   onPressed: () async {
          //     await getcsv();
          //   },
          //   icon: const Icon(Icons.save),
          //   label: const Text("Save"),
          // ),
          bottomNavigationBar: SalomonBottomBar(
            currentIndex: _currentIndex,
            onTap: (i) {
              setState(() => _currentIndex = i);
              if (_currentIndex == 0) {
                Navigator.pop(context);
              }
              if (_currentIndex == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const scan()),
                );
              }
            },
            items: [
              /// Home
              SalomonBottomBarItem(
                icon: Icon(Icons.home),
                title: Text("Home"),
                selectedColor: Colors.purple,
              ),

              /// Likes
              SalomonBottomBarItem(
                icon: Icon(Icons.qr_code),
                title: Text("Scan"),
                selectedColor: Colors.pink,
              ),

              /// Search
              SalomonBottomBarItem(
                icon: Icon(Icons.data_usage_sharp),
                title: Text("Query"),
                selectedColor: Colors.orange,
              ),
            ],
          )),
    );
  }

  Widget _buildChips() {
    List<Widget> chips = [];

    for (int i = 0; i < _options.length; i++) {
      ChoiceChip choiceChip = ChoiceChip(
        selected: _selectedIndex == i,
        label: Text(_options[i],
            style: TextStyle(
                color: _selectedIndex == i ? Colors.white : Colors.black)),
        avatar: _selectedIndex == i
            ? const Icon(Icons.radio_button_checked)
            : const Icon(Icons.radio_button_unchecked),
        elevation: 2,
        pressElevation: 5,
        shadowColor: Colors.amber,
        backgroundColor: Colors.grey.shade300,
        selectedColor: Colors.amber,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedIndex = i;
            }
          });
          parcel.clear();
        },
      );

      chips.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: choiceChip));
    }

    return Center(
      child: Wrap(
        // This next line does the trick.
        spacing: 1,
        children: chips,
      ),
    );
  }

  Widget _genderChips() {
    List<Widget> chips = [];

    for (int i = 0; i < _gender.length; i++) {
      ChoiceChip choiceChip = ChoiceChip(
        selected: _selectedIndexGender == i,
        label: Text(_gender[i],
            style: TextStyle(
                color:
                    _selectedIndexGender == i ? Colors.white : Colors.black)),
        avatar: _selectedIndexGender == i
            ? const Icon(Icons.radio_button_checked)
            : const Icon(Icons.radio_button_unchecked),
        elevation: 2,
        pressElevation: 5,
        shadowColor: Colors.amber,
        backgroundColor: Colors.grey.shade300,
        selectedColor: Colors.amber,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedIndexGender = i;
            }
          });
          parcel.clear();
        },
      );

      chips.add(Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: choiceChip));
    }

    return Center(
      child: Wrap(
        // This next line does the trick.
        spacing: 1,
        children: chips,
      ),
    );
  }

  Widget buildDateField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('dd-MM-yyyy').format(_selectedDate),
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
              ),
              TextButton(
                child: const Icon(
                  Icons.calendar_today_sharp,
                  color: Colors.amber,
                ),
                onPressed: () async {
                  final currentDate = DateTime.now();
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: currentDate,
                    firstDate: DateTime(2022, 11),
                    lastDate: DateTime(currentDate.year + 5),
                    selectableDayPredicate: (DateTime val) =>
                                (val.year == 2023 &&
                                    val.day == 12 &&
                                    val.month == 10)
                            ? true
                            : false,
                  );
                  setState(() {
                    if (selectedDate != null) {
                      _selectedDate = selectedDate;
                    }
                  });
                  parcel.clear();
                },
              ),
            ],
          ),
          const Text(
            'Date',
            style: TextStyle(fontSize: 18.0),
          ),
        ],
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
