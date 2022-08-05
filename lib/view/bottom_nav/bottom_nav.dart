// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:gis_tetebatu/view/wisata/favorit.dart';

import '../../constant.dart';
import '../gmap/map.dart';
import '../wisata/home.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  BottomNavState createState() => BottomNavState();
}

class BottomNavState extends State<BottomNav> {
  int selectedIndex = 0;
  final widgetOptions = [
    const HomePage(),
    const Favorite(),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: kblue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MapsNew(),
                ),
              );
            },
            child: const Icon(Icons.location_on_rounded)),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Center(
          child: widgetOptions.elementAt(selectedIndex),
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            // sets the background color of the `BottomNavigationBar`
            canvasColor: Colors.white,
            // sets the active color of the `BottomNavigationBar` if `Brightness` is light
          ),
          child: BottomNavigationBar(
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home_sharp), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_sharp), label: 'Favorite'),
            ],
            currentIndex: selectedIndex,
            selectedItemColor: kblue,
            onTap: onItemTapped,
          ),
        ),
      ),
      behavior: HitTestBehavior.translucent,
    );
  }

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}
