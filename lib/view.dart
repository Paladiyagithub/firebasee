import 'dart:ffi';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:firebasee/update.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class view extends StatefulWidget {

  @override
  State<view> createState() => _viewState();
}

class _viewState extends State<view> {
  DatabaseReference starCountRef = FirebaseDatabase.instance.ref('data');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: FirebaseAnimatedList(
          itemBuilder: (context, snapshot, animation, index) {
            dynamic dd = snapshot.value;
            return Slidable(
                endActionPane: ActionPane(motion: ScrollMotion(), children: [
                  SlidableAction(
                    flex: 1,
                    backgroundColor: Color(0xFF7BC043),
                    foregroundColor: Colors.white,
                    icon: Icons.edit,
                    label: 'Update',
                    onPressed: (BuildContext context) {
                      Navigator.push(context, MaterialPageRoute(builder:  (context) {
                        return update(dd);
                      },));
                    },
                  ),
                  SlidableAction(
                    backgroundColor: Color(0xFF0392CF),
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                    onPressed: (BuildContext context) {
                        DatabaseReference starCountRef = FirebaseDatabase.instance.ref("data").child(dd['id']).remove() as DatabaseReference;
                    },
                  ),
                ]),
                child: Card(
                  child: ListTile(
                    leading: Image.network("${dd['image']}"),
                    title: Text("name : ${dd['name']}"),
                    subtitle: Text("Age : ${dd['age']}"),
                  ),
                ));
          },
          query: starCountRef),
    ));
  }
}
