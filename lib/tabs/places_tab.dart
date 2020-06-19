import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:estowapp/main.dart';
import 'package:flutter/material.dart';
import 'package:estowapp/tiles/place_tile.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;


class PlacesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QueryBuilder>(
      future: http.post(baseGraphql,body: {"name":" as"},headers: "Authorization asdas"),
      builder: (context, snapshot){
        if(!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        else
          return ListView(
            children: snapshot.data.documents.map((doc) => PlaceTile(doc)).toList(),
          );
      },
    );
  }
}
