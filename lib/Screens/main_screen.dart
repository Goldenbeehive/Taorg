import 'package:flutter/material.dart';
import 'package:torg/Screens/home_screen.dart';
import 'package:torg/Screens/settings_screen.dart';
import 'package:torg/Screens/tasks_by_date_screen.dart';

class MainScreen extends StatefulWidget {
  final String name;

  const MainScreen({super.key, required this.name});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int screen = 0;
  @override
  Widget build(BuildContext context) {
    switch (screen) {
      case 0:
        return Scaffold(
            body:
                SafeArea(child: Stack(children: [HomeScreen(name: widget.name), bottomMenu()])));
      case 1:
        return Scaffold(
            body: SafeArea(
              child: Column(
                  children: [const TasksByDateScreen(), bottomMenuForScreen2()]),
            ));
      case 2:
        return Scaffold(
            body: SafeArea(child: Stack(children: [const SettingsScreen(), bottomMenu()])));
      default:
        return Scaffold(
            body:
                SafeArea(child: Stack(children: [HomeScreen(name: widget.name), bottomMenu()])));
    }
  }

  Widget bottomMenuForScreen2() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromARGB(225, 228, 228, 255),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      screen = 0;
                    });
                  },
                  icon: const Icon(Icons.home)),
            ),
            Expanded(
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      screen = 1;
                    });
                  },
                  icon: const Icon(Icons.calendar_month)),
            ),
            Expanded(
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      screen = 2;
                    });
                  },
                  icon: const Icon(Icons.settings)),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomMenu() {
    return Positioned(
      left: 16,
      right: 16,
      bottom: 30,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: const Color.fromARGB(225, 228, 228, 255),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      screen = 0;
                    });
                  },
                  icon: const Icon(Icons.home)),
            ),
            Expanded(
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      screen = 1;
                    });
                  },
                  icon: const Icon(Icons.calendar_month)),
            ),
            Expanded(
              child: IconButton(
                  onPressed: () {
                    setState(() {
                      screen = 2;
                    });
                  },
                  icon: const Icon(Icons.settings)),
            ),
          ],
        ),
      ),
    );
  }
}
