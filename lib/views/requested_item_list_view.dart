import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';



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
  final dfRequested = FirebaseDatabase.instance.reference().child('request');
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
          title: Text("Requested essential items in your area"),
    ),
      body: Center(
        child: futureBuilder,
        ),
      );
  }
}


