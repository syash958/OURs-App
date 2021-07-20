import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class FriendRequest extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => FriendRequestState();
}

String currentUser = FirebaseAuth.instance.currentUser.uid;
String FriendReues;
String name = "";
String dob = '';
String petname = '';
String meetdate = 'No Friend Requests';
String fuid = '';
int flag;
String reqStatus = 'pending';

String currentName = ' ';
String currentDob = '';
String currentPetname = '';
String currentMeet = '';

class FriendRequestState extends State<FriendRequest> {
  Future status() async {
    FirebaseFirestore.instance
        .collection("data")
        .doc(currentUser)
        .collection("friend")
        .doc(currentUser)
        .get()
        .then((value) {
      reqStatus = value.data()['status'];
      if (reqStatus == 'accepted') {
        setState(() {
          flag = 0;
        });
        flag = 0;
      } else {
        setState(() {
          flag = 1;
        });
        flag = 1;
      }
    });
  }

  Future currentDetails() async {
    FirebaseFirestore.instance
        .collection("data")
        .doc(currentUser)
        .get()
        .then((value) {
      setState(() {
        currentName = value.data()['name'];
        currentDob = value.data()['dob'];
        currentPetname = value.data()['petName'];
        currentMeet = value.data()['meetDate'];
      });
    });
  }

  //friend
  Future fetchData() async {
    FirebaseFirestore.instance
        .collection("data")
        .doc(currentUser)
        .collection('friend')
        .doc(currentUser)
        .get()
        .then((value) {
      FriendReues = value.data()['friendrequest'];
      FirebaseFirestore.instance
          .collection("data")
          .where("uid", isEqualTo: FriendReues)
          .get()
          .then((value) {
        value.docs.forEach((result) {
          setState(() {
            name = result.data()['name'];
            dob = result.data()['dob'];
            petname = result.data()['petName'];
            meetdate = result.data()['meetDate'];
            fuid = result.data()['uid'];
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //  CollectionReference users = FirebaseFirestore.instance.collection('data');
    status();
    fetchData();
    currentDetails();

    if (flag == 0) {
      currentDetails();
      return Scaffold(
          body: new SingleChildScrollView(
              child: Container(
                  alignment: Alignment.topCenter,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('lib/images/wel1.JPG'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 18, bottom: 350),
                          child: ElevatedButton(
                              child: Text(
                                'Click Here',
                                style:
                                    TextStyle(fontSize: 20.0, letterSpacing: 5),
                              ),
                              onPressed: () {
                                final snackBar = Flushbar(
                                  margin: EdgeInsets.all(8),
                                  borderRadius: 8,
                                  duration: Duration(seconds: 7),
                                  backgroundColor: Colors.pinkAccent,
                                  boxShadows: [
                                    BoxShadow(
                                        color: Colors.blue[800],
                                        offset: Offset(0.0, 2.0),
                                        blurRadius: 3.0)
                                  ],
                                  titleText: Text(
                                    'I Love You !',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  messageText: Text(
                                      'Close Your Eyes! Remind Me And Click On \'Send\'',
                                      style: TextStyle(
                                          fontSize: 15, color: Colors.white)),
                                  forwardAnimationCurve: Curves.decelerate,
                                  reverseAnimationCurve: Curves.easeOut,
                                  mainButton: FlatButton(
                                    onPressed: () {
                                      Share.share("hey Come online on OURs App  ");
                                    },
                                    child: Text(
                                      "Send",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    ),
                                  ),
                                ).show(context);
                              })),
                      Container(
                          alignment: Alignment.topCenter,
                          width: double.infinity,
                          margin: new EdgeInsets.only(left: 40),
                          child: Column(
                            children: [
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Text(
                                    currentDob,
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w700,
                                        backgroundColor: Colors.white,
                                        color: Colors.pink),
                                  )),
                                  Expanded(
                                      child: Text(
                                    dob,
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                        decoration: TextDecoration.none,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.w700,
                                        backgroundColor: Colors.white,
                                        color: Colors.pink),
                                  )),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Text(
                                    currentName,
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w700,
                                        backgroundColor: Colors.white,
                                        color: Colors.pink),
                                  )),
                                  Expanded(
                                      child: Text(
                                    name,
                                    textDirection: TextDirection.ltr,
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w700,
                                        backgroundColor: Colors.white,
                                        color: Colors.pink),
                                  )),
                                ],
                              ),
                            ],
                          )),
                      Container(
                        margin: new EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              "Happy Together From " + currentMeet,
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.pink,
                                // backgroundColor: Colors.brown,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "to " +
                                  DateTime.now().day.toString() +
                                  ":" +
                                  DateTime.now().month.toString() +
                                  ":" +
                                  DateTime.now().year.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.pink,
                                //backgroundColor: Colors.brown,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    ],
                  ))));
    }

  }
}
