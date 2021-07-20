import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

fetchData() {
  // TODO: implement initState
  String currentUser = FirebaseAuth.instance.currentUser.uid;
  String FriendReues;
  String name;
  String dob;
  String petname;
  String meetdate;

  FirebaseFirestore.instance
      .collection("data")
      .doc(currentUser)
      .collection('friend')
      .doc(currentUser)
      .get()
      .then((value) {
    FriendReues = value.data()['friendrequest'];
    print(value.data());
    FirebaseFirestore.instance
        .collection("data")
        .where("uid", isEqualTo: FriendReues)
        .get()
        .then((value) {
      value.docs.forEach((result) {
        print(result.data());
        name = result.data()['name'];
        dob = result.data()['name'];
        petname = result.data()['name'];
        meetdate = result.data()['name'];
      });
    });
  });
}
