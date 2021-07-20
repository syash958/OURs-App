import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:our/screens/acceptFriendReq.dart';
import 'package:our/screens/navHome.dart';
import 'package:our/screens/reqByUid.dart';
import 'package:our/widgets/progressDialog.dart';

class FrNavigatorc extends StatefulWidget {
  @override
  _FrNavigatorcState createState() => _FrNavigatorcState();
}

class _FrNavigatorcState extends State<FrNavigatorc> {
  String currentUser = FirebaseAuth.instance.currentUser.uid;
  int flag;
  String reqStatus = ' ';

  Future status() async {
    print('fnavigator');
    FirebaseFirestore.instance
        .collection("data")
        .doc(currentUser)
        .collection("friend")
        .doc(currentUser)
        .get()
        .then((value) {
          setState(() {
            reqStatus = value.data()['status'];
          });
      if (reqStatus == 'accepted') {
        Navigator.pop(context);
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => NavHome(),
          ),
        );
      }
          else if(reqStatus=='recieved'){
            print(reqStatus);
            Navigator.pop(context);
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => AcceptFriendRequest(),
              ),
            );

          }
          else if(reqStatus=='pending'){
            print(reqStatus);
             Navigator.pop(context);
            Navigator.push(context,
              MaterialPageRoute(builder: (context) => ReqByUid(),
              ),
            );

          }
      else if(reqStatus=='rejected'){
        print(reqStatus);
        Navigator.pop(context);
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => ReqByUid(),
          ),
        );

      }
          else{
        print(reqStatus);
        Navigator.pop(context);
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => ReqByUid(),
          ),
        );

      }
    });
  }
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
    return Scaffold(
      body: StreamBuilder<Object>(
          initialData: status(),
          builder: (context, snapshot) {
            return ProgressDialog(message: "Please Wait",);
          }
      ),
    );
  }

}