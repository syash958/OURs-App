import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:our/screens/aboutusform.dart';
import 'package:our/screens/navigatorc.dart';
import 'package:our/widgets/progressDialog.dart';

class Authentication extends StatefulWidget {
  Authentication({Key key}) : super(key: key);

  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();
  TextEditingController _emailFieldReset = TextEditingController();
  String a;


  Future<bool> signIn(String email, String password) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext){
        return ProgressDialog(message: "Signing In",);
        }
        );
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password).whenComplete(() => Navigator.pop(context));
      final snackBar =
      SnackBar(content: Text('User Signed In !'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return true;
    } catch (e) {
      print(e);
     // Navigator.pop(context);
      final snackBar =
      SnackBar(content: Text('error:'+e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
  }

  Future<bool> register(String email, String password) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext){
          return ProgressDialog(message: "Registering User",);
        }
    );
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'weak-password') {
        final snackBar =
            SnackBar(content: Text('The password provided is too weak. !'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        final snackBar =
            SnackBar(content: Text('The account already exists, Try login!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        print('The account already exists for that email.');
      }
      return false;
    } catch (e) {
      print(e.toString());
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/wel2.JPG'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                controller: _emailField,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => EmailValidator.validate(value) ? null : "Please enter a valid email",
                decoration: InputDecoration(
                  hintText: "abc@email.com",
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  labelText: "Email",
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 35),
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              child: TextFormField(
                style: TextStyle(color: Colors.white),
                controller: _passwordField,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Enter Password",
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  labelText: "Password",
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.centerRight,
                child: TextButton(
                  child: Text(
                    "Forgot Password ?   ",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    var alertDialog1 = AlertDialog(
                      title: Text("-Reset Password-"),
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      content: Container(
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailFieldReset,
                          validator: (value) => EmailValidator.validate(value) ? null : "Please enter a valid email",
                          onChanged: (value){
                            a=value;
                          },
                          decoration: InputDecoration(
                              labelText: 'Enter Email',
                              hintText: 'email123@gmail.com',
                              // labelStyle: textStyle,
                              errorStyle: TextStyle(
                                  color: Colors.yellowAccent, fontSize: 15.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0))),
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.sendPasswordResetEmail(email: a);
                           _emailFieldReset.clear();
                            dispose();
                            Navigator.of(context, rootNavigator: true).pop();
                           //  final snackBar = SnackBar(
                           //    margin: EdgeInsets.all(8),
                           //    duration: Duration(seconds: 7),
                           //    backgroundColor: Colors.pinkAccent,
                           //   content: Text("Password Reset Link Sent To Email: "+a),
                           //  );
                           //  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          },

                          child: const Text('OK'),
                        ),
                      ],
                    );

                    showDialog(
                        context: context,
                        builder: (BuildContext context) => alertDialog1);
                  },
                )),
            SizedBox(height: MediaQuery.of(context).size.height / 35),
            //register
            Container(
              width: MediaQuery.of(context).size.width / 1.4,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.transparent,
              ),
              child: MaterialButton(
                onPressed: () async {
                  bool shouldNavigate = await register(
                      _emailField.text.trim(), _passwordField.text.trim());
                  if (shouldNavigate) {
                    final snackBar =
                        SnackBar(content: Text('User Registered !'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Aboutusform(),
                      ),
                    );
                  }
                },
                child: Text(
                  "Register",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height / 35),
            Container(
              width: MediaQuery.of(context).size.width / 1.4,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: MaterialButton(
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                onPressed: () async {
                  bool shouldNavigate =
                      await signIn(_emailField.text, _passwordField.text);
                  if (shouldNavigate) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Navigatorc(),
                      ),
                    );

                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}