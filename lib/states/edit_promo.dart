import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellingshop/models/product_model.dart';
import 'package:sellingshop/utility/my_constant.dart';
import 'package:sellingshop/widgets/show_progress.dart';

class EditPromo extends StatefulWidget {
  final ProductModel productModel;
  const EditPromo({Key? key, required this.productModel}) : super(key: key);

  @override
  _EditPromoState createState() => _EditPromoState();
}

class _EditPromoState extends State<EditPromo> {
  ProductModel? productModel;
  File? file;
  String? image;
  String? chooseStatus;
  bool statusImage = false;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController detailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    productModel = widget.productModel;
    nameController.text = productModel!.name;
    priceController.text = productModel!.price;
    detailController.text = productModel!.detail;
    chooseStatus = productModel!.status;
    image = productModel!.image;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขเมนู: ${productModel!.name}'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) => GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      buildProductStatus(constraints),
                      buildProductName(constraints),
                      buildProductDetail(constraints),
                      buildImage(constraints),
                      buildEditButton(constraints),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
            return 'กรุณากรอก ชื่อสินค้า';
          }
        },
        decoration: InputDecoration(
            labelStyle: MyConstant().h3Style(),
            labelText: 'ชื่อสินค้า :',
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
            return 'กรุณากรอก รายละเอียดสินค้า';
          }
        },
        maxLines: 3,
        decoration: InputDecoration(
          hintStyle: MyConstant().h3Style(),
          hintText: 'รายละเอียดสินค้า :',
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

  Widget buildProductStatus(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.6,
      margin: const EdgeInsets.only(top: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButton<String>(
            value: chooseStatus,
            hint: Text(productModel!.status),
            items: <String>['ขาย', 'สินค้าหมด', 'ยกเลิกการขาย']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                child: Text(value),
                value: value,
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                chooseStatus = value as String;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget buildEditButton(BoxConstraints constraints) {
    return SizedBox(
      width: constraints.maxWidth * 0.6,
      child: ElevatedButton(
        style: MyConstant().myButtonStyle(),
        onPressed: () {
          if (formKey.currentState!.validate()) {
            confirmDialog();
          }
        },
        child: const Text('แก้ไขโปรโมชั่น'),
      ),
    );
  }

  Future confirmDialog() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          'ยืนยันการแก้ไขรายการหรือไม่ ?',
          style: MyConstant().h2Style(),
        ),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  editData();
                },
                child: Text(
                  'ยืนยัน',
                  style: MyConstant().h2BlueStyle(),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
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

  Future chooseImage(ImageSource source) async {
    try {
      var result = await ImagePicker().pickImage(
        source: source,
        maxHeight: 600,
        maxWidth: 800,
      );
      setState(() {
        file = File(result!.path);
        statusImage = true;
      });
    } catch (e) {
      //
    }
  }

  Row buildImage(BoxConstraints constraints) {
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
              ? CachedNetworkImage(
                  imageUrl: '${MyConstant.domain}/${productModel!.image}',
                  placeholder: (context, url) => const ShowProgress(),
                )
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

  Future editData() async {
    String name = nameController.text;
    String type = 'โปรโมชั่น';
    String price = '0';
    String detail = detailController.text;
    String id = productModel!.id;
    String status = chooseStatus!;

    if (statusImage) {
      String api =
          '${MyConstant.domain}/phpTemplate/restaurant/saveProductFile.php';
      int i = Random().nextInt(100000);
      String nameImage = 'product$i.jpg';
      Map<String, dynamic> map = {};
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameImage);
      FormData data = FormData.fromMap(map);
      await Dio().post(api, data: data).then((value) {
        image = 'phpTemplate/restaurant/product/$nameImage';
      });
    }

    String path =
        '${MyConstant.domain}/phpTemplate/restaurant/editProduct.php?isAdd=true&id=$id&name=$name&type=$type&price=$price&detail=$detail&image=$image&status=$status';
    await Dio().get(path).then((value) {
      Navigator.pop(context);
      Navigator.pop(context);
      Fluttertoast.showToast(
          msg: 'แก้ไขรายการ $name แล้ว',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
    });
  }
}
