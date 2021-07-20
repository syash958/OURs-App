import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class DisplayUsers extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => DisplayUsesState();
}

class DisplayUsesState extends State<DisplayUsers> {
  @override
  Widget build(BuildContext context) {
    String currentUser = FirebaseAuth.instance.currentUser.uid;
    String tobeFriendUID;
    String statusString="Send Request";
    //  CollectionReference users = FirebaseFirestore.instance.collection('data');
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Friend"),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.person_add_rounded),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 0.0),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('data').snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('lib/images/homebg2.JPG'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      padding: EdgeInsets.all(3),
                      child: ListView.builder(
                          padding: EdgeInsets.only(left: 10),
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        75),
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.89),
                                        spreadRadius: 5,
                                        blurRadius: 8,
                                        offset: Offset(
                                            1, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  margin: EdgeInsets.all(2),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [

                                          Text("Name : "),
                                          Text(snapshot.data.documents[index]
                                              .get('name')
                                              .toString())
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("Pet Name : "),
                                          Text(snapshot.data.documents[index]
                                              .get('petName')
                                              .toString()),
                                          Padding(
                                            padding: const EdgeInsets.only(left:8.0),
                                            child: Container(
                                              height: 30,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                                color: Colors.pinkAccent,
                                              ),
                                              child: MaterialButton(
                                                  onPressed: ()  {
                                                    tobeFriendUID=snapshot.data.documents[index].get('uid').toString();
                                                    print(tobeFriendUID);
                                                    FirebaseFirestore.instance
                                                        .collection("data")
                                                        .doc(tobeFriendUID)
                                                        .collection("friend").doc(tobeFriendUID).set(
                                                        {'status':'pending','fuid':'','friendrequest':currentUser});
                                                    final snackBar = SnackBar(content: Text('Request Sent!'));
                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                    Navigator.pop(context);
                                                  },

                                                  child:
                                                  Text(statusString)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("Dob : "),
                                          Text(snapshot.data.documents[index]
                                              .get('dob')
                                              .toString())
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Text("Meet Date : "),
                                          Text(snapshot.data.documents[index]
                                              .get('meetDate')
                                              .toString())
                                        ],
                                      ),

                                      // InteractiveViewer(
                                      //   child: FadeInImage.memoryNetwork(
                                      //       excludeFromSemantics: true,
                                      //       fit: BoxFit.cover,
                                      //       placeholder: kTransparentImage,
                                      //       image: snapshot
                                      //           .data.documents[index]
                                      //           .get('url')),
                                      // ),

                                      // Container(
                                      //   width: double.infinity,
                                      //   color: Colors.grey,
                                      //   child: Center(
                                      //     child: Padding(
                                      //       padding:
                                      //       const EdgeInsets.all(0.0),
                                      //       child: SizedBox(
                                      //         height: 30,
                                      //         child: Text(
                                      //           " " + descText,
                                      //           style: TextStyle(
                                      //             fontWeight:
                                      //             FontWeight.bold,
                                      //             fontSize: 15,
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // )
                                      //TextButton(onPressed: (){},child: Text("View"))
                                    ],
                                  ),
                                ),
                                SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        55),
                              ],
                            );
                          }),
                    );

            },
          ),
        )

        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
