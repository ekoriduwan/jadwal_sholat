import 'package:flutter/material.dart';

void main() {
  runApp(new MaterialApp(
    title: 'Jadwal Sholat',
    home: new Home(),
  ));
}

class Home extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                child: Image.asset('assets/img/logo_jadwalsholat.png'),
              ),
              SizedBox(height: 30),
              Container(
                height: MediaQuery.of(context).size.height * 0.6,
                width: double.infinity,
                child: ListView.builder(
                    itemCount: dummy.length,
                    itemBuilder: (context, position) {
                      return Text(
                        dummy[position],
                        style: TextStyle(
                            fontFamily: "Montserrat",
                            fontSize: 16,
                            color: Colors.white),
                      );
                    }),
              )
            ]),
      ),
    );
  }
}
