import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sellingshop/models/shop_model.dart';
import 'package:sellingshop/states/admin_editshop.dart';
import 'package:sellingshop/utility/my_constant.dart';
import 'package:sellingshop/widgets/show_progress.dart';
import 'package:sellingshop/widgets/show_title.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminShowShop extends StatefulWidget {
  final ShopModel shopModel;
  const AdminShowShop({Key? key, required this.shopModel}) : super(key: key);

  @override
  _AdminShowShopState createState() => _AdminShowShopState();
}

class _AdminShowShopState extends State<AdminShowShop> {
  bool load = true;
  ShopModel? shopModel;
  String? status;
  List<String> timeshop = [];
  var time = DateTime.now();

  @override
  void initState() {
    super.initState();
    shopModel = widget.shopModel;
    shopModel == null ? const ShowProgress() : getOpenClose();
  }

  Future getShopModel() async {
    shopModel = widget.shopModel;
    String id = shopModel!.id;
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

  void getOpenClose() {
    String string = shopModel!.status;
    string = string.substring(1, string.length - 1);
    List<String> strings = string.split(',');
    for (var item in strings) {
      timeshop.add(item.trim());
    }

    if (shopModel!.openclose == '1') {
      if (time.weekday >= 1 && time.weekday <= 5) {
        if (time.hour >= 16 && time.hour <= 21) {
          status = timeshop[0];
        } else {
          status = timeshop[1];
        }
      } else {
        if (time.hour >= 10 && time.hour <= 21) {
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
      appBar: AppBar(
        title: Text('ข้อมูลร้าน : ${shopModel!.name}'),
      ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: MyConstant.dark,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminEditShop(
              shopModel: shopModel!,
            ),
          ),
        ).then((value) => getShopModel()),
        child: const Icon(Icons.edit_outlined),
      ),
    );
  }

   Row buildName() {
    return Row(
      children: [
        ShowTitle(title: 'ชื่อร้านค้า : ', textStyle: MyConstant().h2Style()),
        ShowTitle(title: shopModel!.name, textStyle: MyConstant().h1Style()),
      ],
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
                  await launch(url);
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
