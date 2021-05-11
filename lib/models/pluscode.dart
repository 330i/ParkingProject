import 'package:open_location_code/open_location_code.dart' as olc;
import 'package:geolocator/geolocator.dart';

Future<Position> _getCurrentPosition() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location service disabled.');
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    return Future.error('Permission permanently denied');
  }
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return Future.error('Permission denied');
    }
  }
  return await Geolocator.getCurrentPosition();
}

Future<String> getPlusCode() async {
  Position _currentPos = await _getCurrentPosition();
  return olc.encode(_currentPos.latitude, _currentPos.longitude, codeLength: 12);
}

List<double> getPosition(String fromPlusCode) {
  olc.CodeArea code = olc.decode(fromPlusCode);
  return [code.center.latitude.toDouble(), code.center.longitude.toDouble()];
}