import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';

Item selectedUser;

class RequestItemView extends StatelessWidget {


  final databaseReference = FirebaseDatabase.instance.reference();
  final contactController = TextEditingController();
  final itemController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Request an essential item"),
      ),
      body: Center(
        child: Column(
            children: <Widget>[
              DropdownScreen(),
              Divider(height: 40,),
              Container(
                margin: const EdgeInsets.only(right: 50, left: 50),
                child: TextField(
                  controller: itemController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter no. of items required',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                ),
              ),
              Divider(height: 40,),
              Container(
                margin: const EdgeInsets.only(right: 50, left: 50),
                child: TextField(
                  controller: contactController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Contact Number',
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                ),
              ),
              Divider(height: 40,),
              RaisedButton(
                onPressed: () {
                  createRecord();
                },
                child: Text(
                    'Request',
                    style: TextStyle(fontSize: 20)
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center
        ),
      ),
    );
  }

  void createRecord() {
    var ref = databaseReference.push();
    ref.set({
      'Contact Number': contactController.text,
      'amount': itemController.text,
      'item': selectedUser.name,
      "Location": "Norway,XYZ Street",
    });
  }
}



class Item {
  const Item(this.name);
  final String name;
}

class DropdownScreen extends StatefulWidget {
  State createState() =>  DropdownScreenState();
}

class DropdownScreenState extends State<DropdownScreen> {
  List<Item> users = <Item>[
    const Item('Food (enter 1 for 1 person)'),
    const Item('Masks'),
    const Item('Sanitizers'),
    const Item('Rooms (enter 1 for 1 person)'),
  ];
  @override
  Widget build(BuildContext context) {
    return Center(
      child:  DropdownButton<Item>(
        hint:  Text("Select an item you need"),
        value: selectedUser,
        onChanged: (Item Value) {
          setState(() {
            selectedUser = Value;
          });
        },
        items: users.map((Item user) {
          return  DropdownMenuItem<Item>(
            value: user,
            child: Row(
              children: <Widget>[
//                    SizedBox(width: 70,),
                Text(
                  user.name,
                  style:  TextStyle(color: Colors.black),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}

