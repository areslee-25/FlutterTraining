import 'dart:convert';

import 'package:untitled/data/source/remote.dart';

import 'base_model.dart';

class User extends BaseModel {
  final String avatar;
  final String name;

  User({
    required this.avatar,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        avatar: KeyPrams.imgPath + json["avatar"]["gravatar"]["hash"],
        name: json.decode("username"),
      );

  factory User.fromJsonLocal(Map<String, dynamic> json) => User(
        avatar: KeyPrams.imgPath + json.decode("avatar"),
        name: json.decode("username"),
      );

  Map<String, dynamic> toJson() => {
        'avatar': avatar,
        'username': name,
      };

  factory User.fromStringJson(String stringJson) =>
      User.fromJsonLocal(jsonDecode(stringJson));

  String toStringJson() => jsonEncode(toJson());
}
