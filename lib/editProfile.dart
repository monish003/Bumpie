import 'package:flutter/material.dart';
import 'DatabaseHelper.dart';

class editProfile extends StatefulWidget {
  @override
  _EditProfileScreen createState() => _EditProfileScreen();
}

class _EditProfileScreen extends State<editProfile> {
  final db = DatabaseHelper();

  List<Map<String, dynamic>>? profileData;

  // TextEditingControllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();
  final TextEditingController healthConditionController = TextEditingController();
  final TextEditingController pregnancyFromController = TextEditingController();
  final TextEditingController expectedDayController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final data = await db.getProfile();

    if (data != null && data.isNotEmpty) {
      setState(() {
        profileData = data;
        // Load data into controllers
        nameController.text = profileData![0][DatabaseHelper.columnName] ?? '';
        dobController.text = profileData![0][DatabaseHelper.columnDob] ?? '';
        emailController.text = profileData![0][DatabaseHelper.columnEmail] ?? '';
        phoneNoController.text = profileData![0][DatabaseHelper.columnPhoneNumber] ?? '';
        pregnancyFromController.text = profileData![0][DatabaseHelper.columnPregnancyFrom] ?? '';
        expectedDayController.text = profileData![0][DatabaseHelper.columnExpectedDay] ?? '';
        bioController.text = profileData![0][DatabaseHelper.columnBio] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.black45,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              buildTextField("Name", "Enter your name", nameController),
              buildTextField("Phone number", "Enter your Phone Number", phoneNoController),
              buildTextField("Email", "Enter your Email", emailController),
              buildTextField("Date of Birth", "Enter your DOB", dobController),
              buildTextField("Pregnancy From", "Enter your Pregnancy Date", pregnancyFromController),
              buildTextField("Expected Day", "Enter your Expected Date", expectedDayController),
              buildTextField("Bio", "Short description about your health", bioController),
              Padding(
                padding: EdgeInsets.fromLTRB(30, 10, 30, 0),
                child: ElevatedButton(
                  onPressed: _saveProfile,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.black45),
                  ),
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.black, fontSize: 16.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding buildTextField(String label, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 5),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: hint,
              fillColor: Colors.black12,
              filled: true,
            ),
          ),
        ],
      ),
    );
  }

  void _saveProfile() async {
    await db.clearProfileTable();
    await db.insertProfile({
      DatabaseHelper.columnName: nameController.text,
      DatabaseHelper.columnPhoneNumber: phoneNoController.text,
      DatabaseHelper.columnEmail: emailController.text,
      DatabaseHelper.columnDob: dobController.text,
      DatabaseHelper.columnPregnancyFrom: pregnancyFromController.text,
      DatabaseHelper.columnExpectedDay: expectedDayController.text,
      DatabaseHelper.columnBio: bioController.text,
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile saved successfully')),
      );
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile: $error')),
      );
    });
  }
}
