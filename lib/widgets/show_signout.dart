import 'package:flutter/material.dart';
import 'package:sellingshop/utility/my_constant.dart';
import 'package:sellingshop/widgets/show_title.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowSignOut extends StatelessWidget {
  const ShowSignOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ListTile(
          onTap: () {
            confirmDelete(context);
          },
          tileColor: MyConstant.primary,
          leading: const Icon(
            Icons.exit_to_app,
            size: 36,
            color: Colors.white,
          ),
          title: ShowTitle(
            title: 'ออกจากระบบ',
            textStyle: MyConstant().h2WhiteStyle(),
          ),
          subtitle: ShowTitle(
            title: 'กลับสู่หน้าหลัก',
            textStyle: MyConstant().h3WhiteStyle(),
          ),
        ),
      ],
    );
  }

  Future confirmDelete(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          'ต้องการออกจากระบบหรือไม่ ?',
          style: MyConstant().h2Style(),
        ),
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton(
                onPressed: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  preferences.clear().then(
                        (value) => Navigator.pushNamedAndRemoveUntil(
                            context, MyConstant.routeHome, (route) => false),
                      );
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
