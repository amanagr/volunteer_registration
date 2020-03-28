import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProvideItemView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Provide an essential item"),
      ),
      body: Center(
        child: Column(
            children: <Widget>[
              DropdownScreen(),
              Divider(height: 40,),
              Container(
                margin: const EdgeInsets.only(right: 50, left: 50),
                child:  TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter no. of items',
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
                child:  TextField(
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
                onPressed: () {},
                child: Text(
                    'Register provide info',
                    style: TextStyle(fontSize: 20)
                ),
              ),
              Divider(height: 40,),
              RaisedButton(
                onPressed: () {},
                child: Text(
                    'See list of requested items',
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
}




class Item {
  const Item(this.name);
  final String name;
}

class DropdownScreen extends StatefulWidget {
  State createState() =>  DropdownScreenState();
}

class DropdownScreenState extends State<DropdownScreen> {
  Item selectedUser;
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
        hint:  Text("Select an item you can provide"),
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

