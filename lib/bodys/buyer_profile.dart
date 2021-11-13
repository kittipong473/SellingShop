import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sellingshop/models/user_model.dart';
import 'package:sellingshop/utility/my_constant.dart';
import 'package:sellingshop/widgets/show_image.dart';
import 'package:sellingshop/widgets/show_progress.dart';
import 'package:sellingshop/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyerProfile extends StatefulWidget {
  const BuyerProfile({Key? key}) : super(key: key);

  @override
  _BuyerProfileState createState() => _BuyerProfileState();
}

class _BuyerProfileState extends State<BuyerProfile> {
  bool load = true;
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
          load = false;
          userModel = UserModel.fromMap(item);
        });
      }
    });
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
                      buildImage(constraints),
                      buildName(),
                      const SizedBox(height: 30),
                      buildPhone(),
                      const SizedBox(height: 30),
                      buildEmail(),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Row buildImage(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 30),
          width: constraints.maxWidth * 0.4,
          child: ShowImage(path: MyConstant.user),
        ),
      ],
    );
  }

  Row buildName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowTitle(title: 'ชื่อ-นามสกุล : ', textStyle: MyConstant().h2Style()),
        ShowTitle(title: userModel!.name, textStyle: MyConstant().h1Style()),
      ],
    );
  }

  Row buildPhone() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowTitle(title: 'เบอร์โทร : ', textStyle: MyConstant().h2Style()),
        ShowTitle(title: userModel!.phone, textStyle: MyConstant().h1Style()),
      ],
    );
  }

  Row buildEmail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShowTitle(title: 'อีเมล : ', textStyle: MyConstant().h2Style()),
        ShowTitle(title: userModel!.email, textStyle: MyConstant().h1Style()),
      ],
    );
  }
}
