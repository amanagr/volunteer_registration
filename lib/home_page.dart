import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'views/donation_view.dart';
import 'views/flag_view.dart';
import 'views/request_essential_items.dart';
import 'views/provide_essential_items.dart';
import 'views/nearby_service_provider.dart';

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
      Tile(title: 'Donation', subtitle: 'Donate money to an NGO', icon: Icons.account_balance, view: DonationView()),
      Divider(),
      Tile(title: 'Flag yourself', subtitle:  'as a victim of COVID-19', icon: Icons.accessibility_new, statefulView: FlagView()),
      Divider(),
      Tile(title: 'Request Essential Items', subtitle:  'Please limit your request to essential items like food, masks, sanitizers, etc.', icon: Icons.fastfood, statefulView: RequestItemView()),
      Divider(),
      Tile(title: 'Provide Essential Items', subtitle:  'An NGO will contact you if they need what you have', icon:  Icons.assignment_turned_in, statefulView: ProvideItemView()),
      Divider(),
      Tile(title: 'Locate nearest service provider', subtitle:  'NGO, GOV authorised vendors, Open Shops, etc.', icon:  Icons.gps_fixed, statefulView: NearbyServiceView(),),
      Divider(),
      Tile(title: 'View nearby COVID-19 Victims', subtitle:  'See see potential/confirmed victims, deaths and recent news', icon:  Icons.map,
          statefulView: WebView(
            initialUrl: ' https://infographics.channelnewsasia.com/covid-19/map.html',
            javaScriptMode: JavaScriptMode.unrestricted,
          ),),
      Divider(),
    ],
  );
}


class Tile extends StatelessWidget{
  const Tile({this.title, this.subtitle, this.icon, this.view, this.statefulView});

  final String title;
  final String subtitle;
  final IconData icon;
  final StatelessWidget view;
  final StatefulWidget statefulView;


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
          MaterialPageRoute(builder: (context) => view != null ? view : statefulView),
        );
      },
    );
  }
}
