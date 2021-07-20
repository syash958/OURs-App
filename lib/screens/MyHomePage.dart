import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:our/firebaseImage/home.dart';
import 'package:our/screens/AboutUs.dart';
import 'package:our/screens/friendRequest.dart';
import 'package:our/screens/messenger.dart';
import 'package:our/screens/note_list.dart';
import 'package:our/screens/reqByUid.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyHomePageState();
  }
}
class MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      body: Container(
          width: double.infinity,
          height: double.maxFinite,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/images/homebg2.JPG'),
              fit: BoxFit.cover,
            ),
          ),
          child: new SingleChildScrollView(
              child: Column(
            children: <Widget>[

              Padding(
                  padding: const EdgeInsets.only(top:18),
                  child: ElevatedButton(
                      child: Text(
                        'A B O U T  U S',
                        style: TextStyle(fontSize: 20.0, color: Colors.brown),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FriendRequest()));
                      })),
              Padding(
                  padding: const EdgeInsets.all(3),
                  child: ElevatedButton(
                      child: Text(
                        'ALBUM',
                        style: TextStyle(fontSize: 20.0, color: Colors.brown),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage()));
                      })),

            ],
          ))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NoteList()));
        },
        child: Icon(Icons.app_registration),
      ),
      endDrawer: Drawer(child: Messenger()
          // Center(
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: <Widget>[
          //       const Text('This is the Drawer'),
          //       ElevatedButton(
          //         onPressed: null,
          //         child: const Text('Close Drawer'),
          //       ),
          //     ],
          //   ),
          // ),

          ),
      // Disable opening the end drawer with a swipe gesture.
      endDrawerEnableOpenDragGesture: true,
      appBar: AppBar(
        title: Text("Home"),
        leading: IconButton(
          icon: const Icon(Icons.logout),
          tooltip: 'Show Snackbar',
          onPressed: () async {
            await FirebaseAuth.instance.signOut().whenComplete(() {
              Navigator.pop(context);
            });
          },
        ),
        actions: [
          IconButton(
              icon: const Icon(CupertinoIcons.person_add),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ReqByUid()));
              }),
          Builder(
              builder: (context) => // Ensure Scaffold is in context
              IconButton(
                  icon: Icon(CupertinoIcons.paperplane),
                  onPressed: () => Scaffold.of(context).openEndDrawer())),
        ],
        backwardsCompatibility: false,
      ),
    );
  }
}
