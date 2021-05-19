import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parkit/login/google_sign_in.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 50,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 20,
              ),
              Container(
                child: Text('Settings',
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 25,
          ),
          Row(
            children: <Widget>[
              Container(
                width: 10,
              ),
              Container(
                child: FlatButton(
                  child: Container(
                    width: MediaQuery.of(context).size.width-50,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.info_outline_rounded,
                          color: Colors.black,
                        ),
                        Container(
                          width: 10,
                        ),
                        Text(
                          'Licenses',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    showLicensePage(
                      context: context,
                      applicationIcon: Image.asset(
                        'assets/icon.png',
                        height: 100,
                      ),
                      applicationName: 'ParKit',
                      applicationVersion: 'v0.0.1 Pre-Alpha',
                    );
                  },
                  splashColor: Color.fromRGBO(158, 158, 158, 1),
                  highlightColor: Color.fromRGBO(189, 189, 189, 1),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Container(
                width: 10,
              ),
              Container(
                child: FlatButton(
                  child: Container(
                    width: MediaQuery.of(context).size.width-50,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.exit_to_app,
                          color: Colors.red,
                        ),
                        Container(
                          width: 10,
                        ),
                        Text(
                          'Sign Out',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    GoogleSignIn().signOut();
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Signin()),ModalRoute.withName('/pages'));
                  },
                  splashColor: Color.fromRGBO(239, 154, 154, 1),
                  highlightColor: Color.fromRGBO(255, 205, 210, 1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
