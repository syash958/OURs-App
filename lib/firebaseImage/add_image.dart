import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;

class AddImage extends StatefulWidget {
  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  bool uploading = false;
  double val = 0;
  CollectionReference imgRef;
  firebase_storage.Reference ref;
  TextEditingController description = TextEditingController();
  String descText;
  String currentUser = FirebaseAuth.instance.currentUser.uid;
  String currentUserName;
  String fuid;
  Future fetchData() async {
    FirebaseFirestore.instance
        .collection("data")
        .doc(currentUser)
        .collection('friend')
        .doc(currentUser)
        .get()
        .then((value) {
        fuid=value.data()['fuid'];
    });
  }
  Future fetchCurrentData() async {
    FirebaseFirestore.instance
        .collection("data")
        .doc(currentUser)
        .get()
        .then((value) {
      currentUserName=value.data()['name'];
      print(currentUserName);
    });
  }
  List<File> _image = [];
  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    fetchData();
    fetchCurrentData();
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Image'),
          actions: [
            FlatButton(
                onPressed: () {
                  setState(() {
                    uploading = true;
                  });
                  uploadFile().whenComplete(() => Navigator.of(context).pop());
                },
                child: Text(
                  'Upload Pic',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 104),
              child: GridView.builder(
                  itemCount: _image.length + 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return index == 0
                        ? Column(
                            children: [
                              Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      iconSize: 50,
                                        color: Colors.red,
                                        tooltip: 'Click here to add pic',
                                        icon: Icon(Icons.add),
                                        onPressed: () =>
                                            !uploading ? chooseImage() : null),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        "Add Pic",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          )
                        : Container(
                            margin: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(_image[index - 1]),
                                    fit: BoxFit.cover)),
                          );
                  }),
            ),
            uploading
                ? Center(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Text(
                          'uploading...',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircularProgressIndicator(
                        value: val,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      )
                    ],
                  ))
                : Container(),
            Row(
              children: [
                Container(
                  width: 200,
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: TextFormField(
                      maxLines: 1,
                      keyboardType: TextInputType.visiblePassword,
                      controller: description,
                      decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'About Picture',
                          // labelStyle: textStyle,
                          errorStyle:
                              TextStyle(color: Colors.yellowAccent, fontSize: 15.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0))),
                    ),
                  ),
                ),
                OutlineButton(
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.red,
                    onPressed: (){
                  sendMessage();
                },
                    child: Text("Upload Text Only",
                    style: TextStyle(color: Colors.red),))
              ],
            ),

          ],
        ));
  }

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile?.path));
    });
    if (pickedFile.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file.path));
      });
    } else {
      print(response.file);
    }
  }
  Future sendMessage() async {

      fetchData();
      fetchCurrentData();
      String currentUser = FirebaseAuth.instance.currentUser.uid;
      descText = description.text.toString();
      print(descText);
      if(descText.isNotEmpty){
        Map<String,dynamic> aboutusData={'uid': currentUser,'fuid':fuid,'url':'', 'DESCRIPTION': descText,'uploadername':currentUserName};
        CollectionReference collectionReference=
        FirebaseFirestore.instance.collection("imageURLs");
        collectionReference.doc().setData(aboutusData).then((value) {
          Navigator.pop(context);
        });
      }
      else{
        final snackBar =
        SnackBar(content: Text('Type Something !'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
  }
  Future uploadFile() async {
    int i = 1;

    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          fetchData();
          fetchCurrentData();
          String currentUser = FirebaseAuth.instance.currentUser.uid;
          descText = description.text.toString();
          imgRef
              .add({'uid': currentUser,'fuid':fuid,'url': value, 'DESCRIPTION': descText,'uploadername':currentUserName});
          i++;
        });
      });
    }
  }

  @override
  void initState() {
    String currentUser = FirebaseAuth.instance.currentUser.uid;
    super.initState();
    imgRef = FirebaseFirestore.instance.collection("imageURLs");
  }
}
