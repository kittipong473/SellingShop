import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sellingshop/models/shop_model.dart';
import 'package:sellingshop/utility/my_constant.dart';
import 'package:sellingshop/utility/my_dialog.dart';
import 'package:sellingshop/widgets/show_image.dart';
import 'package:sellingshop/widgets/show_progress.dart';
import 'package:sellingshop/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalerShop extends StatefulWidget {
  const SalerShop({Key? key}) : super(key: key);

  @override
  _SalerShopState createState() => _SalerShopState();
}

class _SalerShopState extends State<SalerShop> {
  ShopModel? shopModel;
  int index = 0;
  FijkPlayer player = FijkPlayer();
  bool load = true;
  List<String> pathImage = [];
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
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('manage')!;
    String path =
        '${MyConstant.domain}/phpTemplate/restaurant/getShopWhereId.php?isAdd=true&id=$id';
    await Dio().get(path).then((value) {
      for (var item in json.decode(value.data)) {
        setState(() {
          shopModel = ShopModel.fromMap(item);
          player.setDataSource(
            '${MyConstant.domain}${shopModel!.video}',
            autoPlay: true,
            showCover: false,
          );
          load = false;
          shopModel == null ? const ShowProgress() : convertArray();
        });
      }
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
          MyDialog().alertLocationService(context, 'ไม่สามารถใช้งานได้',
              'กรุณาอนุญาตการเข้าถึง Location เพื่อเข้าใช้งานแอพพลิเคชั่น');
        } else {
          // Find LatLng
        }
      } else {
        if (locationPermission == LocationPermission.deniedForever) {
          MyDialog().alertLocationService(context, 'ไม่สามารถใช้งานได้',
              'กรุณาอนุญาตการเข้าถึง Location เพื่อเข้าใช้งานแอพพลิเคชั่น');
        } else {
          // Find LatLng
        }
      }
    } else {
      MyDialog().alertLocationService(context, 'Location ของคุณปิดอยู่',
          'กรูณาเปิด Location เพื่อเข้าใช้งานแอพพลิเคชั่น');
    }
  }

  void convertArray() {
    String string = shopModel!.advert;
    string = string.substring(1, string.length - 1);
    List<String> strings = string.split(',');
    for (var item in strings) {
      pathImage.add(item.trim());
    }
    getOpenClose();
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
        if (time.hour >= MyConstant.weOpen && time.hour <= MyConstant.weClose) {
          status = timeshop[0];
        } else {
          status = timeshop[1];
        }
      }
    } else {
      status = timeshop[2];
    }
  }

  @override
  Widget build(BuildContext context) {
    return shopModel == null
        ? const ShowProgress()
        : Scaffold(
            body: LayoutBuilder(
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
                      buildName(),
                      const SizedBox(height: 30),
                      buildPhone(),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ShowTitle(
                            title: 'วีดีโอของร้านค้า : ',
                            textStyle: MyConstant().h2Style()),
                      ),
                      buildVideo(constraints),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: ShowTitle(
                            title: 'รูปภาพของร้านค้า : ',
                            textStyle: MyConstant().h2Style()),
                      ),
                      buildImage(constraints),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: ShowTitle(
                            title: 'ภาพโฆษณา/โปรโมชั่น : ',
                            textStyle: MyConstant().h2Style()),
                      ),
                      buildAdvert(constraints),
                      const SizedBox(height: 20),
                      ShowTitle(
                          title: 'ตำแหน่งร้านค้า :',
                          textStyle: MyConstant().h2Style()),
                      buildMap(constraints),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: MyConstant.dark,
              onPressed: () =>
                  Navigator.pushNamed(context, MyConstant.routeEditShop)
                      .then((value) => getShopModel()),
              child: const Icon(Icons.edit_outlined),
            ),
          );
  }

  Row buildMap(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
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

  Row buildVideo(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        load
            ? const ShowProgress()
            : Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                width: constraints.maxWidth * 0.9,
                height: constraints.maxWidth * 0.5,
                child: FijkView(player: player),
              ),
      ],
    );
  }

  Row buildImage(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        load
            ? const ShowProgress()
            : Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                width: constraints.maxWidth * 0.6,
                height: constraints.maxWidth * 0.6,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: '${MyConstant.domain}${shopModel?.image}',
                  placeholder: (context, url) => const ShowProgress(),
                  errorWidget: (context, url, error) =>
                      ShowImage(path: MyConstant.picture),
                ),
              ),
      ],
    );
  }

  Row buildPhone() {
    return Row(
      children: [
        ShowTitle(
            title: 'เบอร์โทรติดต่อ : ', textStyle: MyConstant().h2Style()),
        ShowTitle(title: shopModel!.phone, textStyle: MyConstant().h1Style()),
      ],
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

  Row buildAdvert(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: SizedBox(
                width: constraints.maxWidth * 0.6,
                height: constraints.maxWidth * 0.6,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  imageUrl: '${MyConstant.domain}${pathImage[index]}',
                  placeholder: (context, url) => const ShowProgress(),
                  errorWidget: (context, url, error) =>
                      ShowImage(path: MyConstant.picture),
                ),
              ),
            ),
            SizedBox(
              width: constraints.maxWidth * 0.75,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: InkWell(
                      onTap: () => setState(() {
                        index = 0;
                      }),
                      child: CachedNetworkImage(
                        imageUrl: '${MyConstant.domain}${pathImage[0]}',
                        placeholder: (context, url) => const ShowProgress(),
                        errorWidget: (context, url, error) =>
                            ShowImage(path: MyConstant.error),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: InkWell(
                      onTap: () => setState(() {
                        index = 1;
                      }),
                      child: CachedNetworkImage(
                        imageUrl: '${MyConstant.domain}${pathImage[1]}',
                        placeholder: (context, url) => const ShowProgress(),
                        errorWidget: (context, url, error) =>
                            ShowImage(path: MyConstant.error),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: InkWell(
                      onTap: () => setState(() {
                        index = 2;
                      }),
                      child: CachedNetworkImage(
                        imageUrl: '${MyConstant.domain}${pathImage[2]}',
                        placeholder: (context, url) => const ShowProgress(),
                        errorWidget: (context, url, error) =>
                            ShowImage(path: MyConstant.error),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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

  @override
  void dispose() {
    super.dispose();
    player.release();
  }
}
