import 'dart:io';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebasee/view.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class update extends StatefulWidget {

  dynamic dd;
  update(this.dd);




  @override
  State<update> createState() => _updateState();
}

final ImagePicker _picker = ImagePicker();
class _updateState extends State<update> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
             child: st ? InkWell(
               onTap: () {
                 setState(() {
                   st = false;
                 });
               },
               child: Container(
                 height: 100,
                 child: CircleAvatar(backgroundColor: Colors.black,child: Image.network(photo)),
               ),
             ):InkWell(
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
           ),
            Container(
              child: TextField(controller: name,),
            ),
            Container(
              child: TextField(keyboardType: TextInputType.numberWithOptions(),controller: age,),
            ),
            ElevatedButton(
                onPressed: ()  {
                  final storageRef = FirebaseStorage.instance.ref();
                  final mountainImagesRef = storageRef.child("shrey/${Random().nextInt(10000)}.jpg");

                 mountainImagesRef.putFile(File(imagepath)).then((p0) {
                   mountainImagesRef.getDownloadURL().then((value) async {
                     DatabaseReference starCountRef = FirebaseDatabase.instance.ref("data").child(widget.dd['id']);
                     print("+++++++++++++++$value");
                     if(st)
                       {
                         await starCountRef.set({
                           "id" : widget.dd['id'],
                           "name": name.text,
                           "age": age.text,
                           "image": photo
                         });
                       }
                     else {
                       await starCountRef.set({
                         "id" : widget.dd['id'],
                         "name": name.text,
                         "age": age.text,
                         "image": value
                       });
                     }

                   });
                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                     return view();
                   },));


                 });


                },
                child: Text("update")),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    name.text = widget.dd['name'];
    age.text = widget.dd['age'];
    photo = widget.dd['image'];
    // id = widget.map['id'];
    // print("${widget.map['image']}");
  }
  DatabaseReference? ref;
  String imagepath = "";
  String photo = "";
  String? id;
  bool st = true;
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();
}
