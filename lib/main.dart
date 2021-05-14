import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Waether App',
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;
  var tempF;
  Future getWeather() async{
    var url = Uri.parse('http://api.openweathermap.org/data/2.5/weather?q=Tashkent&units=imperial&appid={api}');
    var response = await http.get(url);
    var result = jsonDecode(response.body);
    setState(() {
      this.tempF = result['main']['temp'];
      this.description = result['weather'][0]['description'];
      this.windSpeed = result['wind']['speed'];
      this.currently = result['weather'][0]['main'];
      this.temp = (this.tempF - 32) * 5 / 9;
      this.humidity = result['main']['humidity'];
    });
  }

  void initState() {
    super.initState();
    this.getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(top: 20),
            height: MediaQuery.of(context).size.height / 3,
            width: MediaQuery.of(context).size.width,
            color: Colors.red,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    "Currently in Tashkent",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  temp != null ? temp.toString() + "\u00B0" : "Loading...",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    currently != null ? currently.toString() : "Loading...",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                )
              ],
            ),
          ),
          Expanded(
              child: Padding(
            padding: EdgeInsets.all(20),
            child: ListView(
              children: [
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                  title: Text(
                    "Temperature",
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: Text(temp != null ? temp.toString() + " \u00B0" : "Loading..."),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.cloud),
                  title: Text(
                    "Weather",
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: Text(description != null ? description.toString() : "Loading..."),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.sun),
                  title: Text(
                    "Humidity",
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: Text(humidity != null ? humidity.toString() : "Loading..."),
                ),
                ListTile(
                  leading: FaIcon(FontAwesomeIcons.wind),
                  title: Text(
                    "WindSpeed",
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: Text(windSpeed != null ? windSpeed.toString() + " m/s" : "Loading..."),
                )
              ],
            ),
          ))
        ],
      ),
    );
  }
}
