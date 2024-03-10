
class Booking {
  Booking({
    String? id,
    String? userName,
    String? userPhone,
    String? way,
    String? name,
    int? price,
    int? total,
    String? amount,
  }) {
    _id = id;
    _userName = userName;
    _userPhone = userPhone;
    _way = way;
    _name = name;
    _price = price;
    _total = total;
    _amount = amount;
  }

  Booking.fromJson(dynamic json) {
    _id = json['id'];
    _userName = json['userName'];
    _userPhone = json['userPhone'];
    _way = json['way'];
    _name = json['name'];
    _price = json['price'];
    _total = json['total'];
    _amount = json['amount'];
  }

  String? _id;
  String? _userName;
  String? _userPhone;
  String? _way;
  String? _name;
  int? _price;
  int? _total;
  String? _amount;

  String? get id => _id;
  String? get userName => _userName;
  String? get way => _way;
  String? get userPhone => _userPhone;
  String? get name => _name;
  int? get price => _price;
  int? get total => _total;
  String? get amount => _amount;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['userName'] = _userName;
    map['userPhone'] = _userPhone;
    map['way'] = _way;
    map['name'] = _name;
    map['price'] = _price;
    map['total'] = _total;
    map['amount'] = _amount;

    return map;
  }
}