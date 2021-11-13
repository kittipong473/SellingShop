import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sellingshop/models/shop_model.dart';
import 'package:sellingshop/utility/my_constant.dart';
import 'package:sellingshop/widgets/show_progress.dart';

class AdminEditShop extends StatefulWidget {
  final ShopModel shopModel;
  const AdminEditShop({Key? key, required this.shopModel}) : super(key: key);

  @override
  _AdminEditShopState createState() => _AdminEditShopState();
}

class _AdminEditShopState extends State<AdminEditShop> {
  ShopModel? shopModel;
  bool load = true;
  String? chooseStatus;
  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController lngController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    shopModel = widget.shopModel;
    nameController.text = shopModel!.name;
    phoneController.text = shopModel!.phone;
    addressController.text = shopModel!.address;
    latController.text = shopModel!.lat;
    lngController.text = shopModel!.lng;
    timeController.text = shopModel!.time;
    if(shopModel!.openclose == '2'){
      chooseStatus = 'ปิดการใช้งาน';
    } else if (shopModel!.openclose == '0'){
      chooseStatus = 'ปิดกรณีอื่นๆ';
    } else {
      chooseStatus = 'เปิดตามปกติ';
    }
    chooseStatus = shopModel!.openclose;
    shopModel == null ? const ShowProgress() : load = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('แก้ไขร้าน ${shopModel!.name}'),
      ),
      body: load
          ? const ShowProgress()
          : LayoutBuilder(
              builder: (context, constraints) => GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                behavior: HitTestBehavior.opaque,
                child: Center(
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          buildName(constraints),
                          buildPhone(constraints),
                          buildAddress(constraints),
                          buildLat(constraints),
                          buildLng(constraints),
                          buildTime(constraints),
                          buildStatus(constraints),
                          buildEditButton(constraints),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget buildName(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.6,
      margin: const EdgeInsets.only(top: 20),
      child: TextFormField(
        controller: nameController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอก ชื่อร้านค้า';
          }
        },
        decoration: InputDecoration(
            labelStyle: MyConstant().h3Style(),
            labelText: 'ชื่อร้านค้า :',
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

  Widget buildPhone(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.6,
      margin: const EdgeInsets.only(top: 20),
      child: TextFormField(
        controller: phoneController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอก เบอร์โทร';
          }
        },
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
            labelStyle: MyConstant().h3Style(),
            labelText: 'เบอร์โทร :',
            prefixIcon: const Icon(
              Icons.phone,
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

  Row buildAddress(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: constraints.maxWidth * 0.6,
          child: TextFormField(
            controller: addressController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก ที่อยู่ร้านค้า';
              }
            },
            maxLines: 3,
            decoration: InputDecoration(
                labelStyle: MyConstant().h3Style(),
                labelText: 'ที่อยู่ :',
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
                )),
          ),
        ),
      ],
    );
  }

  Widget buildLat(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.6,
      margin: const EdgeInsets.only(top: 20),
      child: TextFormField(
        controller: nameController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอก Latitude';
          }
        },
        decoration: InputDecoration(
            labelStyle: MyConstant().h3Style(),
            labelText: 'Latitude :',
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

  Widget buildLng(BoxConstraints constraints) {
    return Container(
      width: constraints.maxWidth * 0.6,
      margin: const EdgeInsets.only(top: 20),
      child: TextFormField(
        controller: nameController,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณากรอก Longitude';
          }
        },
        decoration: InputDecoration(
            labelStyle: MyConstant().h3Style(),
            labelText: 'Longitude :',
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

  Row buildTime(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: constraints.maxWidth * 0.6,
          child: TextFormField(
            controller: addressController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก เวลาเปิด-ปิด';
              }
            },
            maxLines: 3,
            decoration: InputDecoration(
                labelStyle: MyConstant().h3Style(),
                labelText: 'เวลาเปิด-ปิด :',
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
                )),
          ),
        ),
      ],
    );
  }

  Widget buildStatus(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: constraints.maxWidth * 0.6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: chooseStatus,
                hint: Text(chooseStatus!),
                items: <String>['เปิดตามปกติ', 'ปิดกรณีพิเศษ', 'ปิดการใช้งาน']
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
        ),
      ],
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
        child: const Text('แก้ไขข้อมูลร้านค้า'),
      ),
    );
  }

  Future confirmDialog() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          'ยืนยันการแก้ไขหรือไม่ ?',
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

  Future editData() async {
    String id = shopModel!.id;
    String name = nameController.text;
    String phone = phoneController.text;
    String address = addressController.text;
    String lat = latController.text;
    String lng = lngController.text;
    String time = timeController.text;
    int status;
    if(chooseStatus == 'เปิดตามปกติ') {
      status = 1;
    } else if (chooseStatus == 'ปิดกรณีพิเศษ') {
      status = 0;
    } else {
      status = 2;
    }

    String path =
        '${MyConstant.domain}/phpTemplate/restaurant/editProduct.php?isAdd=true&id=$id&name=$name&phone=$phone&address=$address&lat=$lat&lng=$lng&time=$time&openclose=$status';
    await Dio().get(path).then((value) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: 'แก้ไขร้านค้า $name แล้ว',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
  }
}
