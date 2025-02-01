import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';


class HeroImage extends StatefulWidget {
  const HeroImage({super.key});
  @override
  HeroImageState createState() => HeroImageState();
}

class HeroImageState extends State<HeroImage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/images/Background.webm')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });

  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

@override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (_controller.value.isInitialized)
        Positioned.fill(
          child: FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
            width: _controller.value.size.width,
            height: _controller.value.size.height,
            child: VideoPlayer(_controller),
            ),
          )
        )
        else
        const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
