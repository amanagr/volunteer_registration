import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DonationView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donate to an NGO"),
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
                              labelText: 'Enter Amount to donate in Rs.',
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
                      'Select Payment Method ->',
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
    const Item('Give India - for Daily Wage Workers '),
    const Item('N95 Masks for Medical Staff'),
    const Item('Ketto Fundraisers for COVID-19'),
    const Item('Milaap Fundraisers for COVID-19'),
  ];
  @override
  Widget build(BuildContext context) {
    return Center(
          child:  DropdownButton<Item>(
            hint:  Text("Select NGO to donate"),
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