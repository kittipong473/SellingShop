import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sellingshop/utility/my_dialog.dart';

class SalerOrder extends StatefulWidget {
  const SalerOrder({Key? key}) : super(key: key);

  @override
  _SalerOrderState createState() => _SalerOrderState();
}

class _SalerOrderState extends State<SalerOrder> {

  String? id;

  @override
  void initState() {
    super.initState();
    checkPermission();
  }

  Future<Null> checkPermission() async {
    bool locationService;
    LocationPermission locationPermission;

    locationService = await Geolocator.isLocationServiceEnabled();
    if (locationService) {
      locationPermission = await Geolocator.checkPermission();
      if (locationPermission == LocationPermission.denied) {
        locationPermission = await Geolocator.requestPermission();
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocationService(context, 'ไม่สามารถใช้งานได้', 'กรุณาอนุญาตการเข้าถึง Location เพื่อเข้าใช้งานแอพพลิเคชั่น');
        } else {
          // Find LatLng
        }
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocationService(context, 'ไม่สามารถใช้งานได้', 'กรุณาอนุญาตการเข้าถึง Location เพื่อเข้าใช้งานแอพพลิเคชั่น');
        } else {
          // Find LatLng
        }
      }
    } else {
      MyDialog().alertLocationService(context, 'Location ของคุณปิดอยู่', 'กรูณาเปิด Location เพื่อเข้าใช้งานแอพพลิเคชั่น');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Text('This is Saler Order'),
    );
  }
}
