import 'package:flutter/material.dart';
import 'package:bumpie/databaseHelper.dart';
import 'main.dart';

class profile extends StatefulWidget {
  @override
  _ProfileScreen createState() => _ProfileScreen();
}

class _ProfileScreen extends State<profile> {
  final db = DatabaseHelper();
  List<Map<String, dynamic>>? profileData;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final data = await db.getProfile();

    if (data != null && data.isNotEmpty) {
      setState(() {
        profileData = data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Profile",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.black45,
      ),
      body: profileData == null || profileData!.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              color: Colors.black45,
              elevation: 0.0,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Baby Image
                      CircleAvatar(
                        radius: 60.0,
                        backgroundImage:
                        AssetImage('assets/maternity-care.png'), // Replace with your image asset
                      ),
                      SizedBox(height: 20),

                      // Display name
                      Text(
                        profileData![0][DatabaseHelper.columnName]?.toString() ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10),

                      // Display pregnancy details
                      Text(
                        "${profileData![0][DatabaseHelper.columnPregnancyFrom]?.toString() ?? ''} | Expected Day: ${profileData![0][DatabaseHelper.columnExpectedDay]?.toString() ?? ''}",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 5),

                      Text(
                        "${profileData![0][DatabaseHelper.columnBio]?.toString()??''}",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.email, color: Colors.black54),
                    title: Text("Email"),
                    subtitle: Text(profileData![0][DatabaseHelper.columnEmail]?.toString() ?? ''),
                  ),
                  Divider(),

                  ListTile(
                    leading: Icon(Icons.phone, color: Colors.black54),
                    title: Text("Phone Number"),
                    subtitle: Text(profileData![0][DatabaseHelper.columnPhoneNumber]?.toString() ?? ''),
                  ),
                  Divider(),

                  ListTile(
                    leading: Icon(Icons.cake, color: Colors.black54),
                    title: Text("Date of Birth"),
                    subtitle: Text(profileData![0][DatabaseHelper.columnDob]?.toString() ?? ''),
                  ),
                  Divider(),

                  ListTile(
                    leading: Icon(Icons.favorite, color: Colors.black54),
                    title: Text("Health Condition"),
                    subtitle: Text(profileData![0][DatabaseHelper.columnBio]?.toString() ?? ''),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.exit_to_app, color: Colors.black54),
                    trailing: Icon(Icons.keyboard_arrow_right, color: Colors.black45),
                    title: Text("Logout"),
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
