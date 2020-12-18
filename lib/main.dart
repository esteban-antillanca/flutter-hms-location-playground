import 'dart:async';

import 'package:flutter/material.dart';
import 'package:huawei_location/location/hwlocation.dart';
import 'package:huawei_location/location/location.dart';

import 'location_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HMS Location Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'HMS Location Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  String infoText = "I don\'t know where you are";
  LocationHandler locationHandler;
  String latitude;
  String longitude;

  StreamSubscription<Location> streamSubs;

  void getLastLocation() async {
    //Let's check if we have permission to access user's location
    bool permission = await locationHandler.hasPermission();
    if (!permission) {
      //If we don't have permission, let's request for it
      locationHandler.requestPermission();
    } else {
      //If we have permission, let's try to get the last known location if it's available
      HWLocation hwLocation =
          await locationHandler.getLastLocationWithAddress();
      if (hwLocation != null) {
        latitude = hwLocation.latitude.toStringAsFixed(2);
        longitude = hwLocation.longitude.toStringAsFixed(2);

        setState(() {
          infoText =
              'Last known location is $latitude latitude and $longitude longitude';
        });
      }
    }
  }

  void getLiveLocation() async {
    bool permission = await locationHandler.hasPermission();
    if (!permission) {
      //If we don't have permission, let's request for it
      locationHandler.requestPermission();
    } else {
      locationHandler.requestLocationUpdates();
    }
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    //We initialize our location handler object
    locationHandler = LocationHandler();
    streamSubs =
        locationHandler.locationService.onLocationData.listen((location) {
      setState(() {
        latitude = location.latitude.toStringAsFixed(2);
        longitude = location.longitude.toStringAsFixed(2);
        infoText =
            'Live location obtained, $latitude Latitude and $longitude longitude';
      });
    });

    getLastLocation();
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    locationHandler.removeLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                infoText,
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 50.0,
            ),
            SizedBox.fromSize(
              size: Size(90, 90), // button width and height
              child: ClipOval(
                child: Material(
                  color: Colors.blue, // button color
                  child: InkWell(
                    splashColor: Colors.blue.shade200, // splash color
                    onTap: () {
                      setState(() {
                        infoText = 'Getting live location...';
                        getLiveLocation();
                      });
                    }, // button pressed
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.my_location), // icon
                        //Text("Locate me!"), // text
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
