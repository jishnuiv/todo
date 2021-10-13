import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart ' as http;

import 'home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  String username = "";
  String password = "";
  String status = "0";
  String userid = "0";

  loginData({email, password}) async {
    var parameters = {
      "username": email,
      "password": password,
    };
    http.Response result = await http
        .post(Uri.parse("http://10.0.2.2/abc_db/login.php"), body: parameters);
    print("result from web : ${result.statusCode}");
    if (result.statusCode == 200) {
      var jsonObject = jsonDecode(result.body);
      print(jsonObject);
      status = jsonObject['status'];
      userid = jsonObject['id'];
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(jsonObject['message'])));
      if (status=="1") {
        Navigator.pushNamed(context, '/adminDashboard');
      }
    }
  }
//,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,
  @override
  Widget build(BuildContext context) {
    return Scaffold( backgroundColor: Colors.deepOrange,
        body: Container(color: Colors.white,
      child: ListView(
        children: [
          Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Text(
                "ANDROID TO DO APP ",
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 20),
              )),
          Container(alignment:  Alignment.center,
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "enter text"),
              controller: usernamecontroller,
            ),
          ),
          Container(alignment:  Alignment.center,
            padding: EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "enter text"),
              controller: passwordcontroller,
            ),
          ),
          Container(
            height: 50,
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),

            child: FlatButton(
              onPressed: () {
                loginData(
                    email: usernamecontroller.text,
                    password: passwordcontroller.text);
              },
              child: Text("login"),
              color: Colors.blue,
              textColor: Colors.white,
            ),
          ),
          FlatButton(
            onPressed: () {},
            child: Text("register"),

            textColor: Colors.blue,
          ),

        ],
      ),
    ));
  }
}
