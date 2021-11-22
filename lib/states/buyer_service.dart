import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sellingshop/bodys/buyer_closed.dart';
import 'package:sellingshop/bodys/buyer_contact.dart';
import 'package:sellingshop/bodys/buyer_data.dart';
import 'package:sellingshop/bodys/buyer_home.dart';
import 'package:sellingshop/bodys/buyer_order.dart';
import 'package:sellingshop/bodys/buyer_profile.dart';
import 'package:sellingshop/models/shop_model.dart';
import 'package:sellingshop/models/user_model.dart';
import 'package:sellingshop/utility/my_constant.dart';
import 'package:sellingshop/utility/my_dialog.dart';
import 'package:sellingshop/widgets/show_image.dart';
import 'package:sellingshop/widgets/show_progress.dart';
import 'package:sellingshop/widgets/show_signout.dart';
import 'package:sellingshop/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyerService extends StatefulWidget {
  const BuyerService({Key? key}) : super(key: key);

  @override
  _BuyerServiceState createState() => _BuyerServiceState();
}

class _BuyerServiceState extends State<BuyerService> {
  List<Widget> widgets = [
    const BuyerHome(),
    const BuyerOrder(),
    const BuyerProfile(),
    const BuyerData(),
    const BuyerContact(),
    const BuyerClosed(),
  ];
  int indexwidget = 1;
  UserModel? userModel;
  ShopModel? shopModel;
  String? status;

  @override
  void initState() {
    super.initState();
  }

  Future getUserModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('id')!;
    String path =
        '${MyConstant.domain}/phpTemplate/restaurant/getUserWhereId.php?isAdd=true&id=$id';
    await Dio().get(path).then((value) {
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
        });
      }
    });
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
    return Scaffold(
      appBar: AppBar(
        title: Text(MyConstant.appName),
        backgroundColor: MyConstant.primary,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              colors: [MyConstant.light, MyConstant.primary],
              center: Alignment(-0.45, 0),
              radius: 0.6,
            ),
          ),
        ),
      ),
      drawer: widgets.isEmpty
          ? const SizedBox()
          : Drawer(
              child: Stack(
                children: [
                  const ShowSignOut(),
                  Column(
                    children: [
                      buildHead(),
                      menuOrder(),
                      menuProfile(),
                      menuData(),
                      menuContact(),
                    ],
                  ),
                ],
              ),
            ),
      body: widgets.isEmpty ? const ShowProgress() : widgets[indexwidget],
    );
  }

  UserAccountsDrawerHeader buildHead() {
    return UserAccountsDrawerHeader(
      otherAccountsPictures: [
        IconButton(
          onPressed: () {
            setState(() {
              indexwidget = 0;
              Navigator.pop(context);
            });
          },
          icon: const Icon(Icons.home_rounded),
          iconSize: 36,
          color: MyConstant.light,
          tooltip: 'Home Page',
        ),
      ],
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          colors: [MyConstant.light, MyConstant.dark],
          center: Alignment(-0.7, 0),
          radius: 0.6,
        ),
      ),
      currentAccountPicture: ShowImage(path: MyConstant.user),
      accountName: Text(userModel == null ? 'Name ?' : userModel!.name),
      accountEmail: Text(userModel == null ? 'Role ?' : userModel!.role),
    );
  }

  ListTile menuOrder() {
    return ListTile(
      onTap: () async {
        setState(() {
          getShopStatus();
          if (status == null) {
            const ShowProgress();
          } else {
            // if (status == 'เปิดบริการ') {
            //   indexwidget = 1;
            //   Navigator.pop(context);
            // } else {
            //   MyDialog().normalDialog(context, 'ร้านค้าปิดให้บริการแล้ว',
            //       'ขออภัยค่ะ โปรดใช้บริการใหม่ในภายหลัง');
            // }
            indexwidget = 1;
            Navigator.pop(context);
          }
        });
      },
      leading: const Icon(
        Icons.event_note_outlined,
        color: MyConstant.dark,
      ),
      title: ShowTitle(
        title: 'สั่งอาหาร',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'สั่งอาหารทางร้านค้า แบบรับที่ร้าน/จัดส่ง',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }

  ListTile menuProfile() {
    return ListTile(
      onTap: () {
        setState(() {
          indexwidget = 2;
          Navigator.pop(context);
        });
      },
      leading: const Icon(
        Icons.perm_identity_outlined,
        color: MyConstant.dark,
      ),
      title: ShowTitle(
        title: 'ข้อมูลส่วนตัว',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'แสดง/แก้ไข ข้อมูลส่วนตัว',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }

  ListTile menuData() {
    return ListTile(
      onTap: () {
        setState(() {
          indexwidget = 3;
          Navigator.pop(context);
        });
      },
      leading: const Icon(
        Icons.view_list_outlined,
        color: MyConstant.dark,
      ),
      title: ShowTitle(
        title: 'ประวัติการสั่งอาหาร',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'แสดงประวัติที่คุณเคยสั่งอาหารไปแล้ว',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }

  ListTile menuContact() {
    return ListTile(
      onTap: () {
        setState(() {
          indexwidget = 4;
          Navigator.pop(context);
        });
      },
      leading: const Icon(
        Icons.place_outlined,
        color: MyConstant.dark,
      ),
      title: ShowTitle(
        title: 'เกี่ยวกับร้านค้า',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'แสดงคำอธิบายและข้อมูลติดต่อร้านค้า',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }
}
