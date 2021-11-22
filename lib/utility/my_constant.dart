import 'package:flutter/material.dart';

class MyConstant {
  // General
  static String appName = 'Charoz Steak House';
  static String domain = 'http://b883-2001-fb1-bc-4744-e4a9-fb27-f673-887c.ngrok.io';

  // Route
  static String routeHome = '/home';
  static String routeAuthen = '/authen';
  static String routeCreateAccount = '/createAccount';
  static String routeBuyerService = '/buyerService';
  static String routeSalerService = '/salerService';
  static String routeRiderService = '/riderService';
  static String routeAdminService = '/adminService';
  static String routeAddProduct = '/addProduct';
  static String routeAddPromo = '/addPromo';
  static String routeEditShop = '/editShop';
  static String routeShoppingCart = '/shoppingCart';
  static String routeAdminAddShop = '/adminAddShop';
  static String routeAdminAddUser = '/adminAddUser';

  // Image
  static String user = 'images/user.png';
  static String image1 = 'images/image1.png';
  static String image2 = 'images/image2.png';
  static String image3 = 'images/image3.png';
  static String image4 = 'images/image4.png';
  static String image5 = 'images/image5.png';
  static String image6 = 'images/image6.png';
  static String imageChoose = 'images/image_choose.png';
  static String avatar0 = 'images/avatar0.jpg';
  static String avatar1 = 'images/avatar1.jpg';
  static String avatar2 = 'images/avatar2.jpg';
  static String picture = 'images/picture.png';
  static String error = 'images/error.png';
  static String menu1 = 'images/menu1.jpg';
  static String menu2 = 'images/menu2.jpg';
  static String menu3 = 'images/menu3.jpg';

  // Time of shop
  static int wdOpen = 16;
  static int wdClose = 21;
  static int weOpen = 10;
  static int weClose = 21;

  // Color
  static const Color primary = Color(0xffff8b51);
  static const Color dark = Color(0xffc75c25);
  static const Color light = Color(0xffffbc7f);
  static const Map<int, Color> mapMaterialColor = {
    50: Color.fromRGBO(255, 139, 81, 0.1),
    100: Color.fromRGBO(255, 139, 81, 0.2),
    200: Color.fromRGBO(255, 139, 81, 0.3),
    300: Color.fromRGBO(255, 139, 81, 0.4),
    400: Color.fromRGBO(255, 139, 81, 0.5),
    500: Color.fromRGBO(255, 139, 81, 0.6),
    600: Color.fromRGBO(255, 139, 81, 0.7),
    700: Color.fromRGBO(255, 139, 81, 0.8),
    800: Color.fromRGBO(255, 139, 81, 0.9),
    900: Color.fromRGBO(255, 139, 81, 1.0),
  };

  // Style
  TextStyle h1Style() => const TextStyle(
        fontSize: 24,
        color: dark,
        fontWeight: FontWeight.bold,
      );
  TextStyle h2Style() => const TextStyle(
        fontSize: 18,
        color: dark,
        fontWeight: FontWeight.w700,
      );
  TextStyle h2WhiteStyle() => const TextStyle(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w700,
      );
  TextStyle h2RedStyle() => TextStyle(
        fontSize: 18,
        color: Colors.red.shade900,
        fontWeight: FontWeight.w700,
      );
  TextStyle h2BlueStyle() => TextStyle(
        fontSize: 18,
        color: Colors.blue.shade900,
        fontWeight: FontWeight.w700,
      );
  TextStyle h3Style() => const TextStyle(
        fontSize: 14,
        color: dark,
        fontWeight: FontWeight.normal,
      );
  TextStyle h3WhiteStyle() => const TextStyle(
        fontSize: 14,
        color: Colors.white,
        fontWeight: FontWeight.normal,
      );
  ButtonStyle myButtonStyle() => ElevatedButton.styleFrom(
        primary: MyConstant.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      );
}
