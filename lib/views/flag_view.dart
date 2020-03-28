import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class FlagView extends StatefulWidget {
  @override
  _FlagViewState createState() => _FlagViewState();
}

class _FlagViewState extends State<FlagView> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;
  String _currentAddress;

  @override
  Widget build(BuildContext context) {
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
                      Text("Thanks! you have been successfully marked!"),
                      Divider(height: 40,),
                      Container(
                          margin: const EdgeInsets.only(right: 50, left: 50),
                          child:  Text("Please enter contact number and email of people you came in contact with in the last 14 days."),
                      ),
                      Divider(height: 40,),
                      Container(
                        margin: const EdgeInsets.only(right: 50, left: 50),
                        child:  TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Contact Numbers(, separated): ',
                          ),
                        ),
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
}

