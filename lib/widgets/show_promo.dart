import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sellingshop/models/product_model.dart';
import 'package:sellingshop/utility/my_constant.dart';
import 'package:sellingshop/widgets/show_image.dart';
import 'package:sellingshop/widgets/show_progress.dart';
import 'package:sellingshop/widgets/show_title.dart';

class ShowPromo extends StatefulWidget {
  final String type;
  const ShowPromo({Key? key, required this.type}) : super(key: key);

  @override
  _ShowPromoState createState() => _ShowPromoState();
}

class _ShowPromoState extends State<ShowPromo> {
  String? type;
  bool load = true;
  bool? data;
  List<ProductModel> productModel = [];

  @override
  void initState() {
    super.initState();
    getProduct();
  }

  Future getProduct() async {
    if (productModel.isNotEmpty) {
      productModel.clear();
    }

    String type = widget.type;
    String path =
        '${MyConstant.domain}/phpTemplate/restaurant/getProductWhereType.php?isAdd=true&type=$type';
    await Dio().get(path).then((value) {
      for (var item in json.decode(value.data)) {
        if (value.toString() == 'null') {
          setState(() {
            load = false;
            data = false;
          });
        } else {
          ProductModel model = ProductModel.fromMap(item);
          setState(() {
            load = false;
            data = true;
            productModel.add(model);
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: load
          ? const ShowProgress()
          : data!
              ? LayoutBuilder(
                  builder: (context, constraints) => GridView.builder(
                    itemCount: productModel.length,
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        childAspectRatio: 2 / 3, maxCrossAxisExtent: 160),
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        showAlertDialog(
                          productModel[index],
                        );
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl:
                                      '${MyConstant.domain}${productModel[index].image}',
                                  placeholder: (context, url) => const ShowProgress(),
                                  errorWidget: (context, url, error) =>
                                      ShowImage(path: MyConstant.error),
                                ),
                              ),
                              ShowTitle(
                                  title: cutWord(productModel[index].name),
                                  textStyle: MyConstant().h3Style()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShowTitle(
                          title: 'ยังไม่มีโปรโมชั่นในขณะนี้',
                          textStyle: MyConstant().h1Style()),
                      ShowTitle(
                          title: 'กรุณาติดตามโปรโมชั่นใหม่ในภายหลัง',
                          textStyle: MyConstant().h2Style()),
                    ],
                  ),
                ),
    );
  }

  Future showAlertDialog(ProductModel productModel) async {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShowTitle(
                    title: productModel.name,
                    textStyle: MyConstant().h2Style()),
              ],
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CachedNetworkImage(
                  imageUrl: '${MyConstant.domain}${productModel.image}',
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ShowTitle(
                              title: 'รายละเอียดสินค้า : ',
                              textStyle: MyConstant().h2Style()),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 250,
                            child: ShowTitle(
                                title: productModel.detail,
                                textStyle: MyConstant().h3Style()),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'ตกลง',
                    style: MyConstant().h2BlueStyle(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String cutWord(String name) {
    String result = name;
    if (result.length > 20) {
      result = result.substring(0, 16);
      result = '$result ...';
    }
    return result;
  }
}
