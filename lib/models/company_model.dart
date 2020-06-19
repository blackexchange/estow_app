import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

Future<CompanyModel> fetchCompany() async {
  final response = await http.get(
    'https://jsonplaceholder.typicode.com/albums/1',
    headers: {HttpHeaders.authorizationHeader: "Basic your_api_token_here"},
  );
  final responseJson = json.decode(response.body);

  return CompanyModel.fromJson(responseJson);
}

class CompanyModel {
  final int userId;
  final int id;
  final String title;

  CompanyModel({this.userId, this.id, this.title});

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}