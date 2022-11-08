import 'package:flutter/material.dart';
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
      body: Center(
        child:
        Text("77",
        style: TextStyle(
          color: Colors.black
        ),)
      ),
      bottomNavigationBar:SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (i) { setState(() => _currentIndex = i);
        if(_currentIndex==1)
          {
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Scanner()),
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
    );
  }
}
