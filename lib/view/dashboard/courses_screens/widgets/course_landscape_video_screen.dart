import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class CourseLandscapeVideoScreen extends StatefulWidget {
  final VideoPlayerController controller;
  const CourseLandscapeVideoScreen({super.key, required this.controller});

  @override
  State<CourseLandscapeVideoScreen> createState() =>
      _CourseLandscapeVideoScreenState();
}

class _CourseLandscapeVideoScreenState
    extends State<CourseLandscapeVideoScreen> {
  Future _landScapeMode() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  Future _setAllOrientation() async {
    await SystemChrome.setPreferredOrientations(
      DeviceOrientation.values,
    );
  }

  @override
  void initState() {
    super.initState();
    _landScapeMode();
  }

  @override
  void dispose() {
    _setAllOrientation();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayer(widget.controller);
  }
}
