import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'profile.dart';
import 'editProfile.dart';
import 'package:health/health.dart';
import 'PreggoTracker.dart';
import 'Schedulr.dart';
import 'databaseHelper.dart';
import 'package:bumpie/preggohub.dart';
import 'package:shared_preferences/shared_preferences.dart';


class dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<dashboard> {
  List<FlSpot> weightData = [];
  double latestSystolic = 0;
  double latestDiastolic = 0;
  List<FlSpot> systolicData = [];
  List<FlSpot> diastolicData = [];
  String PregancyWeek='';
  String PregancyDay ='';
  String PregancyTremister='';
  final HealthFactory health = HealthFactory();
  int steps = 0;
  var weightController = TextEditingController();
  int pregnancyWeek = 0;

  void setHeaderData() async {
    DatabaseHelper db = DatabaseHelper();
    String pregnancyDate = await db.getPregnancyFrom();

    if (pregnancyDate != null && pregnancyDate.isNotEmpty) {
      DateTime pregnancyStartDate = DateTime.parse(pregnancyDate);
      DateTime currentDate = DateTime.now();
      int daysDifference = currentDate.difference(pregnancyStartDate).inDays;
       pregnancyWeek = (daysDifference / 7).floor();



      setState(() {
        PregancyWeek = "$pregnancyWeek";
        PregancyDay = "$daysDifference";

        if(pregnancyWeek<=12){
          PregancyTremister="1st Trimester";
        }else if(pregnancyWeek>=13 && pregnancyWeek<=26){
          PregancyTremister="2nd Trimester";
        }
        else{
          PregancyTremister="3rd Trimester";
        }
      });
    } else {
      setState(() {
        PregancyWeek = "0";
        PregancyDay ="0";
      });
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('currentweek', pregnancyWeek);
  }

  @override
  void initState() {
    super.initState();
    _initializeHealthKit();
    _loadWeightData();
    setHeaderData();
    _fetchWeightData();
  }

  Future<void> _initializeHealthKit() async {
    final types = [
      HealthDataType.STEPS,
      HealthDataType.WEIGHT,
      HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    ];
    final permissions = [
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
      HealthDataAccess.READ,
    ];

    bool permissionGranted = await health.requestAuthorization(types, permissions: permissions);
    if (permissionGranted) {
      _fetchStepsData();
      _fetchWeightData();
      _fetchBloodPressureData();
    } else {
      _showError("Authorization not granted");
    }
  }

  Future<void> _fetchStepsData() async {
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    try {
      int? stepData = await health.getTotalStepsInInterval(midnight, now);
      setState(() {
        steps = stepData ?? 0;
      });
    } catch (error) {
      _showError("Error fetching step data: $error");
    }
  }

  Future<void> _fetchWeightData() async {
    DateTime startDate = DateTime.now().subtract(Duration(days: 30)); // Last 30 days
    DateTime endDate = DateTime.now();
    List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(startDate, endDate, [HealthDataType.WEIGHT]);

    List<FlSpot> weightSpots = [];
    for (var dataPoint in healthData) {
      if (dataPoint.value != null) {
        weightSpots.add(FlSpot(
          (dataPoint.dateFrom.millisecondsSinceEpoch / (1000 * 60 * 60 * 24)).toDouble(),
          dataPoint.value as double,
        ));
      }
    }
    setState(() {
      weightData = weightSpots;
    });
  }

  Future<void> _fetchBloodPressureData() async {
    final now = DateTime.now();
    final oneWeekAgo = now.subtract(Duration(days: 7));

    List<HealthDataPoint> systolicPoints = await health.getHealthDataFromTypes(oneWeekAgo, now, [HealthDataType.BLOOD_PRESSURE_SYSTOLIC]);
    List<HealthDataPoint> diastolicPoints = await health.getHealthDataFromTypes(oneWeekAgo, now, [HealthDataType.BLOOD_PRESSURE_DIASTOLIC]);

    List<FlSpot> systolicData = [];
    List<FlSpot> diastolicData = [];
    double x = 0;

    for (int i = 0; i < systolicPoints.length; i++) {
      systolicData.add(FlSpot(x, systolicPoints[i].value as double));
      diastolicData.add(FlSpot(x, diastolicPoints[i].value as double));
      x += 1;
    }

    setState(() {
      this.systolicData = systolicData;
      this.diastolicData = diastolicData;
      latestSystolic = systolicPoints.isNotEmpty ? systolicPoints.last.value as double : 0;
      latestDiastolic = diastolicPoints.isNotEmpty ? diastolicPoints.last.value as double : 0;
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _refreshdata(){
    _fetchStepsData();
    _fetchBloodPressureData();
    _fetchWeightData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.black45,
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => profile()),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          _refreshdata();
        },
        child: Icon(Icons.refresh),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: Text(
                "$PregancyWeek weeks",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
              child: Text(
                "$PregancyTremister / $PregancyDay days",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
              child: LinearProgressIndicator(
                value:0.3,
                backgroundColor: Colors.grey[200],
                color: Colors.green,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 5, 20, 0),
              child: Text(
                "Wish you health on this wonderful journey..",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                ),
              ),
            ),
            Divider(),
            SizedBox(
              height: 270,  // Adjust height as needed
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  babyMetricGraph(title: "Bumpiee"),
                  //babyMetricGraph(title: "Size"),
                  babysize(title: "baby Size", img: 'assets/dark.jpg')
                 // babyMetricGraph(title: "Demo")
                  // Add other MetricGraph widgets as needed
                ],
              ),
            ),
            Row(
              children: [
                Expanded(child: calorieMetrics(heading: "Calories",percentage: 40)),
                Expanded(child: weightMetrics(heading: "Weight",weightData: weightData)),
              ],
            ),
            Row(
              children: [
                Expanded(child: bloodPressureMetrics(heading: "BP Tracker",systolicData: systolicData,diastolicData: diastolicData,latestDiastolic: latestDiastolic,latestSystolic: latestSystolic)),
                Expanded(child: StepsMetrics(heading: "Steps Tracker",Steps: steps)),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: _customBar(context),
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
  
  String _getTimeSinceLastUpdate() {
    return "3m";
  }

  Container calorieMetrics({required String heading, required double percentage}) {
    return Container(
      height: 200,
      width: 150,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFF82B1FF),
        borderRadius: BorderRadius.circular(20),
          // image: DecorationImage(
          //   image: AssetImage('assets/d2.jpg'),
          //   fit: BoxFit.fill,
          // )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            heading,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 20),
          Stack(
            alignment: Alignment.center, // Center the text inside the progress indicator
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  value: percentage / 100,
                  strokeWidth: 12.0,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                ),
              ),
              Text(
                "${percentage.toStringAsFixed(1)}%",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0, // Adjusted font size to fit inside the circle
                  color: Colors.white, // Set the color to ensure visibility
                ),
              ),
            ],
          ),
          SizedBox(height: 15,),
          Text(
            "500 cal",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          Text(
            "last update 3m",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),

        ],
      ),
    );
  }



  Container StepsMetrics({required String heading, required int Steps}) {
    return Container(
      height: 200,
      width: 150,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFF80CBC4),
        borderRadius: BorderRadius.circular(20),
          // image: DecorationImage(
          //   image: AssetImage('assets/d2.jpg'),
          //   fit: BoxFit.fill,
          // )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            heading,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 20),
          Stack(
            alignment: Alignment.center, // Center the text inside the progress indicator
            children: [
              SizedBox(
                width: 70,
                height: 70,
                child: CircularProgressIndicator(
                  value: steps/ 1000,
                  strokeWidth: 12.0,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.greenAccent),
                ),
              ),
              Icon(
                Icons.directions_run
              )
            ],
          ),
          SizedBox(height: 15,),
          Text(
            "$steps steps",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          Text(
            "last update 3m",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),

        ],
      ),
    );
  }

  Container bloodPressureMetrics({
    required String heading,
    required List<FlSpot> systolicData,
    required List<FlSpot> diastolicData,
    required double latestSystolic,
    required double latestDiastolic,
  }) {
    return Container(
      height: 200,
      width: 150,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xFFFFCC80),
        borderRadius: BorderRadius.circular(20),
          // image: DecorationImage(
          //   image: AssetImage('assets/d3.jpg'),
          //   fit: BoxFit.fill,
          // )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            heading,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 40,
                maxY: 200,
                lineBarsData: [
                  LineChartBarData(
                    spots: systolicData,
                    isCurved: true,
                    colors: [Colors.red],
                    barWidth: 3,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(show: false),
                  ),
                  LineChartBarData(
                    spots: diastolicData,
                    isCurved: true,
                    colors: [Colors.blue],
                    barWidth: 3,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15,),
          Text(
            "${latestSystolic.toStringAsFixed(0)}/${latestDiastolic.toStringAsFixed(0)} mmHg",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          Text(
            "last update ${_getTimeSinceLastUpdate()}",
            textAlign: TextAlign.start,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12.0,
            ),
          ),
        ],
      ),
    );
  }

  Container AppointmentUpdates(BuildContext context){
    return Container(
    );
  }

  GestureDetector weightMetrics({required String heading, required List<FlSpot> weightData}) {
    double minX = 0;
    double maxX = 1;
    double minY = 0;
    double maxY = 100;

    if (weightData.isNotEmpty) {
      minX = weightData.first.x;
      maxX = weightData.last.x;
      minY = weightData.map((spot) => spot.y).reduce((a, b) => a < b ? a : b);
      maxY = weightData.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    }
    return GestureDetector(
        onTap: (){
          _showBottomScreenWeight(context);

        },
        child: Container(
          height: 200,
          width: 150,
          margin: EdgeInsets.all(5),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Color(0xFFB39DDB),
            borderRadius: BorderRadius.circular(20),
              // image: DecorationImage(
              //   image: AssetImage('assets/d3.jpg'),
              //   fit: BoxFit.fill,
              // )

          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                heading,
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    minX: minX,
                    maxX: maxX,
                    minY: minY - 5,
                    maxY: maxY + 5,
                    lineBarsData: [
                      LineChartBarData(
                        spots: weightData,
                        isCurved: true,
                        colors: [Colors.greenAccent],
                        barWidth: 2,
                        isStrokeCapRound: true,
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                "${weightData.isNotEmpty ? weightData.last.y.toStringAsFixed(1) : 'N/A'} kgs",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18.0,
                ),
              ),
              Text(
                "last update 3m",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.0,
                ),
              ),
            ],
          ),
        )
    );
  }

  void _showBottomScreenWeight(BuildContext context){
    showModalBottomSheet(context: context,
        builder: (context){
      return Padding(padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Update Weights",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.0,),

            Divider(),
            SizedBox(height: 10.0,),

            TextField(
              controller: weightController,
              style: TextStyle(
                color: Colors.black
              ),
              decoration: InputDecoration(
                labelText: "Weight",
                labelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black45),
                ),
              ),
            ),
            SizedBox(height: 20.0,),

          ElevatedButton(
              onPressed: (){
                double? updatedWeight = double.tryParse(weightController.text);
                if (updatedWeight != null) {
                  _updateWeightData(updatedWeight);  // Update weight data
                  Navigator.pop(context);
                }
              },
                  child: Text(
                    "Update"
                  ),
            )
          ],
        ),

      );
        });
  }

  void _updateWeightData(double updatedWeight) async {
    final db = DatabaseHelper();

    String date = DateTime.now().toIso8601String();
    await db.insertWeight(date, updatedWeight);  // Insert weight data into the database
    _loadWeightData();  // Load the updated weight data to refresh the chart
  }

  void _loadWeightData() async {
    final db = DatabaseHelper();

    List<Map<String, dynamic>> weights = await db.getWeights();

    setState(() {
      weightData = weights.map((weightEntry) {
        DateTime date = DateTime.parse(weightEntry[DatabaseHelper.colweightDate]);  // Use correct column name
        double x = date.millisecondsSinceEpoch.toDouble();  // Convert date to x-axis value
        double y = double.parse(weightEntry[DatabaseHelper.colweight]);  // Convert weight value to double
        return FlSpot(x, y);
      }).toList();
    });
  }

  Container babysize({required String title, required String img}){
    return Container(
      width: 250,
      height: 270,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Color(0xFFB388FF),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
          // image: DecorationImage(
          //   image: AssetImage('$img'),
          //   fit: BoxFit.fill,
          // )
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
            child: Text(
              "$title",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),

          Padding(padding: EdgeInsets.all(10.0),
          child: Image.asset(
            'assets/avacado.png',
            width: 150,
            height: 135,
            color: Colors.white,
          ),
          ),

          Spacer(),

          Padding(padding: EdgeInsets.all(10.0),
          child: Text(
            "Whooie! Your baby is as big as avacadoo..!",
            style: TextStyle(
              color: Colors.white
            ),
          ),
          )
        ],
      ),
    );
  }


}
class babyMetricGraph extends StatelessWidget{
  final String title;
  babyMetricGraph({required this.title});

  @override
  Widget build(BuildContext context){
    return Container(
      width: 250,
      height: 250,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Color(0xFF00BFA5),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15),
        // image: DecorationImage(
        //     image: AssetImage('assets/dark.jpg'),
        //       fit: BoxFit.fill,
        // )
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
              child: Text(
                "$title",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold
                ),
              ),
              ),

              Padding(padding: EdgeInsets.only(top: 5,right: 5),
              child: Icon(
                Icons.add_business
              ),
              )
            ],
          ),
          Padding(padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
          child: Text(
            textAlign: TextAlign.start,
            "Expected due date\n03 May 2025",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,


            ),
          ),
          ),



          Spacer(),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                    child: Text(
                      textAlign: TextAlign.start,
                      "Day of Pregancy",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,

                      ),
                    ),
                  ),

                  Padding(padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Text(
                      textAlign: TextAlign.start,
                      "1st",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,

                      ),
                    ),
                  ),
                ],
              ),
              // IconButton(onPressed: (){}, icon: Icon(Icons.swap_horiz))
            ],
          )
        ],
      ),
    );
  }
}


