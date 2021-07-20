import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:our/screens/navigatorc.dart';
import 'package:our/widgets/progressDialog.dart';

class Aboutusform extends StatelessWidget {
  TextEditingController Name = TextEditingController();
  TextEditingController Dob = TextEditingController();
  TextEditingController PetName = TextEditingController();
  TextEditingController MeetDate = TextEditingController();

  String dob;
  String name;
  String petname;
  String meetDate;
  String currentUser = FirebaseAuth.instance.currentUser.uid;
  Map data;

  @override
  Widget build(BuildContext context) {
    Future<void> fetchData() async {
      FirebaseFirestore.instance
          .collection("data")
          .doc(currentUser)
          .get()
          .then((value) {
        print(value.data());
      });
      // FirebaseFirestore.instance.collection("data").get().then((querySnapshot) {
      //   querySnapshot.docs.forEach((result) {
      //     print(result.data()['uid']);
      //   });
      // });
      // CollectionReference collectionReference = await FirebaseFirestore.instance.collection('data');
      // collectionReference.snapshots().listen((snapshot) {
      //   Map aboutusData;
      //   print(snapshot.docs.toString());
      // });
    }

    addData() {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext){
            return ProgressDialog(message: "Saving User Details",);
          }
      );
      Map<String, dynamic> aboutusData = {
        'uid': currentUser,
        'name': name,
        'petName': petname,
        "dob": dob,
        "meetDate": meetDate
      };
      Map<String, dynamic> aboutusData1 = {
        'status': "pending",
      };
      CollectionReference collectionReference =FirebaseFirestore.instance.collection("data");
      collectionReference.doc(currentUser).setData(aboutusData).then((value) {
        fetchData();
        collectionReference.doc(currentUser).collection('friend').doc(currentUser).setData(aboutusData1).then((value) {
          fetchData();
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Navigatorc()));
        });
        Navigator.pop(context);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Navigatorc()));
      });

    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Fill About You"),
        backwardsCompatibility: false,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        //padding: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,

        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  maxLines: 1,
                  keyboardType: TextInputType.visiblePassword,
                  controller: Name,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter name';
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Name',
                      hintText: 'Enter Your Name',
                      // labelStyle: textStyle,
                      errorStyle:
                          TextStyle(color: Colors.yellowAccent, fontSize: 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),

                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: PetName,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter PetName ';
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Pet Name',
                      hintText: 'Enter here',
                      // labelStyle: textStyle,
                      errorStyle:
                          TextStyle(color: Colors.yellowAccent, fontSize: 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: Dob,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter DOB';
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Date of Birth',
                      hintText: 'Enter here',
                      // labelStyle: textStyle,
                      errorStyle:
                          TextStyle(color: Colors.yellowAccent, fontSize: 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
                TextFormField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: MeetDate,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Please enter DOB';
                    }
                  },
                  decoration: InputDecoration(
                      labelText: 'Date When You Meet',
                      hintText: 'Day-Month-Year',
                      // labelStyle: textStyle,
                      errorStyle:
                          TextStyle(color: Colors.yellowAccent, fontSize: 15.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0))),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 35),
                //Save Button
                Container(
                  width: MediaQuery.of(context).size.width / 1.4,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.pink,
                  ),
                  child: MaterialButton(
                      onPressed: () async {
                        name = Name.text;
                        petname = PetName.text;
                        dob = Dob.text;
                        meetDate = MeetDate.text;
                        if (name.isNotEmpty &&
                            petname.isNotEmpty &&
                            dob.isNotEmpty &&
                            meetDate.isNotEmpty) {
                          print(currentUser);
                          addData();
                        } else {
                          final snackBar = SnackBar(
                              content: Text('Complete All Enteries !'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      child: Text("Save")),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // TODO: implement build
    throw UnimplementedError();
  }
}
