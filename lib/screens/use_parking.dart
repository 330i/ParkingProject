import 'package:flutter/material.dart';

class UseParking extends StatefulWidget {
  @override
  _UseParkingState createState() => _UseParkingState();
}

class _UseParkingState extends State<UseParking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            'Transaction services have been disabled for Test Mode',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ),
    );
  }
}
