import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/base/base_page.dart';
import 'package:untitled/data/model/video.dart';
import 'package:untitled/ui/home/detail/movie_detail_page.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoPage extends BaseStateFul {
  final Video video;

  const VideoPage({Key? key, required this.video}) : super(key: key);

  static const String routeName = "/video";

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends BaseState<VideoPage> {
  Video get video => widget.video;

  late YoutubePlayerController _controller;

  @override
  void init() {
    _controller = YoutubePlayerController(
      initialVideoId: video.key,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: true,
        isLive: true,
        forceHD: true,
        enableCaption: false,
      ),
    );
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget buildUI(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: YoutubePlayerBuilder(
        onExitFullScreen: () {
          SystemChrome.setPreferredOrientations(DeviceOrientation.values);
        },
        player: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.green,
        ),
        builder: (context, player) {
          return Stack(
            children: [
              Hero(
                tag: video.id,
                child: Center(child: player),
              ),
              BuildBackButton(),
            ],
          );
        },
      ),
    );
  }
}
