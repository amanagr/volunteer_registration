import 'package:flutter/material.dart';


class NearbyServiceView extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _NearbyServiceViewState();
  }
}

class _NearbyServiceViewState extends State<NearbyServiceView> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    PlaceholderWidget(Colors.white),
    PlaceholderWidget(Colors.deepOrange),
    PlaceholderWidget(Colors.green)
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearby NGOs, Vendors, Open Shops'),
      ),
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        currentIndex: _currentIndex, // new
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.accessibility),
            title: new Text('NGO'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.shopping_cart),
            title: new Text('Vendors'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.check_circle),
              title: Text('Testing Facility')
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

}

class PlaceholderWidget extends StatelessWidget {
  final Color color;

  PlaceholderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: _buildList(),
    );
  }


  Widget _buildList() => ListView(
    children: [
      Tile(title: 'Give India - for Daily Wage Workers', subtitle: 'Email: support@giveindia.org | Phone no.: +91-99710-61236'),
      Divider(),
      Tile(title: 'Rotary Centry', subtitle: 'Email: centry@rotray.org | Phone no.: +91-9841556470'),
      Divider(),
      Tile(title: 'The Zi de Bine Association', subtitle: 'Email: help@zidebine.org | Phone no.: +91-99710-61236'),
      Divider(),
      Tile(title: 'Pretuieste Viata Foundation', subtitle: 'Email: mainn@viatafoundation.org | SMS  : 8825'),
      Divider(),
    ],
  );

}


class Tile extends StatelessWidget{
  const Tile({this.title, this.subtitle});

  final String title;
  final String subtitle;


  @override
  Widget build(BuildContext context) {

    return ListTile(
      title: Text(title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: Text(subtitle),
      onTap: () {},
    );
  }
}
