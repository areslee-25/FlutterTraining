import 'package:untitled/data/model/video.dart';

import '../../remote.dart';

class VideoResponse {
  final Video video;

  VideoResponse({
    required this.video,
  });

  factory VideoResponse.fromJson(dynamic results) {
    final dataList = results[KeyPrams.results] as List;
    return VideoResponse(
      video: dataList.map((item) => Video.fromJson(item)).toList().first,
    );
  }
}
