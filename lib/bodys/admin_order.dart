import 'package:flutter/material.dart';

class AdminOrder extends StatefulWidget {
  const AdminOrder({Key? key}) : super(key: key);

  @override
  _AdminOrderState createState() => _AdminOrderState();
}

class _AdminOrderState extends State<AdminOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Order'),
      ),
    );
  }
}
