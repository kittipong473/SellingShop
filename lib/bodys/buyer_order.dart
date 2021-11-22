import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:sellingshop/api/product_api.dart';
import 'package:sellingshop/models/product_model.dart';
import 'package:sellingshop/models/shop_model.dart';
import 'package:sellingshop/states/shopping_cart.dart';
import 'package:sellingshop/utility/my_constant.dart';
import 'package:sellingshop/utility/my_dialog.dart';
import 'package:sellingshop/widgets/buyer_show_menu.dart';
import 'package:sellingshop/widgets/buyer_show_promo.dart';
import 'package:sellingshop/widgets/show_image.dart';
import 'package:sellingshop/widgets/show_progress.dart';
import 'package:sellingshop/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyerOrder extends StatefulWidget {
  const BuyerOrder({Key? key}) : super(key: key);

  @override
  _BuyerOrderState createState() => _BuyerOrderState();
}

class _BuyerOrderState extends State<BuyerOrder> {
  ShopModel? shopModel;
  List<ProductModel> productModel = [];
  List data = [];
  String? status;
  bool login = false;

  @override
  void initState() {
    super.initState();
    getPreference();
    getAllProduct();
  }

  Future getPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString('role') == 'buyer') {
      login = true;
    }
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

  Future getAllProduct() async {
    String path =
        '${MyConstant.domain}/phpTemplate/restaurant/getAllProduct.php';
    await Dio().get(path).then((value) {
      for (var item in json.decode(value.data)) {
        ProductModel model = ProductModel.fromMap(item);
        setState(() {
          productModel.add(model);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: TypeAheadField<ProductName?>(
            debounceDuration: const Duration(milliseconds: 500),
            textFieldConfiguration: const TextFieldConfiguration(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search_outlined),
                border: OutlineInputBorder(),
                hintText: 'ค้นหาชื่ออาหาร...',
              ),
            ),
            suggestionsCallback: ProductApi.getSuggestion,
            itemBuilder: (context, ProductName? suggestion) {
              final product = suggestion!;
              return ListTile(
                leading: SizedBox(
                  width: 60,
                  height: 60,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: '${MyConstant.domain}${product.image}',
                    placeholder: (context, url) => const ShowProgress(),
                    errorWidget: (context, url, error) =>
                        ShowImage(path: MyConstant.error),
                  ),
                ),
                title: Text(product.name),
              );
            },
            noItemsFoundBuilder: (context) => SizedBox(
              height: 70,
              child: Center(
                child: Text(
                  'ไม่พบรายการที่คุณเลือก',
                  style: MyConstant().h2Style(),
                ),
              ),
            ),
            onSuggestionSelected: (ProductName? suggestion) {
              final product = suggestion!;
              showAlertDialog(product);
            },
          ),
          // actions: [
          //   IconButton(
          //     onPressed: () {
          //       if (login==true){
          //         Navigator.pushNamed(context, MyConstant.routeShoppingCart);
          //       } else {
          //         MyDialog().normalDialog(context, 'คุณยังไม่ได้เข้าสู่ระบบ', 'โปรด Login ก่อนเข้าใช้งานตะกร้า');
          //       }
          //     },
          //     icon: const Icon(Icons.shopping_cart_outlined),
          //   )
          // ],
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [MyConstant.light, MyConstant.primary],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 5,
            tabs: [
              Tab(
                icon: Icon(Icons.lunch_dining_outlined),
                text: 'อาหาร',
              ),
              Tab(
                icon: Icon(Icons.icecream_outlined),
                text: 'ของหวาน',
              ),
              Tab(
                icon: Icon(Icons.local_bar_outlined),
                text: 'เครื่องดื่ม',
              ),
              Tab(
                icon: Icon(Icons.menu_book_outlined),
                text: 'โปรโมชั่น',
              ),
            ],
          ),
          elevation: 20,
          titleSpacing: 20,
        ),
        body: const TabBarView(
          children: [
            ShowMenu(type: 'อาหาร'),
            ShowMenu(type: 'ของหวาน'),
            ShowMenu(type: 'เครื่องดื่ม'),
            ShowPromo(type: 'โปรโมชั่น'),
          ],
        ),
      ),
    );
  }

  Future showAlertDialog(ProductName product) async {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShowTitle(
                    title: product.name,
                    textStyle: MyConstant().h2Style()),
              ],
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShowTitle(
                    title: 'ราคา : ${product.price} บาท',
                    textStyle: MyConstant().h2Style()),
              ],
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CachedNetworkImage(
                  imageUrl: '${MyConstant.domain}${product.image}',
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
                                title: product.detail,
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
                        title: product.status,
                        textStyle: MyConstant().h2Style()),
                  ],
                ),
                // if (login == true) ...[
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     IconButton(
                //       onPressed: () {
                //         if (count > 1) {
                //           setState(() {
                //             count--;
                //           });
                //         }
                //       },
                //       icon: const Icon(
                //         Icons.remove_circle_outline,
                //         color: MyConstant.dark,
                //       ),
                //     ),
                //     ShowTitle(
                //         title: count.toString(),
                //         textStyle: MyConstant().h1Style()),
                //     IconButton(
                //       onPressed: () {
                //         if (count < 10) {
                //           setState(() {
                //             count++;
                //           });
                //         }
                //       },
                //       icon: const Icon(
                //         Icons.add_circle_outline,
                //         color: MyConstant.dark,
                //       ),
                //     ),
                //   ],
                // ),
                // ]
              ],
            ),
          ),
          // actions: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     TextButton(
            //       onPressed: () {
            //         Navigator.pop(context);
            //       },
            //       child: Text(
            //         'ตกลง',
            //         style: MyConstant().h2BlueStyle(),
            //       ),
            //     ),
            //   ],
            // ),
          // if (login==true) ...[
          //   Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          //       TextButton(
          //         onPressed: () async {
          //           String idProduct = productModel.id;
          //           String name = productModel.name;
          //           String price = productModel.price;
          //           String amount = count.toString();
          //           int sumInt = int.parse(price) * count;
          //           String sum = sumInt.toString();

          //           SQLiteModel sqLiteModel = SQLiteModel(
          //               idProduct: idProduct,
          //               name: name,
          //               price: price,
          //               amount: amount,
          //               sum: sum);
          //           await SQLiteHelper()
          //               .insertValueToSQLite(sqLiteModel)
          //               .then((value) {
          //                 Fluttertoast.showToast(
          //                   msg: 'เพิ่มรายการ ${productModel.name} แล้ว',
          //                   toastLength: Toast.LENGTH_SHORT,
          //                   gravity: ToastGravity.CENTER,
          //                   backgroundColor: Colors.black,
          //                   textColor: Colors.white,
          //                   fontSize: 16.0,
          //                 );
          //                 Navigator.pop(context);
          //               });
          //           count = 1;
          //         },
          //         child: Text(
          //           'เพิ่มใส่ตะกร้า',
          //           style: MyConstant().h2BlueStyle(),
          //         ),
          //       ),
          //       TextButton(
          //         onPressed: () {
          //           Navigator.pop(context);
          //           count = 1;
          //         },
          //         child: Text(
          //           'ยกเลิก',
          //           style: MyConstant().h2RedStyle(),
          //         ),
          //       ),
          //     ],
          //   ),
          // ],
          // ],
        ),
      ),
    );
  }
}
