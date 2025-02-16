import 'package:flutter/material.dart';

class CheckList extends StatefulWidget {
  @override
  CheckListScreen createState() => CheckListScreen();
}

class CheckListScreen extends State<CheckList> {
  Map<String, bool> firstCheckboxes = {
    "Schedule First Prenatal Visit": false,
    "Take Prenatal Vitamins": false,
    "Get Blood Work Done": false,
    "Nuchal Translucency Screening": false,
    "Start Tracking Kick Counts": false,
    "Genetic Screening Options" : false,

  };

  Map<String, bool> secondCheckboxes = {
    "Complete Anatomy Scan": false,
    "Glucose Screening": false,
    "Rhesus Factor Testing": false,
    "Register for Birth Classes": false,
    "Blood Pressure CheckUp" : false,
    "Quad Marker Screening" : false,
    "kick counts Screening" : false,
    "Pelvic Exam" : false
  };

  Map<String, bool> thirdCheckboxes ={
    "Group B Strep test" : false,
    "Fetal Monitoring" : false,
    "Blood pressure and urine test" : false,
    "plan for labor" : false,
    "Discuss delivery plan" : false,
    "Cervical checkups" : false
  };

  bool isFirstListVisible = false;
  bool isSecondListVisible = false;
  bool isthirdListVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Health CheckUps",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.black45,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            trimesterCheckList(
              title: "First Trimester (Weeks 1-12)",
              checkboxes: firstCheckboxes,
              isListVisible: isFirstListVisible,
              toggleVisibility: () {
                setState(() {
                  isFirstListVisible = !isFirstListVisible;
                });
              },
            ),
            trimesterCheckList(
              title: "Second Trimester (Weeks 13-26)",
              checkboxes: secondCheckboxes,
              isListVisible: isSecondListVisible,
              toggleVisibility: () {
                setState(() {
                  isSecondListVisible = !isSecondListVisible;
                });
              },
            ),

            trimesterCheckList(
              title: "Third Trimester (Weeks 27-40)",
              checkboxes: thirdCheckboxes,
              isListVisible: isthirdListVisible,
              toggleVisibility: () {
                setState(() {
                  isthirdListVisible = !isthirdListVisible;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Container trimesterCheckList({
    required String title,
    required Map<String, bool> checkboxes,
    required bool isListVisible,
    required VoidCallback toggleVisibility,
  }) {
    return Container(
      margin: EdgeInsets.all(5.0),
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.black45,
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
                textAlign: TextAlign.start,
              ),
              Row(
                children: [
                  Text(
                    "${checkboxes.length} Tasks",
                    style: TextStyle(
                      color: Colors.black45,
                      fontSize: 14.0,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  GestureDetector(
                    onTap: toggleVisibility,
                    child: Icon(
                      isListVisible
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Visibility(
            visible: isListVisible,
            child: ListView(
              padding: EdgeInsets.all(2.0),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: checkboxes.keys.map((String key) {
                return CheckboxListTile(
                  activeColor: Colors.green,
                  title: Text(
                    key,
                    style: TextStyle(
                      decoration: checkboxes[key]!
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  value: checkboxes[key],
                  onChanged: (bool? value) {
                    setState(() {
                      checkboxes[key] = value ?? false;
                    });
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
