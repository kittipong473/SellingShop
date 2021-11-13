import 'dart:convert';

class SQLiteModel {
  final int? id;
  final String idProduct;
  final String name;
  final String price;
  final String amount;
  final String sum;
  SQLiteModel({
    this.id,
    required this.idProduct,
    required this.name,
    required this.price,
    required this.amount,
    required this.sum,
  });

  SQLiteModel copyWith({
    int? id,
    String? idProduct,
    String? name,
    String? price,
    String? amount,
    String? sum,
  }) {
    return SQLiteModel(
      id: id ?? this.id,
      idProduct: idProduct ?? this.idProduct,
      name: name ?? this.name,
      price: price ?? this.price,
      amount: amount ?? this.amount,
      sum: sum ?? this.sum,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'idProduct': idProduct,
      'name': name,
      'price': price,
      'amount': amount,
      'sum': sum,
    };
  }

  factory SQLiteModel.fromMap(Map<String, dynamic> map) {
    return SQLiteModel(
      id: map['id'],
      idProduct: map['idProduct'],
      name: map['name'],
      price: map['price'],
      amount: map['amount'],
      sum: map['sum'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SQLiteModel.fromJson(String source) => SQLiteModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SQLiteModel(id: $id, idProduct: $idProduct, name: $name, price: $price, amount: $amount, sum: $sum)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SQLiteModel &&
      other.id == id &&
      other.idProduct == idProduct &&
      other.name == name &&
      other.price == price &&
      other.amount == amount &&
      other.sum == sum;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      idProduct.hashCode ^
      name.hashCode ^
      price.hashCode ^
      amount.hashCode ^
      sum.hashCode;
  }
}
