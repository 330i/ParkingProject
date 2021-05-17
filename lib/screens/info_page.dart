import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:parkit/screens/create_parking.dart';
import 'package:parkit/screens/local_map.dart';
import 'package:parkit/screens/use_parking.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 150,
          elevation: 0,
          backgroundColor: Colors.white,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.network('${FirebaseAuth.instance.currentUser!.photoURL}'),
                ),
              ),
              Container(height: 10,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Welcome ${FirebaseAuth.instance.currentUser!.displayName!.split(' ')[0]}',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 25.0,
                    ),
                  ),
                  Text('What would you like to do today?',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        backgroundColor: Colors.white,
        body: StaggeredGridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          children: <Widget>[
            _buildTile(
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.local_parking,
                          size: 115,
                        ),
                      ),
                      Text('Find',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 24.0)),
                      Text('Nearby Spaces', style: TextStyle(color: Colors.black45)),
                    ]),
              ),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => LocalMap()));
              },
            ),
            _buildTile(
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Icon(
                          Icons.qr_code,
                          size: 115,
                        ),
                      ),
                      Text('Use',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 24.0)),
                      Text('Parking Space', style: TextStyle(color: Colors.black45)),
                    ]),
              ),
              onTap: () async {
                String cameraScanResult = await scanner.scan();
                if(cameraScanResult.startsWith('parkit')&&cameraScanResult[14]=='+'){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => UseParking()));
                }
                else {
                  showDialog<void>(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Error'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: <Widget>[
                              Text('Invalid QR Code'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
            _noTapBuildTile(
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 15.0, left: 12.0, right: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Create',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24.0)),
                            Text('Parking Space', style: TextStyle(color: Colors.black45)),
                          ],
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        TextButton(
                          child: Icon(
                            Icons.add_circle_outline,
                            color: Colors.black,
                            size: 50,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => CreateParking()));
                          },
                        ),
                      ],
                    ),
                    Container(
                      height: 225,
                      child: FutureBuilder(
                        future: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('spots').get(),
                        builder: (context, userSpots) {
                          if(userSpots.hasData) {
                            QuerySnapshot userSpotData = userSpots.data as QuerySnapshot;
                            return ListView.builder(
                              itemCount: userSpotData.size,
                              itemBuilder: (context, index) {
                                return StreamBuilder(
                                  stream: FirebaseFirestore.instance.collection('spots').doc(userSpotData.docs[index]['geocode'].toString().substring(0,4)).collection(userSpotData.docs[index]['geocode'].toString().substring(0,4)).doc(userSpotData.docs[index]['geocode'].toString().substring(4)).snapshots(),
                                  builder: (context, occupyStream) {
                                    if(occupyStream.connectionState==ConnectionState.active) {
                                      return _spaceTile('${userSpotData.docs[index]['geocode']}', userSpotData.docs[index]['rate'], (occupyStream.data! as DocumentSnapshot)['isOccupied']);
                                    }
                                    else if(occupyStream.hasError) {
                                      return Center(
                                        child: Text('Error: Cannot find spot.'),
                                      );
                                    }
                                    else {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  },
                                );
                              },
                            );
                          }
                          return Center(
                            child: Text('Press the plus button to add a spot.'),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          staggeredTiles: [
            StaggeredTile.extent(1, 180.0),
            StaggeredTile.extent(1, 180.0),
            StaggeredTile.extent(2, 330.0),
          ],
        ));
  }

  Widget _buildTile(Widget child, {Function()? onTap}) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: InkWell(
          // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
              print('Not set yet');
            },
            child: child));
  }

  Widget _noTapBuildTile(Widget child) {
    return Material(
        elevation: 14.0,
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x802196F3),
        child: child);
  }

  Widget _spaceTile(String qrid, double price, bool isOccupied, {Function()? onTap}) {
    Color occupiedColor = Colors.greenAccent;
    if(isOccupied) {
      occupiedColor = Colors.orangeAccent;
    }
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(CupertinoPageRoute(builder: (context) => QRResult(geocode: qrid,)));
        },
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Row(
              children: [
                QrImage(data: 'parkit$qrid^${FirebaseAuth.instance.currentUser!.uid}', size: 70,),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$qrid',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Hourly Rate: \$${NumberFormat("#,##0.00", "en_US").format(price)}',
                      ),
                      Text(
                        'Occupied: ${isOccupied ? 'Yes' : 'No'}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          width: 300,
          height: 80,
          decoration: BoxDecoration(
            color: occupiedColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}