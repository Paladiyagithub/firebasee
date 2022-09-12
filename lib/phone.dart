import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasee/login.dart';
import 'package:flutter/material.dart';

class phone extends StatefulWidget {
  const phone({Key? key}) : super(key: key);

  @override
  State<phone> createState() => _phoneState();
}

class _phoneState extends State<phone> {
  TextEditingController phone = TextEditingController();
  TextEditingController otp = TextEditingController();

  bool phone1 = false;
  bool otpp = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  String vrid = "";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 30, left: 40, right: 40),
              decoration: BoxDecoration(
                  color: Colors.black26, borderRadius: BorderRadius.circular(10)),
              child: TextField(
                style: TextStyle(fontSize: 17, color: Colors.black),
                controller: phone,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Colors.black,
                    ),
                    errorStyle: TextStyle(fontSize: 15),
                    errorText: phone1 ? " Enter your Phone Number" : null,
                    labelText: "Number",
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 17),
              child: ElevatedButton(onPressed: () async {
                String ph = phone.text;
                if(ph.isEmpty)
                  {
                    setState(() {
                      phone1 = true;
                    });
                  }
                else {
                  await FirebaseAuth.instance.verifyPhoneNumber(
                    phoneNumber: '+91${phone.text}',
                    verificationCompleted: (PhoneAuthCredential credential) {},
                    verificationFailed: (FirebaseAuthException e) {},
                    codeSent: (String verificationId, int? resendToken) {
                      vrid = verificationId;
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {},
                  );
                }
              }, child: Text("Send Otp")),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 10, left: 40, right: 40),
              decoration: BoxDecoration(
                  color: Colors.black26, borderRadius: BorderRadius.circular(10)),
              child: TextField(
                style: TextStyle(fontSize: 17, color: Colors.black),
                controller: otp,
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                    errorStyle: TextStyle(fontSize: 15),
                    errorText: otpp ? "Enter Password" : null,
                    labelText: "Password",
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            ElevatedButton(onPressed: () async {
            String ot = otp.text;
            if(ot.isEmpty)
              {
                setState(() {
                  otpp = true;
                });
              }
            else{
              String smsCode = '${otp.text}';
              // Create a PhoneAuthCredential with the code
              PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: vrid, smsCode: smsCode);
              // Sign the user in (or link) with the credential
              await auth.signInWithCredential(credential);

              print("Success");

              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                return login();
              },));
            }
            }, child: Text("Submit"))
          ],
        ),
      ),
    ));
  }
}
