import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sellingshop/models/shop_model.dart';
import 'package:sellingshop/states/admin_showshop.dart';
import 'package:sellingshop/utility/my_constant.dart';
import 'package:sellingshop/widgets/show_image.dart';
import 'package:sellingshop/widgets/show_progress.dart';
import 'package:sellingshop/widgets/show_title.dart';

class AdminShop extends StatefulWidget {
  const AdminShop({Key? key}) : super(key: key);

  @override
  _AdminShopState createState() => _AdminShopState();
}

class _AdminShopState extends State<AdminShop> {
  bool load = true;
  List<ShopModel> shopModel = [];

  @override
  void initState() {
    super.initState();
    getShop();
  }

  Future getShop() async {
    if (shopModel.isNotEmpty) {
      shopModel.clear();
    }
    String path = '${MyConstant.domain}/phpTemplate/restaurant/getAllShop.php';
    await Dio().get(path).then((value) {
      for (var item in json.decode(value.data)) {
        ShopModel model = ShopModel.fromMap(item);
        setState(() {
          shopModel.add(model);
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
                itemCount: shopModel.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    childAspectRatio: 2 / 2, maxCrossAxisExtent: 240),
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminShowShop(
                          shopModel: shopModel[index],
                        ),
                      ),
                    ).then((value) {
                      return getShop();
                    });
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 150,
                            height: 100,
                            child: CachedNetworkImage(
                              imageUrl: shopModel[index].image,
                              placeholder: (context, url) =>
                                  const ShowProgress(),
                              errorWidget: (context, url, error) =>
                                  ShowImage(path: MyConstant.error),
                            ),
                          ),
                          ShowTitle(
                              title: shopModel[index].name,
                              textStyle: MyConstant().h2Style()),
                          ShowTitle(
                              title: shopModel[index].address,
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
                .then((value) => getShop()),
        child: const Icon(Icons.add_outlined),
      ),
    );
  }
}
