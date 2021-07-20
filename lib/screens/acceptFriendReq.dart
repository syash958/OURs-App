import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:our/screens/navigatorc.dart';
import 'package:our/widgets/progressDialog.dart';

class AcceptFriendRequest extends StatefulWidget {
  @override
  AcceptFriendRequestState createState() => AcceptFriendRequestState();
}
class AcceptFriendRequestState extends State<AcceptFriendRequest> {
  String currentUser = FirebaseAuth.instance.currentUser.uid;
  String FriendReues;
  String name = "";
  String dob = '';
  String petname = '';
  String meetdate = 'No Friend Requests';
  String fuid = '';
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
    fetchData();
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
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
        ),
        body: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('lib/images/homebg2.JPG'),
          fit: BoxFit.cover,
        ),
      ),
      padding: EdgeInsets.all(3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                  height:
                  MediaQuery.of(context).size.height / 75),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.89),
                      spreadRadius: 5,
                      blurRadius: 8,
                      offset: Offset(
                          0, 3), // changes position of shadow
                    ),
                  ],
                ),
                margin: EdgeInsets.all(2),
                child: Column(
                  children: [
                    Row(
                      children: [Text("Name : "), Text(name)],
                    ),
                    Row(
                      children: [
                        Text("Pet Name : "),
                        Text(petname),
                      ],
                    ),
                    Row(
                      children: [Text("Dob : "), Text(dob)],
                    ),
                    Row(
                      children: [
                        Text("Meet Date : "),
                        Text(meetdate)
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                  height:
                  MediaQuery.of(context).size.height / 55),
            ],
          ),
          Column(
            children: [
              Container(
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.green,
                ),
                child: MaterialButton(
                    onPressed: () async {
                      FirebaseFirestore.instance
                          .collection("data")
                          .doc(fuid)
                          .collection("friend")
                          .doc(fuid)
                          .set({
                        'status': 'accepted',
                        'fuid': currentUser,
                        'friendrequest': currentUser
                      });
                      FirebaseFirestore.instance
                          .collection("data")
                          .doc(currentUser)
                          .collection("friend")
                          .doc(currentUser)
                          .update({
                        'status': 'accepted',
                        'fuid': fuid,
                        'friendrequest': fuid
                      });
                      final snackBar = SnackBar(
                          content: Text('Request Accepted!'));
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBar);
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Navigatorc(),
                        ),
                      );
                    },
                    child: Text("Accept")),
              ),
              Container(
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.red,
                ),
                child: MaterialButton(
                    onPressed: () async {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext){
                            return ProgressDialog(message: "Accepting ...",);
                          }
                      );
                      FirebaseFirestore.instance
                          .collection("data")
                          .doc(fuid)
                          .collection("friend")
                          .doc(fuid)
                          .update({'status': ''});
                      FirebaseFirestore.instance
                          .collection("data")
                          .doc(currentUser)
                          .collection("friend")
                          .doc(currentUser)
                          .update({
                        'status': '',
                        'fuid': '',
                        'friendrequest': ""
                      });
                      final snackBar = SnackBar(
                          content: Text('Request Rejected!'));
                      ScaffoldMessenger.of(context)
                          .showSnackBar(snackBar);
                      Navigator.pop(context);
                    },
                    child: Text("Reject ")),
              ),
            ],
          ),
        ],
      )
    )
    // This trailing comma makes auto-formatting nicer for build methods.
    );
    // TODO: implement build
    throw UnimplementedError();
  }
}