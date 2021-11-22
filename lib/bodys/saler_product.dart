import 'package:flutter/material.dart';
import 'package:sellingshop/utility/my_constant.dart';
import 'package:sellingshop/widgets/buyer_show_promo.dart';
import 'package:sellingshop/widgets/saler_show_product.dart';

class SalerProduct extends StatefulWidget {
  const SalerProduct({Key? key}) : super(key: key);

  @override
  _SalerProductState createState() => _SalerProductState();
}

class _SalerProductState extends State<SalerProduct> {
  bool load = true;
  bool? data;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('เมนูอาหาร'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                chooseDialog();
              },
              icon: const Icon(Icons.add_circle_outline),
            )
          ],
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
            ShowProduct(type: 'อาหาร'),
            ShowProduct(type: 'ของหวาน'),
            ShowProduct(type: 'เครื่องดื่ม'),
            ShowProduct(type: 'โปรโมชั่น'),
          ],
        ),
      ),
    );
  }

  Future chooseDialog() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          'เพิ่มเมนูอาหารหรือโปรโมชั่น ?',
          style: MyConstant().h2Style(),
        ),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, MyConstant.routeAddProduct).then((value) => const ShowProduct(type: 'อาหาร'));
                },
                child: Text(
                  'อาหาร',
                  style: MyConstant().h2BlueStyle(),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, MyConstant.routeAddPromo).then((value) => const ShowProduct(type: 'โปรโมชั่น'));
                },
                child: Text(
                  'โปรโมชั่น',
                  style: MyConstant().h2BlueStyle(),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'ยกเลิก',
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
