import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sellingshop/bodys/admin_order.dart';
import 'package:sellingshop/bodys/admin_shop.dart';
import 'package:sellingshop/bodys/admin_user.dart';
import 'package:sellingshop/models/user_model.dart';
import 'package:sellingshop/utility/my_constant.dart';
import 'package:sellingshop/widgets/show_image.dart';
import 'package:sellingshop/widgets/show_progress.dart';
import 'package:sellingshop/widgets/show_signout.dart';
import 'package:sellingshop/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminService extends StatefulWidget {
  const AdminService({Key? key}) : super(key: key);

  @override
  _AdminServiceState createState() => _AdminServiceState();
}

class _AdminServiceState extends State<AdminService> {
  List<Widget> widgets = [
    const AdminShop(),
    const AdminUser(),
  ];
  int indexwidget = 0;
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    getUserModel();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
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
                      menuShop(),
                      menuUser(),
                    ],
                  ),
                ],
              ),
            ),
      body: widgets.isEmpty ? const ShowProgress() : widgets[indexwidget],
    );
  }

   Widget buildHead() {
    return UserAccountsDrawerHeader(
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

  ListTile menuShop() {
    return ListTile(
      onTap: () {
        setState(() {
          indexwidget = 0;
          Navigator.pop(context);
        });
      },
      leading: const Icon(
        Icons.storefront_outlined,
        color: MyConstant.dark,
      ),
      title: ShowTitle(
        title: 'เกี่ยวกับร้านค้า',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'เพิ่ม/ลบ/แก้ไข ร้านอาหาร',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }

  ListTile menuUser() {
    return ListTile(
      onTap: () {
        setState(() {
          indexwidget = 1;
          Navigator.pop(context);
        });
      },
      leading: const Icon(
        Icons.supervised_user_circle_outlined,
        color: MyConstant.dark,
      ),
      title: ShowTitle(
        title: 'เกี่ยวกับผู้ใช้งาน',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: 'เพิ่ม/ลบ/แก้ไข User',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }
}
