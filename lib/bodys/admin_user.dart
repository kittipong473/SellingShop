import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sellingshop/models/user_model.dart';
import 'package:sellingshop/states/admin_showuser.dart';
import 'package:sellingshop/utility/my_constant.dart';
import 'package:sellingshop/widgets/show_progress.dart';
import 'package:sellingshop/widgets/show_title.dart';

class AdminUser extends StatefulWidget {
  const AdminUser({Key? key}) : super(key: key);

  @override
  _AdminUserState createState() => _AdminUserState();
}

class _AdminUserState extends State<AdminUser> {
  List<UserModel> userModel = [];
  bool load = true;

  @override
  void initState() {
    super.initState();
    getAllUser();
  }

  Future getAllUser() async {
    if (userModel.isNotEmpty) {
      userModel.clear();
    }

    String path = '${MyConstant.domain}/phpTemplate/restaurant/getAllUser.php';
    await Dio().get(path).then((value) {
      for (var item in json.decode(value.data)) {
        UserModel model = UserModel.fromMap(item);
        setState(() {
          userModel.add(model);
        });
      }
      load = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? const ShowProgress()
          : LayoutBuilder(
              builder: (context, constraints) => GridView.builder(
                itemCount: userModel.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    childAspectRatio: 2 / 2, maxCrossAxisExtent: 240),
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminShowUser(
                                userModel: userModel[index],
                              ),
                            ),
                          ).then((value) {
                            return getAllUser();
                          });
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset(MyConstant.user)),
                          ShowTitle(
                              title: userModel[index].name,
                              textStyle: MyConstant().h3Style()),
                          ShowTitle(
                              title: userModel[index].role,
                              textStyle: MyConstant().h3Style()),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
             floatingActionButton: FloatingActionButton(
              backgroundColor: MyConstant.dark,
              onPressed: () =>
                  Navigator.pushNamed(context, MyConstant.routeAdminAddShop)
                      .then((value) => getAllUser()),
              child: const Icon(Icons.add_outlined),
            ),
    );
  }
}
