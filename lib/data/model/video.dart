import 'package:untitled/data/model/base_model.dart';
import 'package:untitled/data/source/remote.dart';

class Video extends BaseModel {
  final String id;
  final String name;
  final String key;
  final String type;

  Video({
    required this.id,
    required this.name,
    required this.key,
    required this.type,
  });

  factory Video.fromJson(Map<String, dynamic> json) => Video(
        id: json.decode("id"),
        name: json.decode("name"),
        key: json.decode("key"),
        type: json.decode("type"),
      );
}
