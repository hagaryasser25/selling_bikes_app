import 'package:flutter/cupertino.dart';

class Bikes {
  Bikes({
    String? id,
    String? imageUrl,
    int? price,
    String? type,
    String? name,
    int? rating,
  }) {
    _name = name;
    _id = id;
    _imageUrl = imageUrl;
    _price = price;
    _type = type;
    _rating = rating;
  }

  Bikes.fromJson(dynamic json) {
    _id = json['id'];
    _imageUrl = json['imageUrl'];
    _name = json['name'];
    _price = json['price'];
    _rating = json['rating'];
  }

  String? _name;
  String? _id;
  String? _imageUrl;
  int? _price;
  String? _type;
  int? _rating;


  String? get name => _name;
  String? get imageUrl => _imageUrl;
  String? get id => _id;
  int? get price => _price;
  String? get type => _type;
  int? get rating => _rating;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['imageUrl'] = _imageUrl;
    map['id'] = _id;
    map['type'] = _type;
    map['price'] = _price;
    map['rating'] = _rating;

    return map;
  }
}
