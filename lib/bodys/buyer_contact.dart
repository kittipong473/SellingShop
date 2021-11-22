import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sellingshop/models/shop_model.dart';
import 'package:sellingshop/utility/my_constant.dart';
import 'package:sellingshop/utility/my_dialog.dart';
import 'package:sellingshop/widgets/show_progress.dart';
import 'package:sellingshop/widgets/show_title.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

class BuyerContact extends StatefulWidget {
  const BuyerContact({Key? key}) : super(key: key);

  @override
  _BuyerContactState createState() => _BuyerContactState();
}

class _BuyerContactState extends State<BuyerContact> {
  bool load = true;
  ShopModel? shopModel;
  String? status;
  List<String> timeshop = [];
  var time = DateTime.now();

  @override
  void initState() {
    super.initState();
    checkPermission();
    getShopModel();
  }

  Future getShopModel() async {
    String id = '1';
    String path =
        '${MyConstant.domain}/phpTemplate/restaurant/getShopWhereId.php?isAdd=true&id=$id';
    await Dio().get(path).then((value) {
      for (var item in json.decode(value.data)) {
        setState(() {
          shopModel = ShopModel.fromMap(item);
        });
      }
      shopModel == null ? const ShowProgress() : getOpenClose();
    });
  }

  Future checkPermission() async {
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

  void getOpenClose() {
    String string = shopModel!.status;
    string = string.substring(1, string.length - 1);
    List<String> strings = string.split(',');
    for (var item in strings) {
      timeshop.add(item.trim());
    }

    if (shopModel!.openclose == '1') {
      if (time.weekday >= 1 && time.weekday <= 5) {
        if (time.hour >= MyConstant.wdOpen && time.hour <= MyConstant.wdClose) {
          status = timeshop[0];
        } else {
          status = timeshop[1];
        }
      } else {
        if (time.hour >= MyConstant.weOpen && time.hour <=MyConstant.weClose) {
          status = timeshop[0];
        } else {
          status = timeshop[1];
        }
      }
    } else {
      status = timeshop[2];
    }
    load = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? const ShowProgress()
          : LayoutBuilder(
              builder: (context, constraints) => Padding(
                padding: const EdgeInsets.all(10.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildStatus(),
                      const SizedBox(height: 30),
                      buildTime(constraints),
                      const SizedBox(height: 30),
                      buildDesc(constraints),
                      const SizedBox(height: 30),
                      buildPhone(),
                      const SizedBox(height: 30),
                      buildLink(),
                      const SizedBox(height: 30),
                      buildAddress(constraints),
                      const SizedBox(height: 30),
                      ShowTitle(
                          title: 'ตำแหน่งร้านค้า :',
                          textStyle: MyConstant().h2Style()),
                      buildMap(constraints),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Row buildStatus() {
    return Row(
      children: [
        ShowTitle(title: 'สถานะร้านค้า : ', textStyle: MyConstant().h2Style()),
        ShowTitle(title: status!, textStyle: MyConstant().h1Style()),
      ],
    );
  }

  Row buildPhone() {
    return Row(
      children: [
        ShowTitle(
            title: 'เบอร์โทรติดต่อ : ', textStyle: MyConstant().h2Style()),
        ShowTitle(title: shopModel!.phone, textStyle: MyConstant().h2Style()),
      ],
    );
  }

  Row buildLink() {
    return Row(
      children: [
        ShowTitle(title: 'Page ของร้าน : ', textStyle: MyConstant().h2Style()),
        RichText(
          text: TextSpan(
            style: const TextStyle(color: Colors.blue),
            text: 'Charoz Facebook Page',
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                var url = "https://www.facebook.com/Charozc4fe";
                if (await canLaunch(url)) {
                  await launch(url,forceSafariVC: true,forceWebView: true,enableJavaScript: true);
                } else {
                  throw 'Could not launch $url';
                }
              },
          ),
        ),
      ],
    );
  }

  Row buildDesc(BoxConstraints constraints) {
    return Row(
      children: [
        ShowTitle(title: 'คำอธิบาย : ', textStyle: MyConstant().h2Style()),
        SizedBox(
          width: constraints.maxWidth * 0.7,
          child: ShowTitle(
              title: shopModel!.desc, textStyle: MyConstant().h2Style()),
        ),
      ],
    );
  }

  Row buildTime(BoxConstraints constraints) {
    return Row(
      children: [
        ShowTitle(title: 'ช่วงเวลา : ', textStyle: MyConstant().h2Style()),
        SizedBox(
          width: constraints.maxWidth * 0.7,
          child: ShowTitle(
              title: shopModel!.time, textStyle: MyConstant().h2Style()),
        ),
      ],
    );
  }

  Row buildAddress(BoxConstraints constraints) {
    return Row(
      children: [
        ShowTitle(title: 'สถานที่ : ', textStyle: MyConstant().h2Style()),
        SizedBox(
          width: constraints.maxWidth * 0.7,
          child: ShowTitle(
              title: shopModel!.address, textStyle: MyConstant().h2Style()),
        ),
      ],
    );
  }

  Row buildMap(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          width: constraints.maxWidth * 0.8,
          height: constraints.maxWidth * 0.8,
          child: shopModel == null
              ? const ShowProgress()
              : GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      double.parse(shopModel!.lat),
                      double.parse(shopModel!.lng),
                    ),
                    zoom: 18,
                  ),
                  markers: <Marker>{
                    Marker(
                      markerId: const MarkerId('id'),
                      position: LatLng(
                        double.parse(shopModel!.lat),
                        double.parse(shopModel!.lng),
                      ),
                      infoWindow: InfoWindow(
                          title: shopModel!.name, snippet: shopModel!.address),
                    ),
                  },
                ),
        ),
      ],
    );
  }
}
