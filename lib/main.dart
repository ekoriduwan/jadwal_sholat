import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import './prayertime.dart';

void main() {
  runApp(new MaterialApp(
    title: 'Jadwal Sholat',
    home: new Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;
  String _currentAddress = 'Makassar';

  List<String> _prayerTimes = [];
  List<String> _prayerNames = [];

  TextEditingController controllerLocatin = TextEditingController();

  List<String> dummy = [
    "Fajr",
    "Terbit",
    "Duhur",
    "Ashr",
    "Terbenam",
    "Magrib",
    "Isha"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPrayerTimes(-5.165048, 119.4369173);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: SafeArea(
        child: Container(
          child: Column(children: <Widget>[
            SizedBox(height: 30),
            Container(
              child: Image.asset('assets/img/logo_jadwalsholat.png'),
            ),
            SizedBox(height: 30),
            Container(
              height: MediaQuery.of(context).size.height * 0.5,
              child: ListView.builder(
                  itemCount: dummy.length,
                  itemBuilder: (context, position) {
                    return Container(
                      padding: EdgeInsets.all(5),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              child: Text(_prayerNames[position],
                                  style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontSize: 20,
                                      color: Colors.white)),
                            ),
                            SizedBox(width: 10),
                            Container(
                                width: 150,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  color: Colors.teal[50],
                                ),
                                child: Text(_prayerTimes[position],
                                    style: TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontSize: 20,
                                        color: Colors.teal)))
                          ]),
                    );
                  }),
            ),
            FlatButton.icon(
              icon: Icon(
                Icons.location_on,
                color: Colors.white,
              ), //`Icon` to display
              label: Text(
                  _currentAddress.isNotEmpty ? _currentAddress : 'Surabaya',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat')), //`Text` to display
              onPressed: () {
                _getCurrentLocation();
                //Code to execute when Floating Action Button is clicked
                //...
              },
            ),
          ]),
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
        _currentAddress = "${place.locality}";
      });

      getPrayerTimes(_currentPosition.latitude, _currentPosition.longitude);
    } catch (e) {
      print(e);
    }
  }

  getPrayerTimes(double lat, double long) {
    PrayerTime prayers = new PrayerTime();

    prayers.setTimeFormat(prayers.getTime12());
    prayers.setCalcMethod(prayers.getKarachi());
    prayers.setAsrJuristic(prayers.getShafii());
    prayers.setAdjustHighLats(prayers.getAdjustHighLats());

    List<int> offsets = [
      -6,
      0,
      3,
      2,
      0,
      3,
      2
    ]; // {Fajr,Sunrise,Dhuhr,Asr,Sunset,Maghrib,Isha}
    prayers.tune(offsets);
    String tmx = "${DateTime.now().timeZoneOffset}";
    print(tmx[0]);

    var currentTime = DateTime.now();
    var zoneTime = double.parse(tmx[0]);

    setState(() {
      _prayerTimes = prayers.getPrayerTimes(currentTime, lat, long, zoneTime);
      _prayerNames = prayers.getTimeNames();
    });
  }
}
