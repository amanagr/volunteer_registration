import 'package:flutter/material.dart';
import 'auth.dart';

class HomePage extends StatelessWidget {
  HomePage({this.auth, this.onSignOut});
  final BaseAuth auth;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {

    void _signOut() async {
      try {
        await auth.signOut();
        onSignOut();
      } catch (e) {
        print(e);
      }

    }

    return new Scaffold(
      appBar: new AppBar(
        actions: <Widget>[
          new FlatButton(
              onPressed: _signOut,
              child: new Text('Logout', style: new TextStyle(fontSize: 17.0, color: Colors.white))
          )
        ],
      ),
      body: new Center(
          child: _buildList()),
    );


  }

  Widget _buildList() => ListView(
    children: [
      _tile('Donation', 'Donate Some Money', Icons.account_balance),
      Divider(),
      _tile('Flag yourself', 'as a victim of COVID-19', Icons.accessibility_new),
      Divider(),
      _tile('Cook Food', 'yummy food!!!', Icons.fastfood),
      Divider(),
      _tile('Deliver Food', 'You must have a vehicle', Icons.directions_bike),
      Divider(),
    ],
  );

  ListTile _tile(String title, String subtitle, IconData icon) => ListTile(
    title: Text(title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 20,
        )),
    subtitle: Text(subtitle),
    leading: Icon(
      icon,
      color: Colors.blue[500],
    ),
    onTap: () {
      
    },
  );

}