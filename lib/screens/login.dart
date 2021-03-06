import 'package:flutter/material.dart';
//
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
//
import 'package:Eventory/screens/home.dart'; //destination


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController email = new TextEditingController();
  final TextEditingController password = new TextEditingController();

  String msg = ''; //added by Jhunes
  bool isLoggedIn = false; //added by Jhunes
  String name = ''; //added by Jhunes

  @override
  void initState() {
    //added by Jhunes
    super.initState();
    autoLogIn();
  } //added by Jhunes

  void autoLogIn() async {
    //added by Jhunes
    final SharedPreferences prefs =
        await SharedPreferences.getInstance(); //added by Jhunes
    final String userId = prefs.getString('accountID');

    if (userId != null) {
      setState(() {
        isLoggedIn = true;
        name = userId;
      });

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return MainScreen();
          },
        ),
      );
      return;
    }
  } //added by Jhunes

  Future<Null> logout() async {
    //added by Jhunes
    final SharedPreferences prefs =
        await SharedPreferences.getInstance(); //added by Jhunes
    prefs.setString('accountID', null);

    setState(() {
      name = '';
      isLoggedIn = false;
    });
  } //added by Jhunes

  Future<List> _login() async {
    print("Hello");

    final response = await http.post("http://192.168.56.1/mobile_eventory/login.php", body: {
      "event": "login",
      "email": email.text,
      "password": password.text
    });
    print(response.body);
    print(email.text);
    print(password.text);
    var datauser = json.decode(response.body);
    //print(datauser);
    print(datauser[0]['accountID']);
    if (datauser.length == 0) {
    } else {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('accountID', datauser[0]['accountID']);

      setState(() {
        name = datauser[0]['accountID'];
        isLoggedIn = true;
      });

      email.clear();

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (BuildContext context) {
            return MainScreen();
          },
        ),
      );
    }
  } //added by Jhunes

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.0, 0, 20, 0),
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.only(
              top: 25.0,
            ),
            child: Text(
              "Log in to your account", //edited by Neo
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).accentColor,
              ),
            ),
          ),
          SizedBox(height: 30.0),
          Card(
            elevation: 3.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: TextField(
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "Email",
                  prefixIcon: Icon(
                    Icons.alternate_email,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
                maxLines: 1,
                controller: email,
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Card(
            elevation: 3.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
              ),
              child: TextField(
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  hintText: "Password",
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: Colors.black,
                  ),
                  hintStyle: TextStyle(
                    fontSize: 15.0,
                    color: Colors.black,
                  ),
                ),
                obscureText: true,
                maxLines: 1,
                controller: password,
              ),
            ),
          ),
          SizedBox(height: 30.0),
          Container(
            height: 50.0,
            child: RaisedButton(
              child: Text(
                "LOGIN".toUpperCase(),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                _login(); //added by Jhunes
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (BuildContext context) {
                //       return MainScreen();
                //     },
                //   ),
                // );
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          SizedBox(height: 10.0),
          Divider(
            color: Theme.of(context).accentColor,
          ),
          SizedBox(height: 10.0),
          Center(
            child: Image.asset('assets/footer.png'),
          ),
        ],
      ),
    );
  }
}
