import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasee/login.dart';
import 'package:firebasee/phone.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class register extends StatefulWidget {
  const register({Key? key}) : super(key: key);

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  bool emaill = false;
  bool passs = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: Colors.black),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 30),
              child: Text(
                "Create",
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 30, left: 40, right: 40),
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(10)),
              child: TextField(
                style: TextStyle(fontSize: 17, color: Colors.white),
                controller: email,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Colors.white54,
                    ),
                    errorStyle: TextStyle(fontSize: 15),
                    errorText: emaill ? " Enter your Email" : null,
                    labelText: "Email",
                    labelStyle: TextStyle(color: Colors.white54),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 10, left: 40, right: 40),
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(10)),
              child: TextField(
                style: TextStyle(fontSize: 17, color: Colors.white),
                controller: password,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.white54,
                    ),
                    errorStyle: TextStyle(fontSize: 15),
                    errorText: passs ? "Enter Password" : null,
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.white54),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            InkWell(
              onTap: () {
                EasyLoading.show();
                Future.delayed(Duration(seconds: 2)).then((value) {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return login();
                    },
                  ));
                  EasyLoading.dismiss();
                  EasyLoading.showSuccess("Success!");
                });
              },
              child: Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 25, left: 50),
                    child: Text(
                      "go to Login",
                      style:
                      TextStyle(fontSize: 16, color: Colors.blue.shade600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 50,
        width: 100,
        child: FloatingActionButton(
          backgroundColor: Colors.blue.shade400,
          onPressed: () async {
            String email1 = email.text;
            String password1 = password.text;

            emaill = false;
            passs = false;

            if (email1.isEmpty) {
              setState(() {
                emaill = true;
              });
            } else if (password1.isEmpty) {
              setState(() {
                passs = true;
              });
            }
            else{

              try {
                final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                  email: email.text,
                  password: password.text,
                ).then((value) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return phone();
                  },));
                });
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  print('The password provided is too weak.');
                } else if (e.code == 'email-already-in-use') {
                  print('The account already exists for that email.');
                }
              } catch (e) {
                print(e);
              }
            }
          },
          shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(5)),
          child: Text(
            "Next",
            style: TextStyle(fontSize: 19),
          ),
        ),
      ),
    );
  }
}
