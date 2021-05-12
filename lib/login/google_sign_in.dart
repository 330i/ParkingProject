import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:parkit/screens/navigation.dart';
import 'package:video_player/video_player.dart';

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {

  VideoPlayerController videoPlayerController = VideoPlayerController.asset('assets/above.mp4');

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.asset('assets/above.mp4')..initialize().then((_) {
      setState(() {
        videoPlayerController.play();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(240, 240, 250, 1),
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            child: Builder(
              builder: (context) {
                if (videoPlayerController.value.isInitialized) {
                  videoPlayerController.play();
                  videoPlayerController.setLooping(true);
                  return Container(
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: videoPlayerController.value.size.width,
                        height: videoPlayerController.value.size.height,
                        child: VideoPlayer(
                          videoPlayerController,
                        ),
                      ),
                    ),
                  );
                }
                else {
                  return Container(
                    color: Colors.black,
                  );
                }
              },
            ),
          ),
          Container(
            color: Color.fromRGBO(83, 148, 255, 0.25),
          ),
          Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height/8,
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 20,
                  ),
                  Container(
                    child: Text('Welcome',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height/MediaQuery.of(context).size.width>=16/9 ? MediaQuery.of(context).size.width/8 : 50,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 20,
                  ),
                  Container(
                    child: Text('Sign in',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height/MediaQuery.of(context).size.width>=16/9 ? MediaQuery.of(context).size.width/12 : 35,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 20,
                  ),
                  Container(
                    child: Text('with your Google Account',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height/MediaQuery.of(context).size.width>=16/9 ? MediaQuery.of(context).size.width/20 : 20,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 135,
              ),
              Container(
                height: 60,
                child: MaterialButton(
                  padding: EdgeInsets.all(0),
                  child: Image.asset('assets/google_signin.png'),
                  onPressed: () {
                    GoogleSignIn().signIn().then((value) async {
                      final GoogleSignInAuthentication googleSignInAuthentication = await value!.authentication;
                      final AuthCredential credential = GoogleAuthProvider.credential(
                        accessToken: googleSignInAuthentication.accessToken,
                        idToken: googleSignInAuthentication.idToken,
                      );
                      try {
                        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
                      } on FirebaseAuthException catch (e) {
                        print('error: cannot sign in');
                      }
                      FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).set({
                        'uid': FirebaseAuth.instance.currentUser!.uid,
                        'email': FirebaseAuth.instance.currentUser!.email,
                        'name': FirebaseAuth.instance.currentUser!.displayName,
                        'isParked': false,
                      }).then((value) {
                        Navigator.of(context).pushAndRemoveUntil(CupertinoPageRoute(builder: (context) => Navigation()),ModalRoute.withName('/login'));
                      });
                    });
                  },
                ),
              ),
              Container(
                height: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}