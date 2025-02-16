import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'PreggoTracker.dart';
import 'Schedulr.dart';
import 'preggohub.dart';
import 'editProfile.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    dashboard(),
    PreggoTracker(),
    Schedulr(),
    preggohub(),
    editProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar:_customBar(context)
    );
  }

  Container _customBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.black45,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(
              icon: Icons.dashboard_rounded,
              label: "Home",
              onPressed: () {},
              iconcolor: Colors.blue
          ),
          _buildNavItem(
              icon: Icons.track_changes,
              label: "PreggoTrack",
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>PreggoTracker()
                    )
                );
              },
              iconcolor: Colors.white

          ),
          _buildNavItem(
              icon: Icons.schedule,
              label: "Schedulr",
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Schedulr()));
              },
              iconcolor: Colors.white
          ),
          _buildNavItem(
              icon: Icons.book_rounded,
              label: "PreggoHub",
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>preggohub()));

              },
              iconcolor: Colors.white
          ),
          _buildNavItem(
              icon: Icons.settings,
              label: "Settings",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => editProfile()),  // Adjust if necessary
                );
              },
              iconcolor: Colors.white
          ),
        ],
      ),
    );
  }

  Column _buildNavItem({required IconData icon, required String label, required VoidCallback onPressed, required Color iconcolor}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: onPressed,
          icon: Icon(icon, color: iconcolor, size: 30.0),
        ),
        Text(label, style: TextStyle(fontSize: 13, color: Colors.white)),
      ],
    );
  }
}
