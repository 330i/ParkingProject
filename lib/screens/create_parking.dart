import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:parkit/models/pluscode.dart';
import 'package:parkit/screens/info_page.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:rive/rive.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:validators/sanitizers.dart';

class CreateParking extends StatefulWidget {
  const CreateParking({Key? key}) : super(key: key);

  @override
  _CreateParkingState createState() => _CreateParkingState();
}

class _CreateParkingState extends State<CreateParking> with TickerProviderStateMixin {
  final riveFileName = 'assets/par.riv';
  Artboard _artboard = RuntimeArtboard();

  @override
  void initState() {
    _loadRiveFile();
    super.initState();
  }

  void _loadRiveFile() async {
    final bytes = await rootBundle.load(riveFileName);
    final file = RiveFile.import(bytes);
      setState(() => _artboard = file.mainArtboard
        ..addController(
          SimpleAnimation('location'),
        ));
    }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..forward();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Spacer(
                flex: 1,
              ),
              Container(
                color: Colors.white,
                child: FadeTransition(
                  opacity: _animation,
                  child: Text(
                    '1. Go to the location of the parking spot.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              Container(height: 10,),
              _artboard != null
                  ? Container(
                height: 400,
                    child: Rive(
                artboard: _artboard,
                fit: BoxFit.cover,
              ),
                  )
                  : Container(height: 100,),
              FadeTransition(
                opacity: _animation,
                child: TextButton(
                  child: Container(
                    width: MediaQuery.of(context).size.width-30,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.lightBlue,
                    ),
                    child: Text(
                      'I am at my location',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).push(CupertinoPageRoute(builder: (context) => CaptureParking()));
                  },
                ),
              ),
              Spacer(
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CaptureParking extends StatefulWidget {
  const CaptureParking({Key? key}) : super(key: key);

  @override
  _CaptureParkingState createState() => _CaptureParkingState();
}

class _CaptureParkingState extends State<CaptureParking> with TickerProviderStateMixin {
  final riveFileName = 'assets/par.riv';
  Artboard _artboard = RuntimeArtboard();

  @override
  void initState() {
    _loadRiveFile();
    super.initState();
  }

  void _loadRiveFile() async {
    final bytes = await rootBundle.load(riveFileName);
    final file = RiveFile.import(bytes);
    setState(() => _artboard = file.mainArtboard
      ..addController(
        SimpleAnimation('capture'),
      ));
  }

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..forward();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Spacer(
                flex: 1,
              ),
              Container(
                color: Colors.white,
                child: FadeTransition(
                  opacity: _animation,
                  child: Text(
                    '2. Capture the parking spot.',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              Container(height: 10,),
              _artboard != null
                  ? Container(
                height: 400,
                child: Rive(
                  artboard: _artboard,
                  fit: BoxFit.cover,
                ),
              )
                  : Container(height: 100,),
              FadeTransition(
                opacity: _animation,
                child: TextButton(
                  child: Container(
                    width: MediaQuery.of(context).size.width-30,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.lightBlue,
                    ),
                    child: Text(
                      'Capture Spot',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  onPressed: () async {
                    await getPlusCode().then((value) {
                      Navigator.of(context).push(CupertinoPageRoute(builder: (context) => Pricing(geocode: value,)));
                    });
                  },
                ),
              ),
              Spacer(
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Pricing extends StatefulWidget {
  late String geocode;
  Pricing({Key? key, required this.geocode}) : super(key: key);

  @override
  _PricingState createState() => _PricingState();
}

class _PricingState extends State<Pricing> with TickerProviderStateMixin {

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..forward();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );
  var priceOfSpot = 10.0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Spacer(
                flex: 1,
              ),
              Container(
                color: Colors.white,
                child: FadeTransition(
                  opacity: _animation,
                  child: Text(
                    '3. Set the hourly rate for the parking spot.',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
              Container(height: 10,),
              Container(
                height: 300,
                child: Center(
                  child: SleekCircularSlider(
                    min: 0,
                    max: 50,
                    appearance: CircularSliderAppearance(
                      customColors: CustomSliderColors(
                        trackColor: Colors.black45,
                        progressBarColor: Colors.black,
                        shadowColor: Colors.blueGrey,
                      ),
                      size: 200,
                    ),
                    initialValue: 10,
                    onChange: (double value) {
                      priceOfSpot = value;
                    },
                    innerWidget: (double value) {
                      return Center(
                        child: Text(
                          '\$${NumberFormat("#,##0.00", "en_US").format(value)}',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 30,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              FadeTransition(
                opacity: _animation,
                child: TextButton(
                  child: Container(
                    width: MediaQuery.of(context).size.width-30,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.lightBlue,
                    ),
                    child: Text(
                      'Set Price',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  onPressed: () async {
                    await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('spots').doc(widget.geocode).set({
                      'geocode': widget.geocode,
                      'rate': toDouble(NumberFormat("#,##0.00", "en_US").format(priceOfSpot)),
                    }).then((value) async {
                      await FirebaseFirestore.instance.collection('spots').doc(widget.geocode).set({
                        'id': widget.geocode,
                        'rate': toDouble(NumberFormat("#,##0.00", "en_US").format(priceOfSpot)),
                        'isOccupied': false,
                        'uid': FirebaseAuth.instance.currentUser!.uid,
                      }).then((otherValue) {
                        Navigator.of(context).push(CupertinoPageRoute(builder: (context) => QRResult(geocode: widget.geocode,)));
                      });
                    });
                  },
                ),
              ),
              Spacer(
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QRResult extends StatefulWidget {
  late String geocode;
  QRResult({Key? key, required this.geocode}) : super(key: key);
  @override
  _QRResultState createState() => _QRResultState();
}

class _QRResultState extends State<QRResult> with TickerProviderStateMixin {

  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..forward();
  late final Animation<double> _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Spacer(
                flex: 1,
              ),
              Container(
                color: Colors.white,
                child: FadeTransition(
                  opacity: _animation,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      '4. Take a screenshot and print the QR Code out. Then, place it on the parking spot.',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
              ),
              Container(height: 10,),
              QrImage(
                data: 'parkit${widget.geocode}^${FirebaseAuth.instance.currentUser!.uid}',
              ),
              FadeTransition(
                opacity: _animation,
                child: TextButton(
                  child: Container(
                    width: MediaQuery.of(context).size.width-30,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.lightBlue,
                    ),
                    child: Text(
                      'Continue',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => InfoPage()),ModalRoute.withName('/screens'));
                  },
                ),
              ),
              Spacer(
                flex: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
