import 'package:flutter/material.dart';
import 'KickCounter.dart';
import 'CheckList.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PreggoTracker extends StatefulWidget{
  @override
  _ScreenPreggoTracker createState() => _ScreenPreggoTracker();
}

class _ScreenPreggoTracker extends State<PreggoTracker>{
  int selectedWeekIndex = 0;
  int? week = 0;
  ScrollController _scrollController = ScrollController(); // Scroll controller for ListView


  @override
  void initState() {
    super.initState();
    _setcurrentWeek();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedWeek();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose of the controller when the widget is destroyed
    super.dispose();
  }

  void _scrollToSelectedWeek() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        selectedWeekIndex * 60.0, // Adjust 60.0 based on the width of each item
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showTrimesterBottomSheet(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context){
          return Padding(padding: EdgeInsets.all(10),

            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                    "will implement soon.. please work consistently"
                ),
              ],
            )


          );
        }
    );
  }

  void _setcurrentWeek() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    week = pref.getInt('currentweek');
    setState(() {
      selectedWeekIndex = week ?? 0; // Set the selected week index
    });
  }

  Map<String, String> data = {
    'week 1' : "Yay! Your body is getting ready for a potential pregnancy, hormones are on the rise!",
    'week 2' : "Woohoo! The uterus is prepping big time for a potential pregnancy.",
    'week 3' : "Whoopie! It's fertilization time – sperm and egg unite to form a zygote!",
    'week 4' : "Wow! The blastocyst implants in the uterine lining, and the amniotic sac forms.",
    'week 5' : "Amazing! The neural tube forms and that tiny heart is beating at 110 bpm!",
    'week 6' : "Look at that! Tiny buds for arms and legs start developing, and circulation kicks in!",
    'week 7' : "Incredible! Bones are forming, and genitals are beginning to take shape.",
    'week 8' : "Woohoo! Major organs are developing, and the little one has webbed hands and feet!",
    'week 9' : "So cool! Teeth and taste buds are forming, and the head is half the body’s length!",
    'week 10' : "Wow! Fingers, toes, and nails are fully formed. Genitals are starting to show too!",
    'week 11' : "Fist pump! The fetus can move its fists and mouth as the bones keep hardening!",
    'week 12' : "Amazing! All organs are in place, and the circulatory system is up and running!",
    'week 13' : "Yay! Vocal cords are forming, and the head is catching up with the body’s growth.",
    'week 14' : "Woohoo! Fine hair and fingerprints are forming, and external genitals are visible!",
    'week 15' : "Awesome! Organs are moving to their spots, and the fetus starts practicing breathing.",
    'week 16' : "Yay! The little one can hear you now and reacts to light – how cool is that?",
    'week 17' : "Wow! Fat is developing under the skin, and the protective vernix is forming.",
    'week 18' : "Sweet! Lanugo (tiny hair) forms, and the fetus has a little sleep-wake cycle now.",
    'week 19' : "Woot! The kicks are getting stronger, and unique fingerprints are in place!",
    'week 20' : "Yay! Nails are growing, and the brain is developing senses like touch and taste!",
    'week 21' : "Whoopie! Limb movements are more coordinated, and bone marrow is producing blood!",
    'week 22' : "Yay! The fetus is grabbing its ears and umbilical cord, responding to sounds!",
    'week 23' : "Amazing! Premature survival is possible with care, and fat is building up rapidly.",
    'week 24' : "Wow! The lungs are nearly there, and the fetus is now 12 inches long!",
    'week 25' : "Hooray! The little one’s skin is plumping up, and the nervous system is maturing fast!",
    'week 26' : "Woohoo! Melanin is forming, giving color to the skin and eyes. The lungs are developing too!",
    'week 27' : "Wow! The fetus can now blink and has cute little eyelashes!",
    'week 28' : "Yay! The baby might start moving head-down as it preps for birth!",
    'week 29' : "Woot! The fetus is starting to fill out, and those pokes are becoming more noticeable!",
    'week 30' : "Awesome! The fetus can now control its own body temperature, and the brain is growing fast!",
    'week 31' : "Yay! The baby can process more sounds and stimuli, and sleep patterns are becoming clear!",
    'week 32' : "Woohoo! The skin isn’t see-through anymore, and all organs are getting ready for birth!",
    'week 33' : "Wow! The baby’s bones are hardening, but the brain stays soft to get ready for birth.",
    'week 34' : "Yay! The vernix is thickening to protect the skin, and the lungs are almost ready!",
    'week 35' : "Amazing! Brain development is still happening fast – just a little more to go!",
    'week 36' : "Woohoo! The little one is losing its lanugo and has a full head of hair now!",
    'week 37' : "Hooray! The baby’s toenails have grown to the ends of its toes, and it’s getting ready to drop!",
    'week 38' : "Wow! Packing on 0.5 pounds a week to get to final size – it’s almost time!",
    'week 39' : "Yippee! The baby is full-term and ready to meet the world!",
    'week 40' : "It’s go time! This is your due date – keep an eye out for labor signs!"
  };

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Preggo Tracker",
          style: TextStyle(
            color: Colors.black
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black45,
      ),

      body: SingleChildScrollView(
        child : Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20,),
            Container(
              height: 40.0,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                itemCount: 40, // 40 weeks
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedWeekIndex = index; // Update selected week index
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      margin: EdgeInsets.only(right: 2.0),
                      decoration: BoxDecoration(
                        color: selectedWeekIndex == index ? Colors.blueAccent : Colors.white,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Center(
                        child: Text(
                          "Week ${index + 1}",
                          style: TextStyle(color: Colors.black45),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            _weekByInsights(
                babySize: "Avocado", // or use dynamic size per week
                weekInfo: data['week ${selectedWeekIndex + 1}'] ?? "No data available"
            ),
            _kickCounter(title: "Kick counter",message: "Your baby have kicked for 4 times today",icon: Icons.airline_seat_legroom_extra,bgcolor: Color(0xFFFFE0B2),btnColor: Colors.orange,targetpage:  KickCounter()),
            _kickCounter(title: "Mood Tracker", message: "We gona make your stay more calmer", icon: Icons.mood_sharp,bgcolor: Color(0xFFC8E6C9),btnColor: Colors.greenAccent,targetpage:  KickCounter()),
            _kickCounter(title: "Trimester Progression", message: "Your are doing great keep the small energy", icon: Icons.pregnant_woman_sharp, bgcolor: Color(0xFF80D8FF), btnColor: Colors.blueAccent,targetpage:  KickCounter()),
            _kickCounter(title: "health Checkups", message: "Mark your checkups for more healthy baby👶🏻", icon: Icons.check_box, bgcolor: Color(0xFFC5CAE9), btnColor: Colors.indigoAccent,targetpage:  CheckList())

          ],
        )
      ),


    );
  }

  Container _weekByInsights({required String babySize, required String weekInfo}) {
    return Container(
      width: double.infinity,
      height: 220,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.black26,
          borderRadius: BorderRadius.only(topRight: Radius.circular(40.0))),
      child: Column(
        children: [
          SizedBox(height: 5),
          Text(
            "Week-o-Week Development Insights",
            style: TextStyle(
                color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
          Card(
            elevation: 2.0,
            margin: EdgeInsets.all(10.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Baby's Size: $babySize",
                    style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  // Replace hardcoded text with data for the week
                  Text(
                    "$weekInfo",
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      _showTrimesterBottomSheet(context, 1);
                    },
                    child: Text("Read More"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


  Container _kickCounter({required String title, required String message, required IconData icon, required Color bgcolor, required Color btnColor, required Widget targetpage}){
    return Container(
      width: double.infinity,
      height: 110,
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: bgcolor
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$title",
                textAlign: TextAlign.justify,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0
                ),
              ),

              Padding(padding: EdgeInsets.only(right: 5.0),
              child:Icon(icon) ,
              )

            ],
          ),
          Padding(padding: EdgeInsets.fromLTRB(2, 5, 0, 0),
          child: Text(
            "$message",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14.0
            ),
          ),
          ),

          ElevatedButton(onPressed:(){
          //  _showTrimesterBottomSheet(context, 2);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>targetpage));
          },
              child: Text(
                "Track more..",
                style: TextStyle(
                  color: Colors.white
                ),
              ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(btnColor)
            ),
          )
        ],
      ),
    );
  }
}