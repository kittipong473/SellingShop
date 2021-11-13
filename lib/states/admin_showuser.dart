import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sellingshop/models/user_model.dart';
import 'package:sellingshop/states/admin_edituser.dart';
import 'package:sellingshop/utility/my_constant.dart';
import 'package:sellingshop/widgets/show_progress.dart';

class AdminShowUser extends StatefulWidget {
  final UserModel userModel;
  const AdminShowUser({ Key? key, required this.userModel}) : super(key: key);

  @override
  _AdminShowUserState createState() => _AdminShowUserState();
}

class _AdminShowUserState extends State<AdminShowUser> {
  bool load = true;
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    userModel = widget.userModel;
    load = false;
  }

  Future getUserModel() async {
    userModel = widget.userModel;
    String id = userModel!.id;
    String path =
        '${MyConstant.domain}/phpTemplate/restaurant/getShopWhereId.php?isAdd=true&id=$id';
    await Dio().get(path).then((value) {
      for (var item in json.decode(value.data)) {
        setState(() {
          userModel = UserModel.fromMap(item);
        });
      }
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ข้อมูล User : ${userModel!.name}'),
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
            builder: (context) => AdminEditUser(
              userModel: userModel!,
            ),
          ),
        ).then((value) => getUserModel()),
        child: const Icon(Icons.edit_outlined),
      ),
    );
  }
}