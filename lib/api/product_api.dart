import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:sellingshop/utility/my_constant.dart';

class ProductName{
  final String name;
  final String image;
  final String price;
  final String detail;
  final String status;

const ProductName({
  required this.name,
  required this.image,
  required this.price,
  required this.detail,
  required this.status,
});

static ProductName fromJson(Map<String, dynamic> json) => ProductName(name: json['name'],image: json['image'],price: json['price'],detail: json['detail'],status: json['status']);
}

class ProductApi {
  static Future<List<ProductName>> getSuggestion (String query) async {
    String path = '${MyConstant.domain}/phpTemplate/restaurant/getAllProduct.php';
    Response response = await Dio().get(path);

    final List products = json.decode(response.data);

    return products.map((json) => ProductName.fromJson(json)).where((product) {
      final nameLower = product.name.toLowerCase();
      final queryLower = query.toLowerCase();
      return nameLower.contains(queryLower);
    }).toList();
  }
}