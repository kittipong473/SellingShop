import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellingshop/utility/my_constant.dart';
import 'package:sellingshop/utility/my_dialog.dart';
import 'package:sellingshop/widgets/show_image.dart';

class AddPromo extends StatefulWidget {
  const AddPromo({Key? key}) : super(key: key);

  @override
  _AddPromoState createState() => _AddPromoState();
}

class _AddPromoState extends State<AddPromo> {
  File? file;
  String image = '';
  String? chooseType;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เพิ่มเมนูอาหาร'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    buildProductName(constraints),
                    buildProductDetail(constraints),
                    buildProductImage(constraints),
                    buildAddButton(constraints),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildAddButton(BoxConstraints constraints) {
    return SizedBox(
      width: constraints.maxWidth * 0.6,
      child: ElevatedButton(
        style: MyConstant().myButtonStyle(),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            confirmDialog();
          }
        },
        child: const Text('เพิ่มรายการอาหาร'),
      ),
    );
  }

  Future confirmDialog() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          'ยืนยันการเพิ่มรายการหรือไม่ ?',
          style: MyConstant().h2Style(),
        ),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  insertData();
                },
                child: Text(
                  'ยืนยัน',
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

  Future insertData() async {
    String name = nameController.text;
    String price = '0';
    String detail = detailController.text;

    String path =
        '${MyConstant.domain}/phpTemplate/restaurant/getProductWhereName.php?isAdd=true&name=$name';
    await Dio().get(path).then((value) async {
      if (value.toString() == 'null') {
        if (file == null) {
          processInsert(name: name, price: price, detail: detail);
        } else {
          String api =
              '${MyConstant.domain}/phpTemplate/restaurant/saveProductFile.php';
          int i = Random().nextInt(1000000);
          String nameImage = 'product$i.jpg';
          Map<String, dynamic> map = {};
          map['file'] =
              await MultipartFile.fromFile(file!.path, filename: nameImage);
          FormData data = FormData.fromMap(map);
          EasyLoading.show(status: 'Uploading...');
          await Dio().post(api, data: data).then((value) {
            image = '/phpTemplate/restaurant/product/$nameImage';
            EasyLoading.showSuccess('Upload Success!');
            processInsert(name: name, price: price, detail: detail);
          });
        }
      } else {
        MyDialog().singleDialog(context, 'สิ้นค้านี้ถูกสร้างไปแล้ว');
      }
    });
  }

  Future processInsert({String? name, String? price, String? detail}) async {
    String path =
        '${MyConstant.domain}/phpTemplate/restaurant/insertProduct.php?isAdd=true&name=$name&type=โปรโมชั่น&price=$price&detail=$detail&image=$image';
    await Dio().get(path).then((value) {
      if (value.toString() == 'true') {
        Navigator.pop(context);
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: 'เพิ่มรายการ $name แล้ว',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        MyDialog().normalDialog(
            context, 'เพิ่มรายการล้มเหลว', 'กรูณาลองใหม่อีกครั้ง');
      }
    });
  }

  Future chooseImage(ImageSource source) async {
    try {
      var result = await ImagePicker().pickImage(
        source: source,
        maxHeight: 600,
        maxWidth: 800,
      );
      setState(() {
        file = File(result!.path);
      });
    } catch (e) {
      //
    }
  }

  Row buildProductImage(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => chooseImage(ImageSource.camera),
          icon: const Icon(
            Icons.add_a_photo,
            size: 36,
            color: MyConstant.dark,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 16),
          width: constraints.maxWidth * 0.5,
          child: file == null
              ? ShowImage(path: MyConstant.imageChoose)
              : Image.file(file!),
        ),
        IconButton(
          onPressed: () => chooseImage(ImageSource.gallery),
          icon: const Icon(
            Icons.add_photo_alternate,
            size: 36,
            color: MyConstant.dark,
          ),
        ),
      ],
    );
  }

  Widget buildProductName(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.6,
      margin: const EdgeInsets.only(top: 20),
      child: TextFormField(
        controller: nameController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอก ชื่อโปรโมชั่น';
          }
        },
        decoration: InputDecoration(
            labelStyle: MyConstant().h3Style(),
            labelText: 'ชื่อโปรโมชั่น :',
            prefixIcon: const Icon(
              Icons.receipt,
              color: MyConstant.dark,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: MyConstant.dark),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: MyConstant.light),
              borderRadius: BorderRadius.circular(30),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red),
              borderRadius: BorderRadius.circular(30),
            )),
      ),
    );
  }

  Widget buildProductDetail(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.6,
      margin: const EdgeInsets.only(top: 20),
      child: TextFormField(
        controller: detailController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอก รายละเอียดโปรโมชั่น';
          }
        },
        maxLines: 3,
        decoration: InputDecoration(
          hintStyle: MyConstant().h3Style(),
          hintText: 'รายละเอียดโปรโมชั่น :',
          prefixIcon: const Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 40),
            child: Icon(
              Icons.details_outlined,
              color: MyConstant.dark,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: MyConstant.dark),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: MyConstant.light),
            borderRadius: BorderRadius.circular(30),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
