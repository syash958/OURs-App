import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:our/screens/MyHomePage.dart';
// import 'package:flutter_sms/flutter_sms.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  String currentUser = FirebaseAuth.instance.currentUser.uid;
  String fname;
  String fdob;
  String mname;
  String mdob;

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('data');
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(currentUser).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          print(data);
          fname = snapshot.data['fname'];
          mname = snapshot.data['mname'];
          mdob = snapshot.data['mdob'];
          fdob = snapshot.data['fdob'];

          // setState(() {
          //     fname=snapshot.data['fname'];
          //      print(fname);
          //    });

          return Scaffold(
              appBar: AppBar(
                title: Text("About Us"),
                leading: Builder(
                  builder: (BuildContext context) {
                    return IconButton(
                      icon: const Icon(Icons.supervised_user_circle_outlined),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      tooltip: MaterialLocalizations.of(context)
                          .openAppDrawerTooltip,
                    );
                  },
                ),
              ),
              body: new SingleChildScrollView(
                  child: Center(
                      child: Container(
                          alignment: Alignment.topCenter,
                          width: double.infinity,
                    //       decoration: BoxDecoration(
                    //       image: DecorationImage(
                    //       image: AssetImage('lib/images/aboutusBG.JPG'),
                    //       fit: BoxFit.cover,
                    //   ),
                    // ),
                    child: Column(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 18, bottom: 400),
                            child: ElevatedButton(
                                child: Text(
                                  'T E X T  M E S S A G E',
                                  style: TextStyle(
                                      fontSize: 20.0, color: Colors.brown),
                                ),
                                onPressed: () {
                                  //fetchData();
                                  // Navigator.push(context, MaterialPageRoute(builder:
                                  //     (context) => GetUserName(currentUser) ));

                                  // String message = "hei Shona !";
                                  // List<String> recipents = ["8739897955"];
                                  // _sendSMS(message, recipents);
                                  // // Navigator.pop(context, MaterialPageRoute(builder:
                                  //    (context) => MyHomePage() ));
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
                                      mdob,
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w700,
                                          //backgroundColor: Colors.grey,
                                          color: Colors.pink),
                                    )),
                                    Expanded(
                                        child: Text(
                                      fdob,
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          fontSize: 15.0,
                                          fontWeight: FontWeight.w700,
                                          // backgroundColor: Colors.black,
                                          color: Colors.pink),
                                    )),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Text(
                                      mname,
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w700,
                                          //backgroundColor: Colors.black,
                                          color: Colors.pink),
                                    )),
                                    Expanded(
                                        child: Text(
                                      fname,
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.w700,
                                          //backgroundColor: Colors.black,
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
                                "Together Since 2019  ",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
                                  // backgroundColor: Colors.brown,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.none,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                " # THREE YEARS OF TOGETHERNESS ",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red,
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
                    )),
              ))

              // This trailing comma makes auto-formatting nicer for build methods.
              );
        }
        return Text("loading");
      },
    );
  }
  // TODO: implement build

}
