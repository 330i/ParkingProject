import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'navigation.dart';

class UseParking extends StatefulWidget {
  late String geocode;
  UseParking({Key? key, required this.geocode}) : super(key: key);
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Transaction services have been disabled for Test Mode',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w300,
                ),
              ),
              TextButton(
                child: Container(
                  width: MediaQuery.of(context).size.width-30,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.lightBlue,
                  ),
                  child: Text(
                    'Use Parking Spot',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                onPressed: () async {
                  await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
                    'isParked': true,
                    'space': widget.geocode,
                  });
                  await FirebaseFirestore.instance.collection('spots').doc(widget.geocode.substring(0,4)).collection(widget.geocode.substring(0,4)).doc(widget.geocode.substring(4,13)).update({
                    'isOccupied': true,
                    'lastStart': Timestamp.fromMillisecondsSinceEpoch(DateTime.now().millisecondsSinceEpoch),
                    'user': FirebaseAuth.instance.currentUser!.uid,
                  }).then((otherValue) {
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Navigation()),ModalRoute.withName('/screens'));
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
