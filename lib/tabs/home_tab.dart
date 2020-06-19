import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../main.dart';


class HomeTab extends StatelessWidget {
  Future<String> get jwtOrEmpty async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var jwt = sharedPreferences.get("token");

    if(jwt == null) return "";
    return jwt;
  }

  @override
  Widget build(BuildContext context) {

    Widget _buildBodyBack() => Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 211, 118, 130),
            Color.fromARGB(255, 253, 181, 168)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight
        )
      ),
    );

    return Stack(
      children: <Widget>[
        _buildBodyBack(),
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text("Home"),
                centerTitle: true,
              ),
            ),

          ],
        )
      ],
    );
  }

}
