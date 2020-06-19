import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show json, base64, ascii;
import 'package:shared_preferences/shared_preferences.dart';



import '../main.dart';

//final storageUser = FlutterSecureStorage();

class UserModel extends Model {
  FirebaseAuth _auth;
  //= FirebaseAuth.instance;

  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();

  bool isLoading = false;


  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);

    _loadCurrentUser();
  }


  void signUp({@required Map<String, dynamic> userData, @required String pass,
      @required VoidCallback onSuccess, @required VoidCallback onFail}){


    http.post("$baseURL/auth/register",
        body: {"email": userData["email"], "name": userData["name"],"password": pass})
        .then((user) async {
      // SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      //firebaseUser = user;
      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e){
      onFail();
      isLoading = false;
      notifyListeners();
    });

  }
/*
  void signUp({@required Map<String, dynamic> userData, @required String pass,
    @required VoidCallback onSuccess, @required VoidCallback onFail}){

    isLoading = true;
    notifyListeners();

    _auth.createUserWithEmailAndPassword(
        email: userData["email"],
        password: pass
    ).then((user) async {
      firebaseUser = user;

      await _saveUserData(userData);

      onSuccess();
      isLoading = false;
      notifyListeners();
    }).catchError((e){
      onFail();
      isLoading = false;
      notifyListeners();
    });

  }*/


  void signIn(
      {@required String email,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) async {
    isLoading = true;
    notifyListeners();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    http.post("$baseURL/auth/login",
        body: {"email": email, "password": pass})
        .then((user) async {
          sharedPreferences.remove("user");
          sharedPreferences.remove("token");


          userData = json.decode(user.body);

          if (userData["access_token"]=="" || userData["access_token"]== null) {
            onFail();
          }
          else{
            sharedPreferences.setString("token", userData["access_token"]);
            sharedPreferences.setString("user", json.encode(userData["user"]));

            onSuccess();

            await _loadCurrentUser();

          }

      //firebaseUser = user;


      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signOut() async {
    await storageUser.delete(key: "user");
    await storageUser.delete(key: "token");


    userData = Map();
    //firebaseUser = null;

    notifyListeners();
  }

  void recoverPass(String email){
    _auth.sendPasswordResetEmail(email: email);
  }

  bool isLoggedIn(){
    //print (" 9---${userData["name"]}");
    return userData["name"] != null;
    //return firebaseUser != null;
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    //await Firestore.instance.collection("users").document(firebaseUser.uid).setData(userData);
  }

  Future<Null> _loadCurrentUser() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.containsKey("user")) {

       userData = json.decode(sharedPreferences.get("user")) as Map<String, dynamic>;
     //  print ("9--- ${userData["name"] }");
    }else{

      }
   /*
    print("Carregando Usuário...");
    var user = await storageUser.read(key: "user");
print ("OK ");
    if(user == null)
      userData = {};
    else
      userData = user as Map<String, dynamic>;

    print(userData);

     */
    //return jwt;

    /*if (firebaseUser == null) firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      if (userData["name"] == null) {
        DocumentSnapshot docUser = await Firestore.instance
            .collection("users")
            .document(firebaseUser.uid)
            .get();
        userData = docUser.data;
      }
    }*/
    notifyListeners();
  }
}
