import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:our/widgets/progressDialog.dart';

class EditProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EditProfileState();
  }
}
class EditProfileState extends State<EditProfile> {
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
  Future<void> fetchData() async {
    FirebaseFirestore.instance
        .collection("data")
        .doc(currentUser)
        .get()
        .then((value) {
          String NAME=value.data()['name'];
          String PETNAME=value.data()['petName'];
          String DOB=value.data()['dob'];
           String MD=value.data()['meetDate'].toString();
            Name.value=TextEditingValue(text:NAME );
            PetName.value=TextEditingValue(text: PETNAME);
            Dob.value=TextEditingValue(text: DOB);
            MeetDate.value=TextEditingValue(text: MD.toString());
          print(value.data());
    });
  }


  updateData() async{
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
    CollectionReference collectionReference =
    FirebaseFirestore.instance.collection("data");
   await collectionReference.doc(currentUser).update(aboutusData).then((value) {
      fetchData();
    });
     Navigator.pop(context);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Object>(
        stream: null,
        initialData: fetchData(),
        builder: (context, snapshot) {
          return Container(
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
                    Text("Uid: "+currentUser),
                    SizedBox(height: MediaQuery.of(context).size.height / 35),

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
                    TextField(
                     // readOnly: true,
                      controller: MeetDate,
                      // onTap:()
                      //   async {
                      //     var date =  await showDatePicker(
                      //         context: context,
                      //         initialDate:DateTime.now(),
                      //
                      //         firstDate:DateTime(1900),
                      //         lastDate: DateTime(2100));
                      //     MeetDate.text = date.toString().substring(0,10);
                      //
                      // },
                      decoration: InputDecoration(
                          labelText: 'Date When You Meet',
                          hintText: 'Day-Month-Year',
                          // labelStyle: textStyle,
                          errorStyle:TextStyle(color: Colors.yellowAccent, fontSize: 15.0),
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
                              updateData();
                            } else {
                              Navigator.pop(context);
                              final snackBar = SnackBar(
                                  content: Text('Complete All Enteries !'));
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          },
                          child: Text("Update")),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
