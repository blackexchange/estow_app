import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:estowapp/main.dart';

import 'package:http/http.dart' as http;

Future<BusinesstypeModel> fetchBusinesstype() async {
  final response = await http.post(
    '$baseURL/graphql',
    body:{"query{BusinessTypes{id,name}}"},
    headers: {HttpHeaders.authorizationHeader: "Basic your_api_token_here","Content-Type":"application/json"},
  );
  final responseJson = json.decode(response.body);

  return BusinesstypeModel.fromJson(responseJson);
}

class BusinesstypeModel {
  final int userId;
  final int id;
  final String title;

  BusinesstypeModel({this.userId, this.id, this.title});

  factory BusinesstypeModel.fromJson(Map<String, dynamic> json) {
    return BusinesstypeModel(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}