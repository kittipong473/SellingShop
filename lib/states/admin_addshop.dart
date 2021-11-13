import 'dart:io';

import 'package:flutter/material.dart';

class AdminAddShop extends StatefulWidget {
  const AdminAddShop({Key? key}) : super(key: key);

  @override
  _AdminAddShopState createState() => _AdminAddShopState();
}

class _AdminAddShopState extends State<AdminAddShop> {
  File? file;
  
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController lngController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController descController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('add shop'),
      ),
    );
  }
}
