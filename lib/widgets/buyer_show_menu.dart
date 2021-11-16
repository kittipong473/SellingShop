import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sellingshop/models/product_model.dart';
import 'package:sellingshop/models/sqlite_model.dart';
import 'package:sellingshop/utility/my_constant.dart';
import 'package:sellingshop/utility/sqlite_helper.dart';
import 'package:sellingshop/widgets/show_image.dart';
import 'package:sellingshop/widgets/show_progress.dart';
import 'package:sellingshop/widgets/show_title.dart';

class ShowMenu extends StatefulWidget {
  final String type;
  const ShowMenu({Key? key, required this.type}) : super(key: key);

  @override
  _ShowMenuState createState() => _ShowMenuState();
}

class _ShowMenuState extends State<ShowMenu> {
  String? type;
  bool load = true;
  int count = 1;
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

    type = widget.type;
    String path =
        '${MyConstant.domain}/phpTemplate/restaurant/getProductWhereType.php?isAdd=true&type=$type';
    await Dio().get(path).then((value) {
      for (var item in json.decode(value.data)) {
        ProductModel model = ProductModel.fromMap(item);
        setState(() {
          load = false;
          productModel.add(model);
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
                              placeholder: (context, url) =>
                                  const ShowProgress(),
                              errorWidget: (context, url, error) =>
                                  ShowImage(path: MyConstant.error),
                            ),
                          ),
                          ShowTitle(
                              title: cutWord(productModel[index].name),
                              textStyle: MyConstant().h3Style()),
                          ShowTitle(
                              title: '${productModel[index].price}.-',
                              textStyle: MyConstant().h3Style()),
                        ],
                      ),
                    ),
                  ),
                ),
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
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShowTitle(
                    title: 'ราคา : ${productModel.price} บาท',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShowTitle(
                        title: 'สถานะสินค้า : ',
                        textStyle: MyConstant().h2Style()),
                    ShowTitle(
                        title: productModel.status,
                        textStyle: MyConstant().h2Style()),
                  ],
                ),
                /*
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        if (count > 1) {
                          setState(() {
                            count--;
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.remove_circle_outline,
                        color: MyConstant.dark,
                      ),
                    ),
                    ShowTitle(
                        title: count.toString(),
                        textStyle: MyConstant().h1Style()),
                    IconButton(
                      onPressed: () {
                        if (count < 10) {
                          setState(() {
                            count++;
                          });
                        }
                      },
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: MyConstant.dark,
                      ),
                    ),
                  ],
                ),
                */
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
            /*
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () async {
                    String idProduct = productModel.id;
                    String name = productModel.name;
                    String price = productModel.price;
                    String amount = count.toString();
                    int sumInt = int.parse(price) * count;
                    String sum = sumInt.toString();

                    SQLiteModel sqLiteModel = SQLiteModel(
                        idProduct: idProduct,
                        name: name,
                        price: price,
                        amount: amount,
                        sum: sum);
                    await SQLiteHelper()
                        .insertValueToSQLite(sqLiteModel)
                        .then((value) {
                          Fluttertoast.showToast(
                            msg: 'เพิ่มรายการ ${productModel.name} แล้ว',
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                          Navigator.pop(context);
                        });
                    count = 1;
                  },
                  child: Text(
                    'เพิ่มใส่ตะกร้า',
                    style: MyConstant().h2BlueStyle(),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    count = 1;
                  },
                  child: Text(
                    'ยกเลิก',
                    style: MyConstant().h2RedStyle(),
                  ),
                ),
              ],
            ),
            */
          ],
        ),
      ),
    );
  }

  String cutWord(String name) {
    String result = name;
    if (result.length > 14) {
      result = result.substring(0, 10);
      result = '$result ...';
    }
    return result;
  }
}
