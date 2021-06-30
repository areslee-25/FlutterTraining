import 'package:untitled/data/source/remote/remote.dart';

import 'base_model.dart';

class User extends BaseModel {
  final String avatar;
  final String name;

  User({
    required this.avatar,
    required this.name,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        avatar: json["avatar"]["gravatar"]["hash"],
        name: json.decode("username"),
      );
}
