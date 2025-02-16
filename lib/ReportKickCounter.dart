import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'databaseHelper.dart';

class ReportKickCounter extends StatefulWidget {
  @override
  _ReportKickScreen createState() => _ReportKickScreen();
}

class _ReportKickScreen extends State<ReportKickCounter> {
  List<FlSpot> kickDataPoints = [];
  List<String> dates = [];
  List<Map<String, dynamic>> kickCounterData = [];
  final db = DatabaseHelper();
  @override
  void initState() {
    super.initState();
    fetchKickData();
    fetchKickCounterData();
  }

  Future<void> fetchKickData() async {

    List<Map<String, dynamic>> data = await db.getWeeklyKickCounts();

    setState(() {
      kickDataPoints = data.asMap().entries.map((entry) {
        final index = entry.key.toDouble();
        final weekData = entry.value;

        return FlSpot(index, weekData['totalKicks'].toDouble());
      }).toList();
    });
  }

  Future<void> fetchKickCounterData() async {
    try {
      List<Map<String, dynamic>> data = await db.getKickCounterData();

      setState(() {
        kickCounterData = data;
      });
    } catch (e) {
      print('Error fetching kick counter data: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kick Count Report"),
        backgroundColor: Colors.black45,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Records",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(width: 5),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      "Stats",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
            report(context),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "Date",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "StartTime",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "EndTime",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    "KickCount",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),

            kickCounterStats()
          ],
        ),
      ),
    );
  }

  Container report(BuildContext context) {
    // Hardcoded days of the week
    final List<String> daysOfWeek = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday'
    ];

    return Container(
      width: double.infinity,
      height: 300,
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      padding: EdgeInsets.all(5.0),
      color: Colors.grey,
      child: Column(
        children: [
          Text("Report"),
          Expanded(
            child: kickDataPoints.isEmpty
                ? Center(child: CircularProgressIndicator())
                : LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  bottomTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    margin: 8,
                    getTitles: (value) {
                      final index = value.toInt();
                      if (index >= 0 && index < daysOfWeek.length) {
                        return daysOfWeek[index];
                      } else {
                        return '';
                      }
                    },
                    getTextStyles: (context, value) => const TextStyle(
                      color: Colors.black,
                      fontSize:9,
                    ),
                  ),
                  leftTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 15,
                    margin: 8,
                    getTitles: (value) {
                      return value.toInt().toString();
                    },
                    getTextStyles: (context, value) => const TextStyle(
                      color: Colors.black,
                      fontSize: 8,
                    ),
                  ),
                  rightTitles: SideTitles(showTitles: true,
                  reservedSize: 15,
                  getTitles: (value){
                    return '';
                  }
                  ),
                  topTitles: SideTitles(showTitles: false),
                ),
                borderData: FlBorderData(show: false),
                minX: 0, // Ensure these values are correct
                maxX: (daysOfWeek.length - 1).toDouble(), // Ensure maxX covers all data points
                minY: 0, // Adjust minY and maxY based on your data
                maxY: kickDataPoints.map((spot) => spot.y).reduce((a, b) => a > b ? a : b) + 5,
                lineBarsData: [
                  LineChartBarData(
                    spots: kickDataPoints,
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
        ],
      ),
    );
  }

  Widget kickCounterStats() {
    if (kickCounterData.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: kickCounterData.length,
      itemBuilder: (context, index) {
        final item = kickCounterData[index];
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    item['current_date'] ?? 'N/A',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    item['first_time'] ?? 'N/A',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    item['last_time'] ?? 'N/A',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    item['kick_count']?.toString() ?? '0',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            Divider() // Optional: Add a divider between rows
          ],
        );
      },
    );
  }

}
