import 'package:flutter/material.dart';

class BuyerData extends StatefulWidget {
  const BuyerData({Key? key}) : super(key: key);

  @override
  _BuyerDataState createState() => _BuyerDataState();
}

class _BuyerDataState extends State<BuyerData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ประวัติรายการสั่งอาหาร'),
      ),
    );
  }
}
