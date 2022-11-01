import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:video_player/video_player.dart';

class CourseLandscapeVideoScreen extends StatefulWidget {
  final VideoPlayerController controller;
  final bool showControls;
  const CourseLandscapeVideoScreen({
    super.key,
    required this.controller,
    required this.showControls,
  });

  @override
  State<CourseLandscapeVideoScreen> createState() =>
      _CourseLandscapeVideoScreenState();
}

class _CourseLandscapeVideoScreenState
    extends State<CourseLandscapeVideoScreen> {
  String _videoDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return [
      if (duration.inHours > 0) hours,
      minutes,
      seconds,
    ].join(':');
  }

  Future _landScapeMode() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
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
    return Scaffold(
      body: Stack(
        children: [
          VideoPlayer(widget.controller),
          widget.showControls
              ? Center(
                  child: Icon(
                    Icons.play_arrow,
                    size: 50,
                    color: Colors.white.withOpacity(0.6),
                  ),
                )
              : Container(),
          widget.showControls
              ? Align(
                  alignment: Alignment.topLeft,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_back,
                        color: whiteColor,
                      ),
                    ),
                  ),
                )
              : Container(),
          widget.showControls
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 7,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: primeColor2,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ValueListenableBuilder(
                            valueListenable: widget.controller,
                            builder: (context, VideoPlayerValue value, child) {
                              return Text(
                                _videoDuration(value.position),
                                style: TextStyle(
                                  color: whiteColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: VideoProgressIndicator(
                            widget.controller,
                            allowScrubbing: true,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: primeColor2,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            _videoDuration(widget.controller.value.duration),
                            style: TextStyle(
                              color: whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: _setAllOrientation,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5,
                            ),
                            child: Icon(
                              Icons.fullscreen_rounded,
                              color: whiteColor,
                            ),
                          ),
                        ),
                        // PopupMenuButton<double>(
                        //   initialValue:
                        //       widget.controller.value.playbackSpeed,
                        //   tooltip: 'Playback speed',
                        //   onSelected: (double speed) {
                        //     widget.controller.setPlaybackSpeed(speed);
                        //   },
                        //   itemBuilder: (BuildContext context) {
                        //     return <PopupMenuItem<double>>[
                        //       for (final double speed
                        //           in _examplePlaybackRates)
                        //         PopupMenuItem<double>(
                        //           value: speed,
                        //           child: Text('${speed}x'),
                        //         )
                        //     ];
                        //   },
                        //   child: Text(
                        //     '${widget.controller.value.playbackSpeed}x',
                        //     style: const TextStyle(
                        //       color: Colors.white,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
