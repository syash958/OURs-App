import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddPhotos extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => AddPhotosState();
  
  }
  
  class AddPhotosState  extends State<AddPhotos>{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.pinkAccent,

      body: Container (
        alignment: Alignment.topCenter,
        margin: EdgeInsets.only(top: 30),
        child: 
        Column(

          children: [
            Container(
              
              child: Text("ADD MORE " ,
                style: TextStyle(
                color: Colors.grey,
                decorationColor: Colors.grey,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
                fontSize: 25,
                //backgroundColor: Colors.pink,
                letterSpacing: 8,

              ),),
            ),
          ],
        ),
      ),
    );

  }
}
  
 

