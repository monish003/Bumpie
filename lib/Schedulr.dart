import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'databaseHelper.dart';
import 'dart:convert';

class Schedulr extends StatefulWidget {
  @override
  SchedulrScreen createState() => SchedulrScreen();
}

class SchedulrScreen extends State<Schedulr> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  var titleController = TextEditingController();
  var descriptionContoller = TextEditingController();
  String formattedDate = "";
  Set<DateTime> _highlightedDates = {};
  List<Map<String, dynamic>> _appointments = [];


  @override
  void initState() {
    super.initState();
    _loadHighlightedDates();
  }

  Future<void> _loadHighlightedDates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? dateStrings = prefs.getStringList('highlighted_dates');
    if (dateStrings != null) {
      setState(() {
        _highlightedDates = dateStrings.map((dateStr) => DateTime.parse(dateStr)).toSet();
      });
    }
  }

  Future<void> _saveHighlightedDates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> dateStrings = _highlightedDates.map((date) => date.toIso8601String()).toList();
    await prefs.setStringList('highlighted_dates', dateStrings);
  }

  Future<void> _fetchAppointmentsForSelectedDate() async {
    if (_selectedDay != null) {
      final db = DatabaseHelper();
      String formattedDate = DateFormat('dd MMM, yyyy').format(_selectedDay!);
      List<Map<String, dynamic>> appointments = await db.getAppointementofday(formattedDate);

      setState(() {
        _appointments = appointments;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Schedulr",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.black45,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2022, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                formattedDate = _selectedDay != null
                    ? DateFormat('dd MMM, yyyy').format(_selectedDay!)
                    : 'No date selected';
                _fetchAppointmentsForSelectedDate();
                _showPopUpDialog(date: formattedDate);
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, date, _) {
                  if (_highlightedDates.contains(date)) {
                    return Container(
                      margin: const EdgeInsets.all(6.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.green, // Customize the highlight color here
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${date.day}',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
            if (_appointments != null && _appointments.isNotEmpty)
              ..._appointments.map((appointment) {
                return savedAppointments(
                  date: appointment['appointment_date'],
                  title: appointment['appointment_title'],
                  description: appointment['appointment_desc'],
                );
              }).toList(),
          ],
        ),
      ),
    );
  }

  Future<void> _showPopUpDialog({required String date}) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Color(0xFFFF9E80),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Container(
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.all(5.0),
            height: 400.0, // Increased height to accommodate the larger text field
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Add Appointment",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      "$date",
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 14.0,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
                Divider(color: Colors.black,),
                Container(
                  width: 50.0, // Set a fixed width for the Title TextField
                  child: TextField(
                    controller: titleController,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: "Title",
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black45),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black45),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Expanded( // Expands to fill the available space
                  child: TextField(
                    controller: descriptionContoller,
                    style: TextStyle(color: Colors.black),
                    maxLines: 10, // Allow for multiple lines
                    decoration: InputDecoration(
                      labelText: "Description",
                      hintText: "hello",
                      labelStyle: TextStyle(color: Colors.black),
                      alignLabelWithHint: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black45),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black45),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        saveAppointments();
                      },
                      child: Text(
                        "Save",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.black45),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void saveAppointments() async {
    final db = DatabaseHelper();
    if ((titleController.text.isNotEmpty) &&
        (descriptionContoller.text.isNotEmpty)) {
      await db.insertAppointements({
        DatabaseHelper.colappointmentDate: formattedDate,
        DatabaseHelper.colappointmentTitle: titleController.text.toString(),
        DatabaseHelper.colappointmentDescription:
        descriptionContoller.text.toString()
      }).then((value) {
        setState(() {
          _highlightedDates.add(_selectedDay!);
          _saveHighlightedDates(); // Save highlighted dates to SharedPreferences
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Appointments saved successfully')),
        );
        Navigator.pop(context);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving KickCounter: $error')),
        );
      });
      titleController.clear();
      descriptionContoller.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Title and description cannot be empty..')),
      );
    }
  }

  Container savedAppointments({required String date,required String title, required String description}) {
    return Container(
      padding: EdgeInsets.all(10.0),
      margin: EdgeInsets.all(10.0),
      width: double.infinity,
      height: 75,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: Colors.black45,
          )),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.add_alert),
            SizedBox(
              width: 10,
            ),
            Text(
              '$title',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0),
            ),
          ],
        ),
        Expanded(
          child: Text(
            '$description',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.normal,
                fontSize: 16.0),
            textAlign: TextAlign.start,
          ),
        )
      ]),
    );
  }



}
