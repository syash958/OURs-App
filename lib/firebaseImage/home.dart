import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import 'add_image.dart';
class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  String currentUser = FirebaseAuth.instance.currentUser.uid;
  String  fuid='';
  Future getCurrentUserData() async{
    try {
      DocumentSnapshot ds = await FirebaseFirestore.instance.collection('data').doc(currentUser).collection('friend').doc(currentUser).get();
      // fuid = ds.get('fuid').toString();
      Map<String, dynamic> data = ds.data();
      setState(() {
        fuid=data['fuid'];
      });
      print("fuid:"+fuid);
      //   String lastname = ds.get('LastName');
      //  return [fuid];
    }catch(e){
      print(e.toString());
      return null;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddImage()));

        },
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: StreamBuilder(
          initialData: getCurrentUserData(),
            stream: FirebaseFirestore.instance.collection('imageURLs').where('uid', whereIn: [currentUser,fuid] ).snapshots() ,
          builder: (context, snapshot) {
            return !snapshot.hasData
                ? Center(
                    child: CircularProgressIndicator(value: 20000,),
                  )
                : Container(
                //   decoration: BoxDecoration(
                //   image: DecorationImage(
                //     image: AssetImage('lib/images/homebg2.JPG'),
                //     fit: BoxFit.cover,
                //   ),
                // ),
                    padding: EdgeInsets.all(3),
                    child: ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          String descText;
                          String uploaderName;
                          descText = snapshot.data.documents[index].get('DESCRIPTION').toString();
                          uploaderName=snapshot.data.documents[index].get('uploadername').toString();
                          if(uploaderName.isEmpty){
                            uploaderName='hi';
                          }
                          return Container(
                            margin: EdgeInsets.all(2),
                            child: Column(
                              children: [
                                InteractiveViewer(child:FadeInImage.memoryNetwork(
                                  excludeFromSemantics: true,
                                    fit: BoxFit.cover,
                                    placeholder: kTransparentImage,
                                    image: snapshot.data.documents[index].get('url')
                                ),
                                   ),

                                  Container(
                                    width: double.infinity,
                                    color: Colors.grey,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: SizedBox(height: 30,child: Text(" "+uploaderName+': ',style: TextStyle(
                                            fontWeight: FontWeight.bold
                                            ,fontSize: 15,
                                          ),),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: SizedBox(height: 30,child: Text(" "+descText,style: TextStyle(
                                            fontWeight: FontWeight.bold
                                            ,fontSize: 15,
                                          ),),),
                                        )
                                      ],
                                    ),
                                  )
                                   //TextButton(onPressed: (){},child: Text("View"))
                              ],
                            ),

                          );
                        }),
                  );
          },
        ),
      ),
    );
  }
}
