import 'package:estowapp/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json, base64, ascii;
import 'home_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();


  void displayDialog(context, title, text) => showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(
            title: Text(title),
            content: Text(text)
        ),
  );

  Future<String> attemptLogIn(String username, String password) async {
    var res = await http.post(
        "$baseURL/auth/login",
        body: {
          "email": username,
          "password": password
        }
    );
    if(res.statusCode == 200) {
      Map response = json.decode(res.body);
     // print(response["access_token"]);
      return response["access_token"];
    }
    return null;
  }

  Future<int> attemptSignUp(String username, String password, String name) async {
    var res = await http.post(
        '$baseURL/auth/register',
        body: {
          "email": username,
          "password": password,
          "name": name
        }
    );

    return res.statusCode;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Log In"),),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                    labelText: 'E-mail'
                ),
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: 'Nome'
                ),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    labelText: 'Senha'
                ),
              ),
              FlatButton(
                  onPressed: () async {
                    var username = _usernameController.text;
                    var password = _passwordController.text;
                    var jwt = await attemptLogIn(username, password);
                    if(jwt != null) {
                      //var userData = json.encode(jwt);
                     // print(userData.access_token);
                     // storage.write(key: "jwt", value: jwt);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage.fromBase64(jwt)
                          )
                      );
                    } else {
                      displayDialog(context, "An Error Occurred", "No account was found matching that username and password");
                    }
                  },
                  child: Text("Log In")
              ),
              FlatButton(
                  onPressed: () async {
                    var username = _usernameController.text;
                    var password = _passwordController.text;
                    var name = _nameController.text;

                    if(username.length < 4)
                      displayDialog(context, "Invalid Username", "The username should be at least 4 characters long");
                    else if(password.length < 4)
                      displayDialog(context, "Invalid Password", "The password should be at least 4 characters long");
                    else if(name.length < 4)
                      displayDialog(context, "Invalid name", "The password should be at least 4 characters long");
                    else{
                      var res = await attemptSignUp(username, password, name);
                      if(res == 200)
                        displayDialog(context, "Success", "The user was created. Log in now.");
                      else if(res == 409)
                        displayDialog(context, "That username is already registered", "Please try to sign up using another username or log in if you already have an account.");
                      else {
                        displayDialog(context, "Error", "An unknown error occurred.");
                      }
                    }
                  },
                  child: Text("Sign Up")
              )
            ],
          ),
        )
    );
  }
}