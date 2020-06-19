import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show json, base64, ascii;

import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'screens/login_screen.dart';

const baseURL = 'http://frozen-mountain-01021.herokuapp.com/api';

final storage = FlutterSecureStorage();

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Future<String> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if(jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ESTOW',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Color.fromARGB(255, 4, 125, 141)
      ),
      home: FutureBuilder(
          future: jwtOrEmpty,
          builder: (context, snapshot) {
            if(!snapshot.hasData) return CircularProgressIndicator();
            if(snapshot.data != "") {
              var str = snapshot.data;
              var jwt = str.split(".");

              if(jwt.length !=3) {
                return LoginScreen();
              } else {
                var payload = json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                if(DateTime.fromMillisecondsSinceEpoch(payload["exp"]*1000).isAfter(DateTime.now())) {
                  return HomePage(str, payload);
                } else {
                  return LoginScreen();
                }
              }
            } else {
              return LoginScreen();
            }
          }
      ),
    );
  }
}