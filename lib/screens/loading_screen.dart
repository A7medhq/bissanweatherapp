import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  LoadingScreenState createState() => LoadingScreenState();
}

class LoadingScreenState extends State<LoadingScreen> {
  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: () async {
                Position p = await _determinePosition();
                print(p);
              },
              child: const Text('Get Location'),
            ),
          ),
        ],
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final double borderRadius;

  final Paint _borderPaint = Paint()
    ..color = Colors.grey.shade300
    ..strokeWidth = 1.0
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round;

  final Paint _paint = Paint()
    ..color = Colors.white
    ..strokeWidth = 1.0
    ..style = PaintingStyle.fill
    ..strokeJoin = StrokeJoin.round;

  MyPainter(this.borderRadius);

  @override
  void paint(Canvas canvas, Size size) {
    double x = size.width;
    double y = size.height;
    double arc = borderRadius;
    double yFactor = y * 0.4;
    double xFactor = x * 0.5;
    var path = Path();
    path.moveTo(arc, 0);
    path.lineTo((xFactor) - arc, 0);
    path.quadraticBezierTo(xFactor, 0, xFactor, arc);
    path.lineTo(xFactor, yFactor - arc);
    path.quadraticBezierTo(xFactor, yFactor, xFactor + arc, yFactor);
    path.lineTo(x - arc, yFactor);
    path.quadraticBezierTo(x, yFactor, x, yFactor + arc);
    path.lineTo(x, y - arc);
    path.quadraticBezierTo(x, y, x - arc, y);
    path.lineTo(arc, y);
    path.quadraticBezierTo(0, y, 0, y - arc);
    path.lineTo(0, arc);
    path.quadraticBezierTo(0, 0, arc, 0);

    // path.lineTo(150, 50);
    // path.quadraticBezierTo(200, 50, 200, 100);
    // path.quadraticBezierTo(200, 150, 250, 150);
    // path.lineTo(300, 150);
    // path.quadraticBezierTo(350, 150, 350, 200);
    // path.lineTo(350, 250);
    // path.quadraticBezierTo(350, 300, 300, 300);
    // path.lineTo(50, 300);
    // path.quadraticBezierTo(0, 300, 0, 250);
    // path.lineTo(0, 100);
    // path.quadraticBezierTo(0, 50, 50, 50);
    canvas.drawPath(path, _paint);
    canvas.drawPath(path, _borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
