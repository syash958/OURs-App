import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:our/main.dart';
import 'package:our/screens/welcome.dart';
import 'package:our/widgets/progressDialog.dart';
import 'package:share/share.dart';

class ReqByUid extends StatefulWidget {
  @override
  ReqByUidStates createState() => ReqByUidStates();
}

class ReqByUidStates extends State<ReqByUid> {
  String currentUser = FirebaseAuth.instance.currentUser.uid;
  int flag;
  String reqStatus = ' ';
  String fuid = 'abs';
  Future<Function> status() async {
    FirebaseFirestore.instance
        .collection("data")
        .doc(currentUser)
        .collection("friend")
        .doc(currentUser)
        .get()
        .then((value) {
      setState(() {
        reqStatus = value.data()['status'];
        fuid = value.data()["fuid"];
      });
      print(reqStatus);
      if (reqStatus == 'accepted') {
        setState(() {
          flag = 0;
        });
        flag = 0;
        print(flag);
      } else {
        setState(() {
          flag = 1;
        });
        flag = 1;
      }
    }) ;
  }

  @override
  Widget build(BuildContext context) {
    String currentUser = FirebaseAuth.instance.currentUser.uid;
    String tobeFriendUID = '';
    String statusString = "Send Request";
    //  CollectionReference users = FirebaseFirestore.instance.collection('data');
    TextEditingController currentUidTextController = TextEditingController();
    TextEditingController tosendUidEnter = TextEditingController();
    currentUidTextController.value = TextEditingValue(text: currentUser);
    // status();
// if(flag==0){
//   return Scaffold(
//     appBar: AppBar(
//       title: Text("Add Friend"),
//     ),
//     body: Container(
//       alignment: Alignment.center,
//       width: double.infinity,
//       height: double.infinity,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text("Friend Already Added Having Unique Code" ),
//           Text(fuid),
//         ],
//       ),
//     ),
//   );
// }
// else if (flag==1){
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Friend"),
          automaticallyImplyLeading: false,
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.person_add_rounded),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: "Add Friend",
              );
            },
          ),
          actions: [
            MaterialButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut().whenComplete(() {
                  Navigator.pop(context);
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyApp(),
                    ),
                  );
                  print("logout");
                });
              },
              child: Text("Logout"),
            )
          ],
        ),
        body: Padding(
            padding: const EdgeInsets.only(top: 0.0, left: 20, right: 20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: currentUidTextController,
                    decoration: InputDecoration(
                        labelText: 'Copy Your Id To Share With Your Friend',
                        // labelStyle: textStyle,
                        errorStyle: TextStyle(
                            color: Colors.yellowAccent, fontSize: 15.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 35),
                  TextButton.icon(
                    onPressed: () {
                      Share.share(
                          'Be My Friend On Couple App *O U R S* , Here\'s My Unique Code ' +
                              currentUser,
                          subject: 'Sharing on Email');
                    },
                    label: Text("Share Your Code"),
                    icon: Icon(Icons.add_to_home_screen_sharp),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 35),
                  Text("----OR----"),
                  SizedBox(height: MediaQuery.of(context).size.height / 35),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    controller: tosendUidEnter,
                    decoration: InputDecoration(
                        labelText: 'Enter Your Friend\'s Unique Code',
                        hintText: 'Enter here',
                        // labelStyle: textStyle,
                        errorStyle: TextStyle(
                            color: Colors.yellowAccent, fontSize: 15.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 35),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.4,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: Colors.pink,
                    ),
                    child: MaterialButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext){
                                return ProgressDialog(message: "Sending Request ... ",);
                              }
                          );
                          tobeFriendUID = tosendUidEnter.text;
                          Future currentDetails() async {
                            FirebaseFirestore.instance
                                .collection('data')
                                .get()
                                .then((QuerySnapshot querySnapshot) {
                              querySnapshot.docs.forEach((doc) {
                                print(doc["uid"]);
                                if (tobeFriendUID == doc['uid']) {
                                  print("found");
                                  if (tobeFriendUID.isNotEmpty) {
                                    FirebaseFirestore.instance
                                        .collection("data")
                                        .doc(tobeFriendUID)
                                        .collection("friend")
                                        .doc(tobeFriendUID)
                                        .set({
                                      'status': 'recieved',
                                      'fuid': '',
                                      'friendrequest': currentUser
                                    });
                                    final snackBar = SnackBar(
                                        content: Text('Request Sent!'));
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    Navigator.pop(context);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => welcome()));
                                  } else if(tobeFriendUID.isEmpty){
                                    final snackBar = SnackBar(
                                        content: Text(
                                            'Paste Friend\'s Unique Code !'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                } else if (tobeFriendUID != doc['uid']) {
                                  print(tobeFriendUID);
                                  print("not found");
//pop dialog
                                }
                              });
                            });
                          }
                          currentDetails();
                        },
                        child: Text("Send Request")),
                  ),
                ],
              ),
            )));
//}
  }
}
