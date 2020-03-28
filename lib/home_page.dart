import 'package:flutter/material.dart';
import 'views/donation_view.dart';
import 'views/flag_view.dart';
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
      Tile(title: 'Donation', subtitle: 'Donate Some Money', icon: Icons.account_balance, view: DonationView()),
      Divider(),
      Tile(title: 'Flag yourself', subtitle:  'as a victim of COVID-19', icon: Icons.accessibility_new, stateless_view: FlagView()),
      Divider(),
      Tile(title: 'Cook Food', subtitle:  'yummy food!!!', icon: Icons.fastfood),
      Divider(),
      Tile(title: 'Deliver Food', subtitle:  'You must have a vehicle',icon:  Icons.directions_bike),
      Divider(),
      Tile(title: 'Sanitizing', subtitle:  'Help sanitize a nearby public place',icon:  Icons.assignment_turned_in),
      Divider(),
    ],
  );
}

class Tile extends StatelessWidget{
  const Tile({this.title, this.subtitle, this.icon, this.view, this.stateless_view});

  final String title;
  final String subtitle;
  final IconData icon;
  final StatelessWidget view;
  final StatefulWidget stateless_view;


  @override
  Widget build(BuildContext context) {

    return ListTile(
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => view != null ? view : stateless_view),
        );
      },
    );
  }
}
