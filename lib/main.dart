import 'package:estowapp/pages/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:estowapp/models/cart_model.dart';
import 'package:estowapp/models/user_model.dart';
import 'package:estowapp/screens/home_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:convert' show json, base64, ascii;
import 'package:shared_preferences/shared_preferences.dart';


final storageUser = FlutterSecureStorage();

void main() => runApp(new MyApp());
const baseURL = 'http://frozen-mountain-01021.herokuapp.com/api';
const baseGraphql = 'http://frozen-mountain-01021.herokuapp.com/graphql';

class MyApp extends StatelessWidget {
  Future<String> get jwtOrEmpty async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

      var jwt = sharedPreferences.get("token");

     // var jwt = await storageUser.read(key: "jwt");

    if(jwt == null) return "";
    return jwt;
  }



  @override
  Widget build(BuildContext context) {
/*     final HttpLink httplink =
      HttpLink(uri:'http://frozen-mountain-01021.herokuapp.com/graphql');
     final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
       GraphQLClient(
         link: httplink as Link,
         cache: OptimisticCache(
           dataIdFromObject: typenameDataIdFromObject,

         ),
       ),
     );
*/
    return ScopedModel<UserModel>(
      model: UserModel(),
      child: ScopedModelDescendant<UserModel>(
          builder: (context, child, model){
            return ScopedModel<CartModel>(
              model: CartModel(model),
              child: MaterialApp(
                  title: "Flutter's Clothing",
                  theme: ThemeData(
                      primarySwatch: Colors.blue,
                      primaryColor: Color.fromARGB(255, 4, 125, 141)
                  ),
                  debugShowCheckedModeBanner: false,
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
                              return HomeScreen();
                            } else {
                              return LoginScreen();
                            }
                          }
                        } else {
                          return LoginScreen();
                        }
                      }
                  ),
              ),
            );
          }
      ),
    );
  }
}
