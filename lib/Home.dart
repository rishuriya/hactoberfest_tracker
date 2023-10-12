import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hactoberfest_tracker/scan/scanning.dart';
import 'package:hactoberfest_tracker/scanner.dart';
import 'package:intl/intl.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _currentIndex = 0;
  var count = 0;
  var num;
  var time = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    num = no();
  }

  Future<int> no() async {
    DateTime now = DateTime.now();
    DateTime noon = DateTime(now.year, now.month, now.day, 12, 0);
    var querySnapshot_std =
        await FirebaseFirestore.instance.collection("hacktoberfest-2023").get();
    for (var queryDocumentSnapshot in querySnapshot_std.docs) {
      var data_admin = queryDocumentSnapshot.data();
      if(now.isAfter(noon)) {
        if (data_admin["afternoon_checkin"] == "True") {
          count++;
        }
      }
      else if(now.isBefore(noon)){
        if (data_admin["morning_checkin"] == "True") {
          count++;
        }
      }
    }
    print(count);
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber,
        body: Stack(
          children: [
            Center(
              child: StreamBuilder<QuerySnapshot>(
                stream: () {
                  DateTime now = DateTime.now();
                  String fieldToCheck = now.hour >= 12 ? "afternoon_checkin" : "morning_checkin";

                  return FirebaseFirestore.instance
                      .collection("hacktoberfest-2023")
                      .where(fieldToCheck, isEqualTo: "True")
                      .snapshots();
                }(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error"),
                    );
                  }

                  if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasData && snapshot.connectionState == ConnectionState.active) {
                    return Text(
                      "${snapshot.data!.docs.length}",
                      style: Theme.of(context).textTheme.headline1,
                    );
                  }

                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 245),
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              ),
            ),
            // SizedBox(
            //   height: 20,
            // ),
            // Padding(padding: EdgeInsets.only(top: 25),child: Text("Students"),)
          ],
        ),
        bottomNavigationBar: SalomonBottomBar(
          currentIndex: _currentIndex,
          onTap: (i) {
            _currentIndex = i;
            if (_currentIndex == 2) {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const Scanner()),
              // );

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
        ));
  }
}
