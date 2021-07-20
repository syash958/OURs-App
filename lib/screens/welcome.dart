
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:our/screens/AboutUs.dart';
import 'package:our/screens/MyHomePage.dart';
import 'package:our/screens/authentication.dart';
import 'package:our/screens/navHome.dart';
import 'package:our/screens/navigatorc.dart';

class welcome extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
  
    int a=0;
    int b=0;
    int c=0;
    void reset(){
       a=0;
       b=0;
       c=0;
    }
    void password(){
      TextEditingController passwordcntrl = TextEditingController();
      String pswd;
      var alertDialog = AlertDialog(
        title: Text("-ENTER SWEETWORD-"),
        backgroundColor: Colors.grey,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
        ),
        content:
        Container(
          child: TextFormField(
            keyboardType: TextInputType.visiblePassword,
            controller: passwordcntrl,
            obscureText: true,
            decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter Password',
                // labelStyle: textStyle,
                errorStyle: TextStyle(
                    color: Colors.yellowAccent,
                    fontSize: 15.0
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0))),

          ),
        )
        ,
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              print(passwordcntrl.text);
              pswd=passwordcntrl.text;
              if(pswd=="platonic"){
                passwordcntrl.clear();
                reset();
                var currentUser = await FirebaseAuth.instance.currentUser;
                if (currentUser != null) {
                  print(currentUser.uid);
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder:
                      (context) => Navigatorc() ));
                }else{
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder:
                      (context) => Authentication() ));
                }

              }
              else if (pswd==""){
                passwordcntrl.clear();
                reset();
                final snackBar = SnackBar(content: Text('Enter Password !'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              else{
                passwordcntrl.clear();
                reset();
                final snackBar = SnackBar(content: Text('Incorrect Password !'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            child: const Text('OK'),
          ),
        ],
      );
      showDialog(
          context: context, builder: (BuildContext context) => alertDialog);
    }
    return Scaffold(

      appBar: AppBar(
        title: Text ("SINCHAN LOVE"),
backwardsCompatibility: false,
        automaticallyImplyLeading: false,

      ),
      body: Container(
        width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/images/wel2.JPG'),
              fit: BoxFit.cover,
            ),
          ),

        child: SingleChildScrollView(
          child: Column(

            children: [
              TextButton
                (style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black54)
              ),onPressed: (){
                  if(a==3 && b==1 && c== 3){
                    print("success");
                    password();
                  }
                  reset();
                  } , child: Text("Sinchan",style: TextStyle(
                color: Colors.white,letterSpacing: 3,fontSize: 15.0,fontWeight: FontWeight.bold,

              ))),
              IconButton(
                icon: InteractiveViewer(child: Image.asset("lib/images/wel1.JPG")),
                iconSize: 200 ,
                splashColor: Colors.black,
                onPressed: () {
                  print("a" + a.toString() );
                  a=a+1;
                } ,
                // child: InteractiveViewer(
                //   child: Image.asset("lib/images/download.jpeg"),
                // ),
              ),
              IconButton(
                icon: InteractiveViewer(child: Image.asset("lib/images/wel3.jpg")),
                iconSize: 200 ,
                splashColor: Colors.lightBlueAccent,
                onPressed: () {
                  print("b" + b.toString());
                  b+=1;
                } ,
                // child: InteractiveViewer(
                //   child: Image.asset("lib/images/download.jpeg"),
                // ),
              ),
              IconButton(
                icon: InteractiveViewer(child: Image.asset("lib/images/wel4.jpg")),
                iconSize: 200 ,
                splashColor: Colors.lightBlueAccent,
                onPressed: () {
                  print("c" + c.toString());
                  c+=1;
                } ,
                // child: InteractiveViewer(
                //   child: Image.asset("lib/images/download.jpeg"),
                // ),
              ),



            ],
          ),
        )
      ),
    );

    // TODO: implement build
    throw UnimplementedError();
  }

}
