import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';
import 'requested_item_list_view.dart';
import 'package:geolocator/geolocator.dart';

Item selectedUser;


class ProvideItemView extends StatefulWidget {
  @override
  _ProvideItemViewState createState() => _ProvideItemViewState();
}

class _ProvideItemViewState extends State<ProvideItemView> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;
  String _currentAddress;

  final databaseReference = FirebaseDatabase.instance.reference().child('provide');
  final contactController = TextEditingController();
  final itemController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    if (_currentAddress == null) {
      _getCurrentLocation();
    }
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
                  controller: itemController,
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
                  showDialog(context: context, child:
                  new AlertDialog(
                    title: new Text("Thanks! We have received your request."),
                    content: new Text("You will be soon be contacted."),
                  )
                  );
                },
                child: Text(
                    'Register provided info',
                    style: TextStyle(fontSize: 20)
                ),
              ),
              Divider(height: 40,),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Recipe()),
                  );
                },
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

  void createRecord() {
    var ref = databaseReference.push();

    if (_currentAddress != null) {
      ref.set({
        'Contact Number': contactController.text,
        'Amount': itemController.text,
        'Item': selectedUser.name,
        "Location": _currentAddress,
      });
    }
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
        "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
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

// Get and display all the requested items


