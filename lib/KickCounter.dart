import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'databaseHelper.dart';
import 'ReportKickCounter.dart';

class KickCounter extends StatefulWidget {
  @override
  _KickCounterScreenState createState() => _KickCounterScreenState();
}

class _KickCounterScreenState extends State<KickCounter> {

  int Kickcount = 0;
  String firstKickTime = "";
  String lastKickTime= "";


  void kickcounter(){
    setState(() {
      Kickcount++;
      if(Kickcount==1){
        firstKickTime = DateFormat('HH:mm').format(DateTime.now());
      }
      else{
        lastKickTime = DateFormat('HH:mm').format(DateTime.now());
      }
    });
  }
  void kickReset(){
    setState(() {
      Kickcount=0;
      firstKickTime = "";
      lastKickTime="";
    });
  }

  void savekickCounts() async {
    final db = DatabaseHelper(); // Initialize the DatabaseHelper
    await db.insertKickCounter({
      DatabaseHelper.columnFirstTime: firstKickTime,
      DatabaseHelper.columnLastTime: lastKickTime,
      DatabaseHelper.columnkickcount: Kickcount,
      DatabaseHelper.columncurrectdate : DateFormat('dd:MM:yyyy').format(DateTime.now())
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('KickCounter saved successfully')),
      );
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving KickCounter: $error')),
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Kick Counter",
          style: TextStyle(
              color: Colors.black
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black45,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,  // To space the buttons evenly
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Your onPressed code here
                  },
                  icon: Icon(Icons.airline_seat_legroom_extra, color: Colors.white),
                  label: Text(
                    "Kick Counter",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.orange),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>ReportKickCounter()));
                  },
                  icon: Icon(Icons.data_exploration, color: Colors.white),
                  label: Text(
                    "Report",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.orange),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Your onPressed code here
                  },
                  icon: Icon(Icons.thumb_up, color: Colors.white),
                  label: Text(
                    "Tips",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.orange),
                  ),
                ),
              ],
            ),

            Padding(padding: EdgeInsets.only(left: 30.0,right: 30.0,top: 10.0),
            child: Text(
              "Tap the icon below when your baby kicks",
              style: TextStyle(
                color: Colors.black
              ),
            ),
            ),

            SizedBox(height: 20,),
            GestureDetector(
              onTap: (){
                kickcounter();
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/babyFeet.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              )

            ),


            SizedBox(height: 20,),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    SizedBox(height: 10.0,),
                    Text(
                      "$firstKickTime",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 14.0
                      ),
                    ),

                    Text(
                      "First Time",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0
                      ),
                    ),

                  ],
                ),

                Column(
                  children: [
                    Text(
                      "Today Total",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18.0
                      ),
                    ),

                    Text(
                      "$Kickcount",
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 22.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),

                  ],
                ),

                Column(
                  children: [
                    SizedBox(height: 10.0,),
                    Text(
                      "$lastKickTime",
                      style: TextStyle(
                          color: Colors.orange,
                          fontSize: 14.0
                      ),
                    ),

                    Text(
                      "Last Time",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0
                      ),
                    ),

                  ],
                ),
              ],
            ),
            
            SizedBox(height: 20,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: (){
                  kickReset();
                },
                    child: Text(
                      "Reset"
                    )
                ),

                ElevatedButton(onPressed: (){
                  savekickCounts();
                },
                    child: Text(
                        "Save"
                    )
                )
              ],
            )

          ],
        ),
      ),
    );
  }
}
