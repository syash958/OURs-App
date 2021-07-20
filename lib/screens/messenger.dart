import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Messenger extends StatefulWidget {
  @override
  _MessengerState createState() => _MessengerState();
}


class _MessengerState extends State<Messenger> {
  String currentUser = FirebaseAuth.instance.currentUser.uid;
  String fuid = '';
  TextEditingController msgcontroller = TextEditingController();
  String message;
  String currentUserName;
  Future fetchCurrentData() async {
   await FirebaseFirestore.instance
        .collection("data")
        .doc(currentUser)
        .get()
        .then((value) {
          setState(() {
            currentUserName=value.data()['petName'];
          });

      print(currentUserName);
    });
  }
  Future getCurrentUserData() async {
    try {
      DocumentSnapshot ds = await FirebaseFirestore.instance
          .collection('data')
          .doc(currentUser)
          .collection('friend')
          .doc(currentUser)
          .get();
      // fuid = ds.get('fuid').toString();
      Map<String, dynamic> data = ds.data();
      setState(() {
        fuid = data['fuid'];
      });
      print("fuid:" + fuid);
      print("gcu");
      //   String lastname = ds.get('LastName');
      //  return [fuid];
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCurrentData();
  }
  @override
  Widget build(BuildContext context) {
    //fetchCurrentData();
   // fetchData();
    getCurrentUserData();
    return Scaffold(
      body: StreamBuilder(
        // initialData: getCurrentUserData(),
        stream: FirebaseFirestore.instance
            .collection('messenger')
            .where('uid', whereIn: [currentUser,fuid]).orderBy('url',descending: true).snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator(value: 20000,semanticsLabel: "Loading",)),
                  SizedBox(height: 4,),
                  Text("Loading...",style: TextStyle(color: Colors.red,fontSize: 16),)
                ],
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
                      itemBuilder: (context,index) {
                        String descText= ' ';
                        String uploaderName=' ';
                        descText = snapshot.data.documents[index]
                            .get('DESCRIPTION')
                            .toString();
                        uploaderName = snapshot.data.documents[index]
                            .get('uploadername')
                            .toString();
                        return Container(
                          margin: EdgeInsets.all(2),
                          child: Column(
                            children: [
                              Container(
                                width: double.infinity,
                               // color: Colors.blueGrey.withOpacity(0.2),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey.withOpacity(0.2),
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(20))
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: SizedBox(
                                        height: 30,
                                        child: Text(
                                          " " + uploaderName + ': ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: SizedBox(
                                          height: 30,
                                          child: Text(
                                            " " + descText,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ),
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
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.near_me_outlined),
        onPressed: () {
          var alertDialog = AlertDialog(
            title: Text("-Enter Message-"),
            backgroundColor: Colors.grey,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            content: Container(
              child: TextFormField(
                controller: msgcontroller,
                decoration: InputDecoration(
                    labelText: 'Message',
                    hintText: 'Type here',
                    errorStyle:
                        TextStyle(color: Colors.yellowAccent, fontSize: 15.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  print(msgcontroller.text);
                  message = msgcontroller.text;
                  if (message.isNotEmpty) {
                    sendMessage();
                    msgcontroller.clear();
                    deactivate();
                  } else {
                    final snackBar =
                        SnackBar(content: Text('Type Something !'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: const Text('Send'),
              ),
            ],
          );
          showDialog(
              context: context, builder: (BuildContext context) => alertDialog);
        },
      ),
    );
    // TODO: implement build
    throw UnimplementedError();
  }
  Future sendMessage() async {
    fetchCurrentData();
    currentUser = FirebaseAuth.instance.currentUser.uid;
    message = msgcontroller.text.toString();
    DateTime _now = DateTime.now();
    print('timestamp: ${_now.hour}:${_now.minute}:${_now.second}.${_now.millisecond}');
    var a= '${_now.year}.${_now.month}.${_now.day}.${_now.hour}.${_now.minute}.${_now.second}.${_now.millisecond}';
    Map<String,dynamic> aboutusData={'uid': currentUser,'fuid':fuid,'url':a, 'DESCRIPTION': message,'uploadername':currentUserName};
    CollectionReference collectionReference=
    FirebaseFirestore.instance.collection("messenger");
    collectionReference.doc().setData(aboutusData).then((value) {
      Navigator.pop(context);
    });

  }
}
