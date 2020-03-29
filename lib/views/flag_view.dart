import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:contact_picker/contact_picker.dart';
import 'package:permission_handler/permission_handler.dart';


class FlagView extends StatefulWidget {
  @override
  _FlagViewState createState() => _FlagViewState();
}

class _FlagViewState extends State<FlagView> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;
  String _currentAddress;
  var txt = TextEditingController();

  List<Contact> _contact_list = new List();
  ContactPicker _contactPicker = new ContactPicker();


  @override
  Widget build(BuildContext context) {
    if (_contact_list.length != 0) {
        print(_contact_list);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_currentPosition != null) Column(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(right: 50, left: 50),
                      child:  Text("Thanks! you have been successfully marked! Following alert will be sent to your contacts:"),
                    ),
                      Divider(height: 40,),
                    Container(
                      margin: const EdgeInsets.only(right: 50, left: 50),
                      child:  Text("I have been tested positive for COVID-19. You may have contracted an infection as we met within the last 15 days. Please isolate yourself, to prevent this from spreading"),
                    ),
                    Divider(height: 40,),
                      Container(
                          margin: const EdgeInsets.only(right: 50, left: 50),
                          child:  Text("Please enter contact number and email of people you came in contact with in the last 15 days."),
                      ),
                      Divider(height: 40,),
                      Container(
                        margin: const EdgeInsets.only(right: 50, left: 50),
                        child:  Row(
                        children: <Widget>[
                                      Expanded(
                                          child: TextField(
                                            controller: txt,
                                            decoration: InputDecoration(
                                              border: OutlineInputBorder(),
                                              labelText: 'Contact Numbers(, separated): ',
                                            ),
                                          ),
                                      ),
                                           RaisedButton(
                                              child: Text("Select Contacts"),
                                              onPressed: () async {
                                                Contact contact = await _contactPicker.selectContact();
                                                setState(() {
                                                  print(contact);
                                                  _contact_list.add(contact);
                                                });
                                              },
                                        ),
                                  ],
                                  )
                       ),
                      Divider(height: 40,),
                      Container(
                        margin: const EdgeInsets.only(right: 50, left: 50),
                        child:  TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email Ids(, separated): ',
                          ),
                        ),
                      ),
                      Divider(height: 40,),
                      RaisedButton(
                          child: Text("Send alert message"),
                          onPressed: () {
                            _getCurrentLocation();
                          },
                       ),
            ],
            ),
            if (_currentPosition == null) RaisedButton(
              child: Text("Confirm mark yourself as a victim of COVID-19"),
              onPressed: () {
                _getCurrentLocation();
              },
            ),
          ],
        ),
      ),
    );
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

  _openAddressBook() async{
    Map<PermissionGroup, PermissionStatus> permissions = await PermissionHandler().requestPermissions([PermissionGroup.contacts]);

    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);

    if (permission == PermissionStatus.granted){
      _getContactData();
    }

  }

  _getContactData() async{
    Contact con = await _contactPicker.selectContact();
    setState(() {
      _contact_list.add(con);
    });
  }

}

