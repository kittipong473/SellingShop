import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sellingshop/models/shop_model.dart';
import 'package:sellingshop/utility/my_constant.dart';
import 'package:sellingshop/utility/my_dialog.dart';
import 'package:sellingshop/widgets/show_progress.dart';
import 'package:sellingshop/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditShop extends StatefulWidget {
  const EditShop({Key? key}) : super(key: key);

  @override
  _EditShopState createState() => _EditShopState();
}

class _EditShopState extends State<EditShop> {
  ShopModel? shopModel;
  String? fileShow;
  String? chooseStatus;
  String? showPath;
  File? file;
  bool statusVideo = false;
  bool statusImage = false;
  bool statusAdvert = false;
  String? advert;
  bool load = true;
  TextEditingController descController = TextEditingController();

  List<String> pathImage = [];
  List<File?> files = [];

  @override
  void initState() {
    super.initState();
    getShopModel();
  }

  Future getShopModel() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString('manage')!;
    String path =
        '${MyConstant.domain}/phpTemplate/restaurant/getShopWhereId.php?isAdd=true&id=$id';
    await Dio().get(path).then((value) {
      for (var item in json.decode(value.data)) {
        setState(() {
          shopModel = ShopModel.fromMap(item);
          descController.text = shopModel!.desc;
          load = false;
          if (shopModel!.openclose == 1) {
            chooseStatus = 'เปิดตามปกติ';
          } else {
            chooseStatus = 'ปิดกรณีพิเศษ';
          }
          shopModel == null ? const ShowProgress() : convertArray();
        });
      }
    });
  }

  void convertArray() {
    String string = shopModel!.advert;
    string = string.substring(1, string.length - 1);
    List<String> strings = string.split(',');
    for (var item in strings) {
      pathImage.add(item.trim());
      files.add(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return shopModel == null
        ? const ShowProgress()
        : Scaffold(
            appBar: AppBar(
              title: const Text('แก้ไขหน้าร้านค้า'),
            ),
            body: LayoutBuilder(
              builder: (context, constraints) => GestureDetector(
                onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ShowTitle(
                              title: 'สถานะร้านค้า : ',
                              textStyle: MyConstant().h2Style()),
                        ),
                        buildShopStatus(constraints),
                        const SizedBox(height: 20.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ShowTitle(
                              title: 'คำอธิบาย : ',
                              textStyle: MyConstant().h2Style()),
                        ),
                        buildDesc(constraints),
                        const SizedBox(height: 50.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: ShowTitle(
                              title: 'รูปภาพ/วีดีโอของร้านค้า : ',
                              textStyle: MyConstant().h2Style()),
                        ),
                        buildImageVideo(constraints),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            file == null
                                ? Text(shopModel!.image)
                                : Text(cutWord(showPath!)),
                          ],
                        ),
                        const SizedBox(height: 50.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ShowTitle(
                              title: 'ภาพโฆษณา 1 : ',
                              textStyle: MyConstant().h2Style()),
                        ),
                        buildAdvert(constraints, 0),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ShowTitle(
                              title: 'ภาพโฆษณา 2 : ',
                              textStyle: MyConstant().h2Style()),
                        ),
                        buildAdvert(constraints, 1),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: ShowTitle(
                              title: 'ภาพโฆษณา 3 : ',
                              textStyle: MyConstant().h2Style()),
                        ),
                        buildAdvert(constraints, 2),
                        const SizedBox(height: 20),
                        buildEditButton(constraints),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Widget buildShopStatus(BoxConstraints constraints) {
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
                items: <String>['เปิดตามปกติ', 'ปิดกรณีพิเศษ']
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

  Row buildDesc(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: constraints.maxWidth * 0.6,
          child: TextFormField(
            controller: descController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'กรุณากรอก ที่อยู่ร้านค้า';
              }
            },
            maxLines: 3,
            decoration: InputDecoration(
                labelStyle: MyConstant().h3Style(),
                labelText: 'คำอธิบาย :',
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

  Future chooseVideo(ImageSource source) async {
    try {
      var result = await ImagePicker().pickVideo(
        source: source,
      );
      setState(() {
        file = File(result!.path);
        showPath = result.name.toString();
        statusVideo = true;
        statusImage = false;
      });
    } catch (e) {
      //
    }
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
        showPath = result.name.toString();
        statusImage = true;
        statusVideo = false;
      });
    } catch (e) {
      //
    }
  }

  Future chooseAdvert(int index, ImageSource source) async {
    try {
      var result = await ImagePicker().pickImage(
        source: source,
        maxHeight: 600,
        maxWidth: 800,
      );
      setState(() {
        files[index] = File(result!.path);
        statusAdvert = true;
      });
    } catch (e) {
      //
    }
  }

  Row buildImageVideo(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        IconButton(
          onPressed: () => chooseVideo(ImageSource.gallery),
          icon: const Icon(
            Icons.video_library_outlined,
            size: 36,
            color: MyConstant.dark,
          ),
        ),
        IconButton(
          onPressed: () => chooseImage(ImageSource.gallery),
          icon: const Icon(
            Icons.photo_library_outlined,
            size: 36,
            color: MyConstant.dark,
          ),
        ),
      ],
    );
  }

  Row buildAdvert(BoxConstraints constraints, int number) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => chooseAdvert(number, ImageSource.camera),
          icon: const Icon(
            Icons.add_a_photo,
            size: 36,
            color: MyConstant.dark,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          width: constraints.maxWidth * 0.5,
          child: files[number] == null
              ? CachedNetworkImage(
                  imageUrl: '${MyConstant.domain}${pathImage[number]}',
                  placeholder: (context, url) => const ShowProgress(),
                )
              : Image.file(files[number]!),
        ),
        IconButton(
          onPressed: () => chooseAdvert(number, ImageSource.gallery),
          icon: const Icon(
            Icons.add_photo_alternate,
            size: 36,
            color: MyConstant.dark,
          ),
        ),
      ],
    );
  }

  Row buildEditButton(BoxConstraints constraints) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: constraints.maxWidth * 0.6,
          child: ElevatedButton(
            style: MyConstant().myButtonStyle(),
            onPressed: () {
              confirmDialog();
            },
            child: const Text('แก้ไขหน้าร้านค้า'),
          ),
        ),
      ],
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
                  insertVideo();
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

  Future insertVideo() async {
    if (statusVideo) {
      String url =
          '${MyConstant.domain}/phpTemplate/restaurant/saveVideoFile.php';
      int i = Random().nextInt(1000000);
      String nameVideo = 'video$i.mp4';
      Map<String, dynamic> map = {};
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameVideo);
      FormData data = FormData.fromMap(map);
      EasyLoading.show(status: 'Uploading...');
      await Dio().post(url, data: data).then((value) {
        EasyLoading.showSuccess('Upload Success!');
        fileShow = '/phpTemplate/restaurant/video/$nameVideo';
      });
    } else if (statusImage) {
      String url =
          '${MyConstant.domain}/phpTemplate/restaurant/saveAvatarFile.php';
      int i = Random().nextInt(1000000);
      String nameImage = 'avatar$i.jpg';
      Map<String, dynamic> map = {};
      map['file'] =
          await MultipartFile.fromFile(file!.path, filename: nameImage);
      FormData data = FormData.fromMap(map);
      await Dio().post(url, data: data).then((value) {
        fileShow = '/phpTemplate/restaurant/avatar/$nameImage';
      });
    }
    insertAdvert();
  }

  Future insertAdvert() async {
    if (statusAdvert) {
      int index = 0;
      for (var item in files) {
        if (item != null) {
          int i = Random().nextInt(1000000);
          String nameImage = 'avatart$i.jpg';
          String apiUploadImage =
              '${MyConstant.domain}/phpTemplate/restaurant/saveAvatarFile.php';

          Map<String, dynamic> map = {};
          map['file'] =
              await MultipartFile.fromFile(item.path, filename: nameImage);
          FormData formData = FormData.fromMap(map);
          await Dio().post(apiUploadImage, data: formData).then((value) {
            pathImage[index] = '/phpTemplate/restaurant/avatar/$nameImage';
          });
        }
        index++;
      }
    }
    advert = pathImage.toString();
    processEdit();
  }

  Future processEdit() async {
    String id = shopModel!.id;
    int status;
    if (chooseStatus == 'เปิดตามปกติ') {
      status = 1;
    } else {
      status = 0;
    }
    String desc = descController.text;
    EasyLoading.dismiss();
    String path =
        '${MyConstant.domain}/phpTemplate/restaurant/editShop.php?isAdd=true&id=$id&image=$fileShow&openclose=$status&desc=$desc&advert=$advert';
    await Dio().get(path).then((value) {
      EasyLoading.dismiss();
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: 'แก้ไข หน้าร้านค้า แล้ว',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });
  }

  String cutWord(String name) {
    String result = name;
    if (result.length > 40) {
      result = result.substring(0, 37);
      result = '$result...';
    }
    return result;
  }
}
