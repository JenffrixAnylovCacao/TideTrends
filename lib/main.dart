import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String _searchQuery = "";

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _search(String query) {
    setState(() {
      _searchQuery = query;
      _selectedIndex = 2;
      SeaLevelsScreen.updateLocation(query);
      SeaLevelsScreen.generateRandomTideDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/logo.jfif',
              height: 40,
            ),
            SizedBox(width: 10),
            Text(
              'TideTrends',
              style: TextStyle(
                color: const Color.fromARGB(255, 0, 140, 255),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(onSearch: _search),
          TrendsScreen(),
          SeaLevelsScreen(),
          AboutUsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Trends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.waves_outlined),
            label: 'Sea Levels',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About Us',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueGrey,
        unselectedItemColor: Colors.lightBlueAccent,
        backgroundColor: Colors.lightBlueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final Function(String) onSearch;

  HomeScreen({required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/home.jfif'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Enter Location',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    onSearch(_controller.text);
                  }
                },
                child: Text('Search'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TrendsScreen extends StatelessWidget {
  final List<Map<String, String>> regions = [
    {'region': 'NCR', 'location': 'Manila', 'highTide': '1.5m', 'lowTide': '0.3m'},
    {'region': 'Region I', 'location': 'Ilocos', 'highTide': '1.3', 'lowTide': '0.2m'},
    {'region': 'Region II', 'location': 'Cagayan Valley', 'highTide': '1.8m', 'lowTide': '0.4m'},
    {'region': 'Region III', 'location': 'Central Luzon', 'highTide': '1.8m', 'lowTide': '0.4m'},
    {'region': 'Region IV-A', 'location': 'Batangas', 'highTide': '1.2m', 'lowTide': '0.2m'},
    {'region': 'Region IV-B', 'location': 'Palawan', 'highTide': '1.6m', 'lowTide': '0.4m'},
    {'region': 'Region V', 'location': 'Albay', 'highTide': '1.8m', 'lowTide': '0.4m'},
    {'region': 'Region VI', 'location': 'Capiz', 'highTide': '1.8m', 'lowTide': '0.4m'},
    {'region': 'Region VII', 'location': 'Cebu', 'highTide': '1.8m', 'lowTide': '0.4m'},
    {'region': 'Region VIII', 'location': 'Samar', 'highTide': '1.8m', 'lowTide': '0.4m'},
    {'region': 'Region IX', 'location': 'Zamboanga', 'highTide': '1.8m', 'lowTide': '0.4m'},
    {'region': 'Region X', 'location': 'Cagayan De Oro', 'highTide': '1.8m', 'lowTide': '0.4m'},
    // Add more regions as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/aace634a-dacc-411b-800d-aad6cdae9de2.jfif'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: regions.length,
          itemBuilder: (context, index) {
            final region = regions[index];
            return ListTile(
              title: Text(
                '${region['region']} - ${region['location']}',
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                'High Tide: ${region['highTide']}, Low Tide: ${region['lowTide']}',
                style: TextStyle(color: Colors.black),
              ),
              leading: Icon(Icons.location_on, color: Colors.black),
            );
          },
        ),
      ),
    );
  }
}

class SeaLevelsScreen extends StatefulWidget {
  static String location = "";
  static String highTide = "";
  static String lowTide = "";

  static void updateLocation(String newLocation) {
    location = newLocation;
  }

  static void generateRandomTideDetails() {
    final random = Random();
    highTide = '${(1 + random.nextDouble() * 2).toStringAsFixed(2)}m at ${random.nextInt(12) + 1}:${random.nextInt(60).toString().padLeft(2, '0')} ${random.nextBool() ? 'AM' : 'PM'}';
    lowTide = '${(random.nextDouble() * 1).toStringAsFixed(2)}m at ${random.nextInt(12) + 1}:${random.nextInt(60).toString().padLeft(2, '0')} ${random.nextBool() ? 'AM' : 'PM'}';
  }

  @override
  _SeaLevelsScreenState createState() => _SeaLevelsScreenState();
}

class _SeaLevelsScreenState extends State<SeaLevelsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/c90fa6d3-7381-4625-a9e5-fbcec8aca07f.jfif'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Sea Level Insights for',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                '${SeaLevelsScreen.location}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              _buildTideCard(
                title: 'Current High Tide',
                tideInfo: SeaLevelsScreen.highTide,
              ),
              SizedBox(height: 10),
              _buildTideCard(
                title: 'Current Low Tide',
                tideInfo: SeaLevelsScreen.lowTide,
              ),
              // Add more sea level data as needed
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTideCard({required String title, required String tideInfo}) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              tideInfo,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/aace634a-dacc-411b-800d-aad6cdae9de2.jfif'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 20),
                Text(
                  'About Us',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 20),
                Divider(
                  color: Colors.black,
                  thickness: 2,
                  height: 20,
                  indent: 100,
                  endIndent: 100,
                ),
                SizedBox(height: 20),
                Text(
                  'Our Goals',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 10),
                Text(
                  'To provide accurate and timely tide information to help people stay safe and informed.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
                SizedBox(height: 20),
                Divider(
                  color: Colors.black,
                  thickness: 2,
                  height: 20,
                  indent: 100,
                  endIndent: 100,
                ),
                SizedBox(height: 20),
                Text(
                  'Contact Us',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.phone,
                      color: Colors.black,
                      size: 24,
                    ),
                    SizedBox(width: 10),
                    Text(
                      '+9662874095',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.email,
                      color: Colors.black,
                      size: 24,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'info@tidetrends.com',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Divider(
                  color: Colors.black,
                  thickness: 2,
                  height: 20,
                  indent: 100,
                  endIndent: 100,
                ),
                SizedBox(height: 20),
                Text(
                  'Follow Us',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.facebook,
                      color: Colors.black,
                      size: 30,
                    ),
                    SizedBox(width: 20),
                    Icon(
                      Icons.mobile_friendly_sharp,
                      color: Colors.black,
                      size: 30,
                    ),
                    SizedBox(width: 20),
                    Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

