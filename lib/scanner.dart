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
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'list/list.dart';

class Scanner extends StatefulWidget {
  const Scanner({Key? key}) : super(key: key);

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  ScanResult? scanResult;
  var _selectedDate=DateTime.now();
  int _selectedIndex =0;
  final List<String> _options = ['Present', 'Absent', 'Both'];
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
    Future.delayed(Duration.zero, () async {
      _numberOfCameras = await BarcodeScanner.numberOfCameras;
      setState(() {});
    });
  }

  List _items = [];
  Future<void> getcsv() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
    ].request();
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("Name");
    row.add("Email");
    row.add("Morning-Session");
    row.add("Afternoon-Session");
    rows.add(row);
    var i = 1;
    var collection_std =
        FirebaseFirestore.instance.collection('hacktober-2022');
    var querySnapshot_std = await collection_std.get();
    for (var queryDocumentSnapshot in querySnapshot_std.docs) {
      var data_std = queryDocumentSnapshot.data();
      if(data_std["Morning-Session"]=="Attended" || data_std["Afternoon-Session"]=="Attended") {
        List<dynamic> row = [];
        row.add(data_std['Name']);
        row.add(data_std['Email']);
        row.add(data_std['Morning-Session']);
        row.add(data_std['Afternoon-Session']);
        rows.add(row);
        //print(rows);
      }
      //print(i);
      i++;
    }
//store file in documents folder

    String? csv;
// convert rows to String and write as csv file
    csv = const ListToCsvConverter().convert(rows);
    file(csv);

  }
  Future<void> file(name) async {
    print(name);
    String dir =
        "${(await getExternalStorageDirectory())?.absolute.path!}/";
    //print(dir);
    String file = "$dir";
    File f = File(file + "filename.csv");
    var t = await f.writeAsString(name);
    print(t);
  }
//Fetch content from the json file
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
//         "id":_items[i]["id"],
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
    final jsondata = await json.decode(attendData);
    DateTime time = DateTime.now();
    DateTime dt2 = DateTime.parse("2022-10-23 12:00:00");
    print(time);
    print(jsondata["id"]);
    // setState(() {
    //   _items = data["key"];
    // });
    if (time.isBefore(dt2)) {
      print("hello");
      FirebaseFirestore.instance
          .collection('hacktober-2022')
          .doc(jsondata["email"])
          .update({
        "Morning-Session": "Attended",
        "Morning-checkin":time,
      }).onError((error, stackTrace) => {
         throw "Error:$error"
      });
      //return _items;
    } else {
      print(dt2.isBefore(DateTime.now()));
      FirebaseFirestore.instance
          .collection('hacktober-2022')
          .doc(jsondata["email"])
          .update({"Afternoon-Session": "Attended",
      "Afternoon-checkin":time}).onError((error, stackTrace) => {
        throw "Error:$error"
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var _currentIndex=1;
    final scanResult = this.scanResult;
    if (scanResult != null) {
      data(scanResult.rawContent);
    }
    var _choiceIndex;
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
              const SizedBox(height: 15),
              Padding(
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
                    return DropdownMenuItem(value: items, child: Text(items));
                  }).toList(),
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
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                ),
                child: Column(children: [
                  Package_list(dropdownvalue_class),
                ]),
              ),
            ],
          ),

        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            await getcsv();
          },
          icon: const Icon(Icons.save),
          label: const Text("Save"),
        ),
          bottomNavigationBar:SalomonBottomBar(
            currentIndex: _currentIndex,
            onTap: (i) { setState(() => _currentIndex = i);
            if(_currentIndex==1 || _currentIndex==0 )
            {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Home()),
              );
            }},
            items: [
              /// Home
              SalomonBottomBarItem(
                icon: Icon(Icons.home),
                title: Text("Home"),
                selectedColor: Colors.purple,
              ),

              /// Likes
              SalomonBottomBarItem(
                icon: Icon(Icons.favorite_border),
                title: Text("Likes"),
                selectedColor: Colors.pink,
              ),

              /// Search
              SalomonBottomBarItem(
                icon: Icon(Icons.search),
                title: Text("Search"),
                selectedColor: Colors.orange,
              ),
            ],
          )
      ),
    );
  }
  Widget _buildChips() {
    List<Widget> chips = [];

    for (int i = 0; i < _options.length; i++) {
      ChoiceChip choiceChip = ChoiceChip(
        selected: _selectedIndex == i,
        label: Text(_options[i], style: TextStyle(color: _selectedIndex == i ?Colors.white:Colors.black)),
        avatar: _selectedIndex == i ? const Icon(Icons.radio_button_checked):const Icon(Icons.radio_button_unchecked),
        elevation: 2,
        pressElevation: 5,
        shadowColor: Colors.blue,
        backgroundColor: Colors.grey.shade300,
        selectedColor: Colors.blue,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedIndex = i;
            }
          });
        },
      );

      chips.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: choiceChip
          )
      );
    }

    return Center(
      child: Wrap(
        // This next line does the trick.
        spacing: 1,
        children: chips,
      ),
    );
  }
  Widget buildDateField(BuildContext context){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat('dd-MM-yyyy').format(_selectedDate),
                style: TextStyle(
                    fontSize: 28,
                  fontWeight: FontWeight.w400
                ),
              ),

              TextButton(
                child: const Icon(Icons.calendar_today_sharp, color: Colors.blue,),
                onPressed: () async{
                  final currentDate = DateTime.now();
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: currentDate,
                    firstDate: currentDate,
                    lastDate: DateTime(currentDate.year+5),
                  );
                  setState(() {
                    if(selectedDate != null){
                      _selectedDate = selectedDate;
                    }
                  });
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
