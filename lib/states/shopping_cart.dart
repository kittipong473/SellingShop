import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sellingshop/models/sqlite_model.dart';
import 'package:sellingshop/utility/my_constant.dart';
import 'package:sellingshop/utility/sqlite_helper.dart';
import 'package:sellingshop/widgets/show_progress.dart';
import 'package:sellingshop/widgets/show_title.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({Key? key}) : super(key: key);

  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  List<SQLiteModel> sqliteModels = [];
  bool load = true;
  bool data = false;
  String? type;
  int total = 0;

  @override
  void initState() {
    super.initState();
    readSQLite();
  }

  Future readSQLite() async {
    await SQLiteHelper().readSQLite().then(
      (value) {
        if (value.isEmpty) {
          setState(() {
            load = false;
            data = false;
          });
        }
        for (var model in value) {
          String subString = model.sum;
          int sumInt = int.parse(subString);
          setState(() {
            sqliteModels = value;
            total = total + sumInt;
            load = false;
            data = true;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตะกร้าของฉัน'),
      ),
      body: load
          ? const ShowProgress()
          : data
              ? LayoutBuilder(
                  builder: (context, constraints) => SingleChildScrollView(
                    child: Column(
                      children: [
                        buildNameShop(),
                        buildTitle(),
                        buildListView(),
                        const Divider(),
                        buildTotal(),
                        buildClearButton(),
                      ],
                    ),
                  ),
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ShowTitle(
                          title: 'ตะกร้าของคุณว่างเปล่า',
                          textStyle: MyConstant().h2Style()),
                      ShowTitle(
                          title: 'กรุณาเพิ่มรายการอาหารลงในตะกร้า',
                          textStyle: MyConstant().h3Style()),
                    ],
                  ),
                ),
    );
  }

  Row buildClearButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          onPressed: () => confirmDelete(),
          icon: const Icon(Icons.delete_forever_outlined),
          label: const Text('Clear All'),
        ),
      ],
    );
  }

  Row buildTotal() {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ShowTitle(
                title: 'ราคาทั้งหมด : $total บาท',
                textStyle: MyConstant().h2BlueStyle(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildNameShop() {
    return Container(
      margin: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ShowTitle(
            title: 'ร้าน Charoz Steak House',
            textStyle: MyConstant().h2Style(),
          ),
        ],
      ),
    );
  }

  Widget buildTitle() {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade400),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: ShowTitle(
              title: 'รายการอาหาร',
              textStyle: MyConstant().h3Style(),
            ),
          ),
          Expanded(
            flex: 1,
            child: ShowTitle(
              title: 'ราคา',
              textStyle: MyConstant().h3Style(),
            ),
          ),
          Expanded(
            flex: 1,
            child: ShowTitle(
              title: 'จำนวน',
              textStyle: MyConstant().h3Style(),
            ),
          ),
          Expanded(
            flex: 1,
            child: ShowTitle(
              title: 'ผลรวม',
              textStyle: MyConstant().h3Style(),
            ),
          ),
          const Expanded(
            flex: 1,
            child: SizedBox(width: 10.0),
          ),
        ],
      ),
    );
  }

  ListView buildListView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: sqliteModels.length,
      itemBuilder: (context, index) => Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(sqliteModels[index].name),
          ),
          Expanded(
            flex: 1,
            child: Text(sqliteModels[index].price),
          ),
          Expanded(
            flex: 1,
            child: Text(sqliteModels[index].amount),
          ),
          Expanded(
            flex: 1,
            child: Text(sqliteModels[index].sum),
          ),
          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(
                Icons.delete_rounded,
                color: Colors.red,
              ),
              onPressed: () async {
                int? id = sqliteModels[index].id;
                await SQLiteHelper().deleteValue(id!).then((value) {
                  Fluttertoast.showToast(
                    msg: 'ลบรายการ ${sqliteModels[index].name} แล้ว',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 3,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                  readSQLite();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Future confirmDelete() async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          'ต้องการลบรายการทั้งหมดหรือไม่ ?',
          style: MyConstant().h2Style(),
        ),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await SQLiteHelper()
                      .deleteAllData()
                      .then((value) => readSQLite());
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
}
