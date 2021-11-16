import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sellingshop/models/product_model.dart';
import 'package:sellingshop/states/edit_product.dart';
import 'package:sellingshop/states/edit_promo.dart';
import 'package:sellingshop/utility/my_constant.dart';
import 'package:sellingshop/widgets/show_image.dart';
import 'package:sellingshop/widgets/show_progress.dart';
import 'package:sellingshop/widgets/show_title.dart';

class ShowProduct extends StatefulWidget {
  final String type;
  const ShowProduct({Key? key, required this.type}) : super(key: key);

  @override
  _ShowProductState createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
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
    type = widget.type;
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
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
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
                                  title: productModel[index].status,
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
                          title: 'ยังไม่มีโปรโมชั่นที่สร้าง',
                          textStyle: MyConstant().h1Style()),
                      ShowTitle(
                          title: 'กรุณาสร้างเมนูโปรโมชั่นสำหรับลูกค้า',
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
              ],
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TextButton(
                  onPressed: () {
                    type != 'โปรโมชั่น'
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProduct(
                                productModel: productModel,
                              ),
                            ),
                          ).then((value) => getProduct())
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPromo(
                                productModel: productModel,
                              ),
                            ),
                          ).then((value) => getProduct());
                  },
                  child: Text(
                    'แก้ไข',
                    style: MyConstant().h2BlueStyle(),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    deleteDialog(productModel);
                  },
                  child: Text(
                    'ลบ',
                    style: MyConstant().h2RedStyle(),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'ยกเลิก',
                    style: MyConstant().h2RedStyle(),
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

  Future deleteDialog(ProductModel productModel) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          'ยืนยันการลบรายการหรือไม่ ?',
          style: MyConstant().h2Style(),
        ),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton(
                onPressed: () async {
                  String path =
                      '${MyConstant.domain}/phpTemplate/restaurant/deleteProduct.php?isAdd=true&id=${productModel.id}';
                  await Dio().get(path).then((value) {
                    Fluttertoast.showToast(
                      msg: 'ลบรายการ ${productModel.name} แล้ว',
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    Navigator.pop(context);
                    Navigator.pop(context);
                    getProduct();
                  });
                },
                child: Text(
                  'ยืนยัน',
                  style: MyConstant().h2BlueStyle(),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'ปฏิเสธ',
                  style: MyConstant().h2RedStyle(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
