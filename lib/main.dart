import 'package:flutter/material.dart';
import 'package:sellingshop/states/authen.dart';
import 'package:sellingshop/states/buy_service.dart';
import 'package:sellingshop/states/create_account.dart';
import 'package:sellingshop/states/rider_service.dart';
import 'package:sellingshop/states/saler_service.dart';
import 'package:sellingshop/utility/my_constant.dart';

final Map<String,WidgetBuilder> map = {
  '/authen':(BuildContext context)=>Authen(),
  '/createAccount':(BuildContext context)=>CreateAccount(),
  '/buyerService':(BuildContext context)=>BuyerService(),
  '/salerService':(BuildContext context)=>SalerService(),
  '/riderService':(BuildContext context)=>RiderService(),
};

String? initialRoute;

void main() {
  initialRoute = MyConstant.routeAuthen;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: MyConstant.appName,
      routes: map,
      initialRoute: initialRoute,
    );
  }
}