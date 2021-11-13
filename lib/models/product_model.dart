import 'dart:convert';

class ProductModel {
  final String id;
  final String name;
  final String type;
  final String price;
  final String detail;
  final String image;
  final String status;
  ProductModel({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.detail,
    required this.image,
    required this.status,
  });

  ProductModel copyWith({
    String? id,
    String? name,
    String? type,
    String? price,
    String? detail,
    String? image,
    String? status,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      price: price ?? this.price,
      detail: detail ?? this.detail,
      image: image ?? this.image,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'price': price,
      'detail': detail,
      'image': image,
      'status': status,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      price: map['price'],
      detail: map['detail'],
      image: map['image'],
      status: map['status'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, type: $type, price: $price, detail: $detail, image: $image, status: $status)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ProductModel &&
      other.id == id &&
      other.name == name &&
      other.type == type &&
      other.price == price &&
      other.detail == detail &&
      other.image == image &&
      other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      type.hashCode ^
      price.hashCode ^
      detail.hashCode ^
      image.hashCode ^
      status.hashCode;
  }
}
