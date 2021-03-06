import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sellingshop/bodys/saler_order.dart';
import 'package:sellingshop/bodys/saler_product.dart';
import 'package:sellingshop/bodys/saler_shop.dart';
import 'package:sellingshop/models/user_model.dart';
import 'package:sellingshop/utility/my_constant.dart';
import 'package:sellingshop/widgets/show_image.dart';
import 'package:sellingshop/widgets/show_progress.dart';
import 'package:sellingshop/widgets/show_signout.dart';
import 'package:sellingshop/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SalerService extends StatefulWidget {
  const SalerService({Key? key}) : super(key: key);

  @override
  _SalerServiceState createState() => _SalerServiceState();
}

class _SalerServiceState extends State<SalerService> {
  List<Widget> widgets = [
    const SalerProduct(),
    const SalerShop()
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
        title: Text(MyConstant.appName),
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
                      menuProduct(),
                      menuShop(),
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

  ListTile menuOrder() {
    return ListTile(
      onTap: () {
        setState(() {
          // indexwidget = 0;
          Navigator.pop(context);
        });
      },
      leading: const Icon(
        Icons.event_note_outlined,
        color: MyConstant.dark,
      ),
      title: ShowTitle(
        title: '????????????????????????????????????????????????',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: '?????????????????????????????????????????? ????????????????????????????????????????????????????????????????????????????????????',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }

  ListTile menuProduct() {
    return ListTile(
      onTap: () {
        setState(() {
          indexwidget = 0;
          Navigator.pop(context);
        });
      },
      leading: const Icon(
        Icons.flatware_outlined,
        color: MyConstant.dark,
      ),
      title: ShowTitle(
        title: '?????????????????????????????????????????????',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: '???????????????/??????/??????????????? ???????????????????????????',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }

  ListTile menuShop() {
    return ListTile(
      onTap: () {
        setState(() {
          indexwidget = 1;
          Navigator.pop(context);
        });
      },
      leading: const Icon(
        Icons.storefront_outlined,
        color: MyConstant.dark,
      ),
      title: ShowTitle(
        title: '??????????????????????????????????????????',
        textStyle: MyConstant().h2Style(),
      ),
      subtitle: ShowTitle(
        title: '????????????????????????/??????????????? ????????????????????????????????? ????????? location',
        textStyle: MyConstant().h3Style(),
      ),
    );
  }
}
