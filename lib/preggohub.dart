import 'package:flutter/material.dart';
import 'contents.dart';
import 'PreggoTracker.dart';
import 'Schedulr.dart';
import 'package:bumpie/preggohub.dart';
import 'editProfile.dart';
import 'dashboard.dart';


class preggohub extends StatefulWidget {
  @override
  _PreggoHubScreen createState() => _PreggoHubScreen();
}

class _PreggoHubScreen extends State<preggohub> {
  List<contents> contents_data = [];

  Map<String, dynamic> data = {
    'first': {
      'head': "Prioritize Preconception Health",
      'desc': "Optimal preconception health is the foundation for a smooth pregnancy and delivery. Focusing on a balanced diet, regular exercise, meditation, and stress management can enhance overall well-being.Seek guidance from fertility experts who can assess your health and provide tailored advice.Chennai’s best fertility centres often have nutritionists and wellness programs to support women’s preconception journey."
    },
    'second': {
      'head': "Stay Informed through Pregnancy Blogs",
      'desc': "In the modern age, accessing information has always been challenging. Pregnancy blogs can be valuable for expectant mothers, offering insights, advice, and personal stories.Follow reputable pregnancy blogs that cover nutrition, exercise, mental health, and childbirth preparation.Stay informed about the changes your body will undergo and the various stages of pregnancy.Reading experiences other women share can provide comfort and encouragement during this transformative period."
    },
    'third' : {
      'head': "How Painful is the Birth?",
      'desc': "It would be incorrect to say that labour is not painful; it is, in fact, an intensive and painful process. However, labour experiences range widely between women, and even between pregnancies within the same woman. The pain is mainly caused by the uterus contracting strongly to push the baby out, causing acute muscular tightening in the abdomen.During labour, the back, perineum, vaginal area, rectal area, bladder, abdomen, and pelvic belt are all subjected to quite a bit of stress, and all of these variables combine to cause intense, severe discomfort and pain.Your personal pain tolerance is another factor that influences how painful the birth will be. While pregnancy guidance for normal delivery may provide some relief, genetics, fear, anxiety, life experiences, and your or others' birth stories can all have an impact on your labour."
    },

    'fourth' : {
      'head': 'Engage in Prenatal Education',
      'desc': "Knowledge is empowerment, especially when it comes to childbirth. Prenatal education classes are an excellent way to prepare for labour and delivery.These classes, often offered by fertility centres and hospitals, cover topics such as breathing techniques, labour positions, and pain management strategies.By participating in these classes, expectant mothers can build confidence, learn valuable skills, and connect with other women going through the same journey."
    },
    'fifth' : {
      'head': "Maintain Regular Exercise",
      'desc': "Staying active by doing exercise during pregnancy has numerous benefits, including promoting a standard delivery. Exercise can help improve stamina, reduce discomfort, and enhance overall well-being.Consult your family doctor and develop a safe and suitable exercise routine for your needs.Prenatal yoga, swimming, and walking are popular choices for expectant mothers. Chennai’s fertility centres often collaborate with fitness experts to guide on maintaining a healthy exercise routine throughout pregnancy."
    },
    'sixth' : {
      'head': "Emotional Well-being",
      'desc': "Emotional well-being is a mental aspect of a healthy pregnancy. Stress and anxiety can impact both the mother and the baby, potentially influencing the labour process. Explore mindfulness techniques, meditation, and relaxation exercises to manage stress levels.Many fertility centres in Chennai offer counselling services, support groups, and social media groups to address the emotional aspects of fertility and pregnancy. Connecting with a community of expectant mothers can provide a sense of solidarity and encouragement."
    },
    'seventh' : {
      'head': "Consider Natural Birthing Techniques",
      'desc': "Natural birthing techniques focus on allowing labour to progress without unnecessary interventions. Techniques such as water birth, hypnobirthing, and guided imagery can promote relaxation and facilitate a smoother delivery.Discuss these options with your caretaker and include them in your birthing plan if they align with your preferences. Chennai’s best fertility centres often integrate natural birthing approaches into their maternity care programs."
    },
    'eigth' : {
      'head': "Develop a Birth Plan",
      'desc': "A well-thought-out birth plan can be a valuable tool during labour and delivery. Discuss your preferences with your healthcare provider, including your choice of birthing position, pain management preferences, and any specific requests you may have. Keep in mind that flexibility is vital, as childbirth can be unpredictable. By communicating your wishes and staying open to adjustments, you empower yourself to have a more positive birthing experience."
    }
  };

  @override
  void initState() {
    super.initState();
    // Populating the contents_data from the data Map
    data.forEach((key, value) {
      contents_data.add(contents(
        heading: value['head'],
        description: value['desc'],
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "PreggoHub",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.black45,
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: contents_data.length,
        itemBuilder: (context, index) {
          contents con = contents_data[index];
          return GestureDetector(
            onTap: () {
              _showBottomSheet(context,con,'assets/papa.jpg');
            },
            child: Card(
              margin: const EdgeInsets.all(15.0),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset('assets/papa.jpg',
                        width: double.maxFinite, height: 200, fit: BoxFit.cover),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0,right: 10.0,top: 10.0),
                      child: Text(
                        con.heading,
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        con.description.trim(),
                        style: TextStyle(color: Colors.black),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _customBar(context),
    );
  }

// Function to show the modal bottom sheet
  void _showBottomSheet(BuildContext context, contents content, String img) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,  // This allows the bottom sheet to take more space
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,  // Optional: Allows dragging the bottom sheet up or down
          builder: (context, scrollController) {
            return SingleChildScrollView(  // Allows content to scroll if it overflows
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,  // Adjust the size based on content
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      img,
                      width: double.maxFinite,
                      height: 200,  // Adjust height as per your design
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 10),
                    Text(
                      content.heading,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      content.description,
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
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
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>dashboard()));
              },
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
