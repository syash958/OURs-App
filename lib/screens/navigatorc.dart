import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:our/screens/frNavigator.dart';
import 'package:our/screens/navHome.dart';
import 'package:our/screens/reqByUid.dart';
import 'package:our/widgets/progressDialog.dart';

class Navigatorc extends StatefulWidget {
  @override
  _NavigatorcState createState() => _NavigatorcState();
}

class _NavigatorcState extends State<Navigatorc> {
  String currentUser = FirebaseAuth.instance.currentUser.uid;
  int flag;
  String reqStatus = '';
  Future status() async {
    print('navigator');
    FirebaseFirestore.instance
        .collection("data")
        .doc(currentUser)
        .collection("friend")
        .doc(currentUser)
        .get()
        .then((value) {
      reqStatus = value.data()['status'];
      print(reqStatus);
      if (reqStatus == 'accepted') {
        Navigator.pop(context);
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => NavHome(),
          ),
        );
      }
      else if(reqStatus==''){
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FrNavigatorc(),
          ),
        );
      }
      else if(reqStatus=='pending'){
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FrNavigatorc(),
          ),
        );
      }
      else if(reqStatus=='recieved'){
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FrNavigatorc(),
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
    });
  }
  @override
  Widget build(BuildContext context) {
    setState(() {
      status();
    });
    return Scaffold(
      body: StreamBuilder<Object>(
        initialData: status(),
        builder: (context, snapshot) {
return ProgressDialog(message: "Please Wait",);
        }
      ),
    );
    // TODO: implement build
    throw UnimplementedError();
  }

}


