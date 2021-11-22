import 'dart:convert';

class ShopModel {
  final String id;
  final String name;
  final String phone;
  final String address;
  final String image;
  final String video;
  final String lat;
  final String lng;
  final String status;
  final String time;
  final String openclose;
  final String desc;
  final String advert;
  ShopModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
    required this.image,
    required this.video,
    required this.lat,
    required this.lng,
    required this.status,
    required this.time,
    required this.openclose,
    required this.desc,
    required this.advert,
  });

  ShopModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? address,
    String? image,
    String? video,
    String? lat,
    String? lng,
    String? status,
    String? time,
    String? openclose,
    String? desc,
    String? advert,
  }) {
    return ShopModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      image: image ?? this.image,
      video: video ?? this.video,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      status: status ?? this.status,
      time: time ?? this.time,
      openclose: openclose ?? this.openclose,
      desc: desc ?? this.desc,
      advert: advert ?? this.advert,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'address': address,
      'image': image,
      'video': video,
      'lat': lat,
      'lng': lng,
      'status': status,
      'time': time,
      'openclose': openclose,
      'desc': desc,
      'advert': advert,
    };
  }

  factory ShopModel.fromMap(Map<String, dynamic> map) {
    return ShopModel(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      address: map['address'],
      image: map['image'],
      video: map['video'],
      lat: map['lat'],
      lng: map['lng'],
      status: map['status'],
      time: map['time'],
      openclose: map['openclose'],
      desc: map['desc'],
      advert: map['advert'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ShopModel.fromJson(String source) => ShopModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ShopModel(id: $id, name: $name, phone: $phone, address: $address, image: $image, video: $video, lat: $lat, lng: $lng, status: $status, time: $time, openclose: $openclose, desc: $desc, advert: $advert)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is ShopModel &&
      other.id == id &&
      other.name == name &&
      other.phone == phone &&
      other.address == address &&
      other.image == image &&
      other.video == video &&
      other.lat == lat &&
      other.lng == lng &&
      other.status == status &&
      other.time == time &&
      other.openclose == openclose &&
      other.desc == desc &&
      other.advert == advert;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      phone.hashCode ^
      address.hashCode ^
      image.hashCode ^
      video.hashCode ^
      lat.hashCode ^
      lng.hashCode ^
      status.hashCode ^
      time.hashCode ^
      openclose.hashCode ^
      desc.hashCode ^
      advert.hashCode;
  }
}
