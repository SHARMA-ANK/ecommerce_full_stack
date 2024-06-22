import 'dart:convert';

class User {
  User(
      {required this.id,
      required this.name,
      required this.password,
      required this.address,
      required this.type,
      required this.token,
      required this.email,
      required this.cart});

  final String id;
  final String name;
  final String password;
  final String address;
  final String type;
  final String token;
  final String email;
  final List<dynamic> cart;

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['_id'] ?? '',
      name: map['name'] ?? '',
      password: map['password'] ?? '',
      address: map['address'] ?? '',
      type: map['type'] ?? '',
      token: map['token'] ?? '',
      email: map['email'] ?? '',
      cart: List<Map<String, dynamic>>.from(
        map['cart']?.map(
          (x) => Map<String, dynamic>.from(x),
        ),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'password': password,
      'address': address,
      'type': type,
      'token': token,
      'email': email
    };
  }

  String toJson() => json.encode(toMap());
  factory User.fromJson(String source) => User.fromMap(json.decode(source));
  User copyWith({
    String? id,
    String? name,
    String? password,
    String? address,
    String? type,
    String? token,
    String? email,
    List<dynamic>? cart,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      password: password ?? this.password,
      address: address ?? this.address,
      type: type ?? this.type,
      token: token ?? this.token,
      email: email ?? this.email,
      cart: cart ?? this.cart,
    );
  }
}
