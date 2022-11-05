import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/services.dart';

class SingleVideo extends StatefulWidget {
  final String videoId;
  const SingleVideo({Key? key, required this.videoId}) : super(key: key);

  @override
  _SingleVideoState createState() => _SingleVideoState();
}

class _SingleVideoState extends State<SingleVideo> {
  late YoutubePlayerController _videoController;
  initialiseVideo() async {
    //print("VIDEO URL: ${courseDetails[0]['video_url']}");
    _videoController = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        loop: false,
        enableCaption: true,
        hideControls: false,

//        useHybridComposition: true,

        // showControls: true,
        // playsInline: true,
        // showFullscreenButton: true,
        // strictRelatedVideos: true,
      ),
    );
  }

  @override
  void initState() {
    initialiseVideo();
    super.initState();
  }

  @override
  void dispose() {
    _videoController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: SafeArea(
        child: Center(
          child: YoutubePlayer(
            controller: _videoController,

            //showVideoProgressIndicator: true,
          ),
        ),
      ),
    );
  }
}
