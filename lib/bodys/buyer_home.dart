import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:dio/dio.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:sellingshop/models/shop_model.dart';
import 'package:sellingshop/utility/my_constant.dart';
import 'package:sellingshop/widgets/show_image.dart';
import 'package:sellingshop/widgets/show_progress.dart';
import 'package:sellingshop/widgets/show_title.dart';

class BuyerHome extends StatefulWidget {
  const BuyerHome({Key? key}) : super(key: key);

  @override
  _BuyerHomeState createState() => _BuyerHomeState();
}

class _BuyerHomeState extends State<BuyerHome> {
  ShopModel? shopModel;
  bool load = true;
  FijkPlayer player = FijkPlayer();
  List<String> adverts = [];
  String showImage = MyConstant.menu1;

  @override
  void initState() {
    super.initState();
    getShopModel();
  }

  Future getShopModel() async {
    String path =
        '${MyConstant.domain}/phpTemplate/restaurant/getShopWhereId.php?isAdd=true&id=1';
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

  void convertArray() {
    String string = shopModel!.advert;
    string = string.substring(1, string.length - 1);
    List<String> strings = string.split(',');
    for (var item in strings) {
      adverts.add(item.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return load
        ? const ShowProgress()
        : Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: Column(
                  children: [
                    buildAdvert(constraints),
                    const SizedBox(height: 30.0),
                    buildProfile(constraints),
                    const SizedBox(height: 30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShowTitle(
                          title: 'CHAROZ',
                          textStyle: MyConstant().h1Style(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: constraints.maxWidth * 0.8,
                          child: ShowTitle(
                              title: shopModel!.time,
                              textStyle: MyConstant().h2Style()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: constraints.maxWidth * 0.8,
                          child: ShowTitle(
                              title:
                                  'ร้านอาหารที่สามารถนั่งทานในร้านได้ หรือ สั่งกลับบ้านผ่านทาง Line Man หรือ Robinhood ได้ ร้านค้าบรรยากาศดี มีเพลงฟัง เป็นกันเอง ยินดีให้บริการลูกค้าทุกท่านครับ',
                              textStyle: MyConstant().h2Style()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShowTitle(
                          title: 'คำอธิบาย :',
                          textStyle: MyConstant().h2Style(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: constraints.maxWidth * 0.8,
                          child: ShowTitle(
                              title: shopModel!.desc,
                              textStyle: MyConstant().h2Style()),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ShowTitle(
                          title: 'เมนูอาหารที่แนะนำ :',
                          textStyle: MyConstant().h2Style(),
                        ),
                      ],
                    ),
                    buildImage(constraints),
                    const SizedBox(height: 30.0),
                  ],
                ),
              ),
            ),
          );
  }

  Row buildAdvert(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxWidth * 0.5,
          child: Carousel(
            dotSize: 4.0,
            dotSpacing: 15.0,
            dotColor: MyConstant.dark,
            indicatorBgPadding: 5.0,
            dotBgColor: Colors.transparent,
            dotVerticalPadding: 5.0,
            images: [
              InkWell(
                onTap: () {
                  showPicture('${MyConstant.domain}${adverts[0]}', constraints);
                },
                child: CachedNetworkImage(
                  imageUrl: '${MyConstant.domain}${adverts[0]}',
                  placeholder: (context, url) => const ShowProgress(),
                  errorWidget: (context, url, error) =>
                      ShowImage(path: MyConstant.error),
                ),
              ),
              InkWell(
                onTap: () {
                  showPicture('${MyConstant.domain}${adverts[1]}', constraints);
                },
                child: CachedNetworkImage(
                  imageUrl: '${MyConstant.domain}${adverts[1]}',
                  placeholder: (context, url) => const ShowProgress(),
                  errorWidget: (context, url, error) =>
                      ShowImage(path: MyConstant.error),
                ),
              ),
              InkWell(
                onTap: () {
                  showPicture('${MyConstant.domain}${adverts[2]}', constraints);
                },
                child: CachedNetworkImage(
                  imageUrl: '${MyConstant.domain}${adverts[2]}',
                  placeholder: (context, url) => const ShowProgress(),
                  errorWidget: (context, url, error) =>
                      ShowImage(path: MyConstant.error),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Row buildProfile(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: Colors.black,
          width: constraints.maxWidth * 0.8,
          height: constraints.maxWidth * 0.5,
          child: load ? const ShowProgress() : FijkView(player: player),
        ),
      ],
    );
  }

  Row buildImage(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30.0),
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxWidth,
                child: Image.asset(
                  showImage,
                  width: 200,
                  height: 200,
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
                        showImage = MyConstant.menu1;
                      }),
                      child: ShowImage(path: MyConstant.menu1),
                    ),
                  ),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: InkWell(
                      onTap: () => setState(() {
                        showImage = MyConstant.menu2;
                      }),
                      child: ShowImage(path: MyConstant.menu2),
                    ),
                  ),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: InkWell(
                      onTap: () => setState(() {
                        showImage = MyConstant.menu3;
                      }),
                      child: ShowImage(path: MyConstant.menu3),
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

  Future showPicture(String url, BoxConstraints constraints) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxWidth * 0.5,
          child: CachedNetworkImage(
            imageUrl: url,
            placeholder: (context, url) => const ShowProgress(),
            errorWidget: (context, url, error) =>
                ShowImage(path: MyConstant.error),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    player.release();
  }
}
