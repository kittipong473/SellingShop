import 'package:flutter/material.dart';
import 'package:sellingshop/bodys/buyer_contact.dart';
import 'package:sellingshop/bodys/buyer_home.dart';
import 'package:sellingshop/bodys/buyer_order.dart';
import 'package:sellingshop/utility/my_constant.dart';
import 'package:sellingshop/widgets/show_progress.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Widget> widgets = [
    const BuyerHome(),
    const BuyerOrder(),
    const BuyerContact(),
  ];
  List<IconData> icons = [
    Icons.home_rounded,
    Icons.restaurant_menu_rounded,
    Icons.location_on_rounded
  ];
  List<String> titles = ['Home', 'Menu', 'Location'];
  List<BottomNavigationBarItem> bottomNavigationBarItems = [];
  int indexPosition = 0;

  @override
  void initState() {
    super.initState();
    int i = 0;
    for (var item in titles) {
      bottomNavigationBarItems.add(createBottomNavigationBarItem(icons[i], item));
      i++;
    }
  }

  BottomNavigationBarItem createBottomNavigationBarItem(
          IconData iconData, String string) =>
      BottomNavigationBarItem(
        icon: Icon(iconData),
        label: string,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyConstant.appName),
        centerTitle: true,
        backgroundColor: MyConstant.primary,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              colors: [MyConstant.light, MyConstant.primary],
              center: Alignment(0, 0),
              radius: 0.8,
            ),
          ),
        ),
        actions: [
            IconButton(
              onPressed: () {
                  Navigator.pushNamed(context, MyConstant.routeAuthen);
              },
              icon: const Icon(Icons.login_outlined),
            )
          ],
      ),
      body: widgets.isEmpty ? const ShowProgress() : widgets[indexPosition],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: MyConstant.dark,
        unselectedItemColor: MyConstant.light,
        items: bottomNavigationBarItems,
        currentIndex: indexPosition,
        onTap: (value) {
          setState(() {
            indexPosition = value;
          });
        },
      ),
    );
  }
}
