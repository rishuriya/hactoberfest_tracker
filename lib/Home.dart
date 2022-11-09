import 'package:flutter/material.dart';
import 'package:hactoberfest_tracker/scan/scanning.dart';
import 'package:hactoberfest_tracker/scanner.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amber,
        body: Stack(
          children: [
            Center(
                child: Text(
                  "77",
                  style: Theme.of(context).textTheme.headline1,
                )),
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Scanner()),
              );
            }
            if(_currentIndex==1 ) {
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
              title: Text("Search"),
              selectedColor: Colors.orange,
            ),
          ],
        ));
  }
}
