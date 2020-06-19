import 'dart:convert';

import 'package:estowapp/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class HomePage extends StatelessWidget {
  HomePage(this.jwt, this.payload);

  factory HomePage.fromBase64(String jwt) =>
      HomePage(
          jwt,
          json.decode(
              ascii.decode(
                  base64.decode(base64.normalize(jwt.split(".")[1]))
              )
          )
      );

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(title: Text("Secret Data Screen")),
        body: Center(
          child: FutureBuilder(
             future: http.post('$baseURL/graphql', body: json.encode ({"query{BusinessTypes{id,name}}"}), headers: {"Authorization": jwt}),
              builder: (context, snapshot) =>
              snapshot.hasData ?
              Column(children: <Widget>[
                Text("here's the data:"),
                Text("${payload}, here's the data:"),
                //Text(snapshot.data, style: Theme.of(context).textTheme.display1)
              ],)
                  :
              snapshot.hasError ? Text("An error occurred") : CircularProgressIndicator()

          ),
        ),
      );

}