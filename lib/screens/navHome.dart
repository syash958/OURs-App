import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:our/firebaseImage/home.dart';
import 'package:our/main.dart';
import 'package:our/screens/MyHomePage.dart';
import 'package:our/screens/editProfile.dart';
import 'package:our/screens/friendRequest.dart';
import 'package:our/screens/messenger.dart';
import 'package:our/screens/note_list.dart';
import 'package:our/widgets/progressDialog.dart';

class NavHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NavHomeState();
  }
}

class NavHomeState extends State<NavHome> {
  bool shouldPop = true;
  int _selectedIndex = 0;
  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  List<Widget> _widgetOptions = <Widget>[
    FriendRequest(),
    HomePage(),//pics
    Messenger(),
    NoteList(),
    EditProfile(),
  ];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text("OURS App"),
          centerTitle: true,
          automaticallyImplyLeading: false,
          elevation: 1.9,
          actions: [
            Row(
              children: [
                TextButton(
                  child: Text("Logout",
                    style: TextStyle(color: Colors.white,),
                  ),
                  onPressed: () async {
                  await FirebaseAuth.instance.signOut().whenComplete(() {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder:
                        (context) => MyApp() ));
                  });
                } ,
                ),
                // IconButton(
                //   icon: const Icon(Icons.logout),
                //   tooltip: 'LogOut',
                //   onPressed: () async {
                //     showDialog(
                //         context: context,
                //         barrierDismissible: false,
                //         builder: (BuildContext){
                //           return ProgressDialog(message: "Saving User Details",);
                //         }
                //     );
                //     await FirebaseAuth.instance.signOut().whenComplete(() {
                //       Navigator.pop(context);
                //     });
                //   },
                // ),
              ],
            ),
          ],
        ),
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: _selectedIndex,
          onItemSelected: _onItemTap,
          showElevation: true,
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
                title: Text('About Us'),
                icon: Icon(Icons.home)
            ),
            BottomNavyBarItem(
                title: Text('Album'),
                icon: Icon(Icons.photo_album_outlined)
            ),
            BottomNavyBarItem(
                title: Text('Messenger'),
                icon: Icon(Icons.chat_bubble_outline_rounded)
            ),
            BottomNavyBarItem(
                title: Text('Notes'),
                icon: Icon(Icons.note_add)
            ),
            BottomNavyBarItem(
                title: Text('Profile'),
                icon: Icon(Icons.supervised_user_circle_sharp)
            ),
          ],
        ),
      );
  }
}
