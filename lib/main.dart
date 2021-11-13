import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sellingshop/states/add_product.dart';
import 'package:sellingshop/states/add_promo.dart';
import 'package:sellingshop/states/admin_addshop.dart';
import 'package:sellingshop/states/admin_adduser.dart';
import 'package:sellingshop/states/admin_editshop.dart';
import 'package:sellingshop/states/admin_edituser.dart';
import 'package:sellingshop/states/admin_service.dart';
import 'package:sellingshop/states/admin_showshop.dart';
import 'package:sellingshop/states/admin_showuser.dart';
import 'package:sellingshop/states/authen.dart';
import 'package:sellingshop/states/buyer_service.dart';
import 'package:sellingshop/states/create_account.dart';
import 'package:sellingshop/states/edit_shop.dart';
import 'package:sellingshop/states/home.dart';
import 'package:sellingshop/states/rider_service.dart';
import 'package:sellingshop/states/saler_service.dart';
import 'package:sellingshop/states/shopping_cart.dart';
import 'package:sellingshop/utility/my_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Map<String, WidgetBuilder> map = {
  '/home': (BuildContext context) => const Home(),
  '/authen': (BuildContext context) => const Authen(),
  '/createAccount': (BuildContext context) => const CreateAccount(),
  '/buyerService': (BuildContext context) => const BuyerService(),
  '/salerService': (BuildContext context) => const SalerService(),
  '/riderService': (BuildContext context) => const RiderService(),
  '/adminService': (BuildContext context) => const AdminService(),
  '/addProduct': (BuildContext context) => const AddProduct(),
  '/addPromo': (BuildContext context) => const AddPromo(),
  '/editShop': (BuildContext context) => const EditShop(),
  '/shoppingCart': (BuildContext context) => const ShoppingCart(),
  '/adminAddShop': (BuildContext context) => const AdminAddShop(),
  '/adminAddUser': (BuildContext context) => const AdminAddUser(),
};

String? initialRoute;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  String? role = preferences.getString('role');
  if (role?.isEmpty ?? true) {
    initialRoute = MyConstant.routeHome;
    runApp(const MyApp());
  } else {
    switch (role) {
      case 'buyer':
        initialRoute = MyConstant.routeBuyerService;
        runApp(const MyApp());
        break;
      case 'saler':
        initialRoute = MyConstant.routeSalerService;
        runApp(const MyApp());
        break;
      case 'rider':
        initialRoute = MyConstant.routeRiderService;
        runApp(const MyApp());
        break;
      case 'admin':
        initialRoute = MyConstant.routeAdminService;
        runApp(const MyApp());
        break;
      default:
    }
  }
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  // ..customAnimation = CustomAnimation();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MaterialColor materialColor =
        const MaterialColor(0xffff8b51, MyConstant.mapMaterialColor);
    return MaterialApp(
      title: MyConstant.appName,
      routes: map,
      initialRoute: initialRoute,
      theme: ThemeData(primarySwatch: materialColor),
      builder: EasyLoading.init(),
    );
  }
}
