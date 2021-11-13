import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sellingshop/models/shop_model.dart';
import 'package:sellingshop/utility/my_constant.dart';
import 'package:sellingshop/utility/my_dialog.dart';
import 'package:sellingshop/widgets/show_menu.dart';
import 'package:sellingshop/widgets/show_promo.dart';

class BuyerOrder extends StatefulWidget {
  const BuyerOrder({Key? key}) : super(key: key);

  @override
  _BuyerOrderState createState() => _BuyerOrderState();
}

class _BuyerOrderState extends State<BuyerOrder> {
  ShopModel? shopModel;
  String? status;

  @override
  void initState() {
    super.initState();
  }

  Future getShopStatus() async {
    String id = '1';
    String path =
        '${MyConstant.domain}/phpTemplate/restaurant/getShopWhereId.php?isAdd=true&id=$id';
    await Dio().get(path).then((value) {
      for (var item in json.decode(value.data)) {
        setState(() {
          shopModel = ShopModel.fromMap(item);
          status = shopModel!.status;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [MyConstant.light, MyConstant.primary],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 5,
            tabs: [
              Tab(
                icon: Icon(Icons.lunch_dining_outlined),
                text: 'อาหาร',
              ),
              Tab(
                icon: Icon(Icons.icecream_outlined),
                text: 'ของหวาน',
              ),
              Tab(
                icon: Icon(Icons.local_bar_outlined),
                text: 'เครื่องดื่ม',
              ),
              Tab(
                icon: Icon(Icons.menu_book_outlined),
                text: 'โปรโมชั่น',
              ),
            ],
          ),
          elevation: 20,
          titleSpacing: 20,
        ),
        body: const TabBarView(
          children: [
            ShowMenu(type: 'อาหาร'),
            ShowMenu(type: 'ของหวาน'),
            ShowMenu(type: 'เครื่องดื่ม'),
            ShowPromo(type: 'โปรโมชั่น'),
          ],
        ),
      ),
    );
  }
}
