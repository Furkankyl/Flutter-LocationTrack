import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: LocationPage(),
    );
  }
}

class Test extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  LocationData currentLocation;

  var location = new Location();
  double distance;

  Distance ds = new Distance();
  Color backgroundColor = Colors.white;
  String error ='';
  @override
  void initState() {
    print('init');
    location.serviceEnabled().then((b){
      setState(() {
        error += 'ServiceEnabled$b';
      });
    });
    location.requestPermission().then((b){
      setState(() {
        error +='Permission: $b';
      });
    });

    location.hasPermission().then((b){
      setState(() {
        error += 'Test:$b';
      });
    });
    //distance = ds.as(LengthUnit.Meter, new LatLng(52.518611, 13.408056), new LatLng(51.519475, 7.46694444));
    //test();
    super.initState();
  }

  Future test() async {
    try {
      print('Teest');
      location.onLocationChanged().listen((LocationData currentLocation) {
        setState(() {
          this.currentLocation = currentLocation;

          distance = ds.as(
              LengthUnit.Meter,
              new LatLng(currentLocation.latitude, currentLocation.longitude),
              new LatLng(41.2851886, 36.3374779));
        });

        setState(() {
          if (distance > 50) {
            backgroundColor = Colors.red;
          } else {
            backgroundColor = Colors.green;
          }
        });
      });
    } on PlatformException catch (e) {
      print('Error');
      setState(() {
        error = e.message;
        currentLocation = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: backgroundColor,
      body: Container(
        child: Center(
          child: currentLocation != null
              ? Text(
                  "Enlem: ${currentLocation.latitude}    Boylam: ${currentLocation.longitude} Mesafe:$distance m",
                  style: Theme.of(context).textTheme.display2,
                  textAlign: TextAlign.center,
                )
              : Text('Error:$error'),
        ),
      ),
    );
  }
}
