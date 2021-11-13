import 'package:flutter/material.dart';
import 'package:sellingshop/utility/my_constant.dart';
import 'package:sellingshop/widgets/show_title.dart';

class BuyerClosed extends StatefulWidget {
  const BuyerClosed({Key? key}) : super(key: key);

  @override
  _BuyerClosedState createState() => _BuyerClosedState();
}

class _BuyerClosedState extends State<BuyerClosed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShowTitle(
                title: 'ร้านค้าปิดให้บริการแล้ว',
                textStyle: MyConstant().h1Style()),
            ShowTitle(
                title: 'ขออภัยค่ะ กรุณาใช้บริการใหม่ในภายหลัง',
                textStyle: MyConstant().h2Style()),
            ShowTitle(
                title: 'สามารถเช็คเวลาเปิดให้บริการได้ที่ ติดต่อร้านค้า',
                textStyle: MyConstant().h3Style()),
          ],
        ),
      ),
    );
  }
}
