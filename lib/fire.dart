import 'dart:io';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebasee/view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class fire extends StatefulWidget {
  const fire({Key? key}) : super(key: key);

  @override
  State<fire> createState() => _fireState();
}

class _fireState extends State<fire> {
  final ImagePicker _picker = ImagePicker();

  String imagepath = "";
  String up = "";
  String? id;
  DatabaseReference? ref;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            InkWell(
              onTap: () async {
                // Pick an image
                final XFile? image =
                await _picker.pickImage(source: ImageSource.gallery);

                setState(() {
                  imagepath = image!.path;
                });
              },
              child: Container(
                height: 100,
                child: CircleAvatar(
                  child: Image.file(File(imagepath)),
                ),
              ),
            ),
            Container(
              child: TextField(controller: name,),
            ),
            Container(
              child: TextField(keyboardType: TextInputType.numberWithOptions(),controller: age,),
            ),
            ElevatedButton(
                onPressed: () {
                  // Create a storage reference from our app
                  final storageRef = FirebaseStorage.instance.ref();
                  // Create a reference to 'images/mountains.jpg'
                  final mountainImagesRef = storageRef.child("shrey/${Random().nextInt(10000)}.jpg");

                  mountainImagesRef.putFile(File(imagepath)).then((p0) {
                    print("$p0");
                    mountainImagesRef.getDownloadURL().then((value) async {
                      ref = FirebaseDatabase.instance.ref("data").push();

                      id = ref!.key;
                      await ref!.set({
                        "id" : id,
                        "name": name.text,
                        "age": age.text,
                        "image": value
                      });
                    });
                  });

                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return view();
                  // },));
                },
                child: Text("Uplode")),
            ElevatedButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return view();
              },));
            }, child: Text("view")),
            ElevatedButton(onPressed: () {
              Navigator.pop(context);
            }, child: Text("Logout"))
          ],
        ),
      ),
    );
  }
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();
}