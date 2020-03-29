import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:geolocator/geolocator.dart';

Item selectedUser;


class RequestItemView extends StatefulWidget {
  @override
  _RequestItemViewState createState() => _RequestItemViewState();
}

class _RequestItemViewState extends State<RequestItemView> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;
  String _currentAddress;
  final databaseReference = FirebaseDatabase.instance.reference().child('request');
  final contactController = TextEditingController();
  final itemController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    if (_currentAddress == null) {
      _getCurrentLocation();
    };
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
                  showDialog(context: context, child:
                  new AlertDialog(
                    title: new Text("Thanks! We have received your request."),
                    content: new Text("You will be soon be contacted."),
                  )
                  );
                },
                child: Text(
                    'Request',
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
                    'See list of provided items',
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


class RequestedList{
  List<RequestListItem> recipeList;

  RequestedList({this.recipeList});

  factory RequestedList.fromJSON(Map<dynamic,dynamic> json){
    return RequestedList(
        recipeList: parserecipes(json)
    );
  }

  static List<RequestListItem> parserecipes(recipeJSON){
    List<RequestListItem> recipeList = [];
    recipeJSON.values.forEach((data) => recipeList.add(RequestListItem.fromJson(data)));

    return recipeList;
  }
}


class RequestListItem {
  String contactNumber;
  String amount;
  String location;
  String item;

  RequestListItem({this.contactNumber,this.amount,this.location,this.item});




  factory RequestListItem.fromJson(Map<dynamic,dynamic> parsedJson) {
//    print(parsedJson);
    return RequestListItem(contactNumber:parsedJson['Contact Number'],amount: parsedJson['Amount'],location:parsedJson['Location'],item: parsedJson['Item']);
  }
}

class MakeCall{
  List<RequestListItem> listItems=[];
  final dfRequested = FirebaseDatabase.instance.reference().child('provide');
  Future<List<RequestListItem>> firebaseCalls () async{
    RequestedList recipeList;
    DataSnapshot dataSnapshot = await dfRequested.once();
    Map<dynamic,dynamic> jsonResponse=dataSnapshot.value;
    recipeList = new RequestedList.fromJSON(jsonResponse);
    listItems.addAll(recipeList.recipeList);

    return listItems;
  }
}


class Recipe extends StatefulWidget{
  @override
  RecipesList createState()=> RecipesList();
}

class RecipesList extends State<Recipe> {
  final color = const Color(0xffbfd6ba);
  final color_text = const Color(0xffd1bad6);
  final makecall = new MakeCall();


  @override
  Widget build(BuildContext context) {
    var futureBuilder = new FutureBuilder(
        future: makecall.firebaseCalls(), // async work
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return new Text('Press button to start');
            case ConnectionState.waiting:
              return new Text('Loading....');
            default:
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              else
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      var quoteItem = snapshot.data[index];
                      if (quoteItem.item == null) {
                        return ListTile();
                      }
                      return ListTile(
                        title: Text(quoteItem.item),
                        subtitle: Text(
                          "Amount: " +
                              quoteItem.amount + "\n"
                              "Contact Number: " +
                              quoteItem.contactNumber + "\n"
                              "Location: " +
                              quoteItem.location + "\n",
                        ),
                      );
                    }
                );
          }
        }
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Essential items provided in your area"),
      ),
      body: Center(
        child: futureBuilder,
      ),
    );
  }
}


