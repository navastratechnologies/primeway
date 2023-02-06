// ignore_for_file: unused_field

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:primewayskills_app/view/dashboard/courses_screens/widgets/course_landscape_video_screen.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:video_player/video_player.dart';

class CourseVideoScreen extends StatefulWidget {
  final String courseId;
  final String videoId;
  final String videoTitle;
  final String videoUrl;
  final String videoDescription;
  final String userNumber;
  final String userName;
  final String userAddress;
  final String userProfileImage;
  final String userPayment;
  final String userEmail;
  final String userWalletId;
  final String courseName;

  const CourseVideoScreen({
    super.key,
    required this.courseId,
    required this.videoId,
    required this.videoTitle,
    required this.videoUrl,
    required this.videoDescription,
    required this.userNumber,
    required this.userName,
    required this.userAddress,
    required this.userProfileImage,
    required this.userPayment,
    required this.userEmail,
    required this.userWalletId,
    required this.courseName,
  });

  @override
  State<CourseVideoScreen> createState() => _CourseVideoScreenState();
}

class _CourseVideoScreenState extends State<CourseVideoScreen> {
  late VideoPlayerController _controller;

  bool showControls = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  static const List<double> examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

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

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _controller.value.isInitialized
                  ? InkWell(
                      onTap: () {
                        setState(
                          () {
                            showControls = !showControls;
                          },
                        );
                      },
                      child: AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: Stack(
                          children: [
                            VideoPlayer(_controller),
                            showControls
                                ? Center(
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          _controller.value.isPlaying
                                              ? _controller.pause()
                                              : _controller.play();
                                          _controller.value.isPlaying
                                              ? showControls = false
                                              : showControls = true;
                                        });
                                      },
                                      child: Icon(
                                        _controller.value.isPlaying
                                            ? Icons.pause_rounded
                                            : Icons.play_arrow_rounded,
                                        size: 50,
                                        color: Colors.white.withOpacity(0.6),
                                      ),
                                    ),
                                  )
                                : Container(),
                            showControls
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
                            showControls
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              color: primeColor2,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: ValueListenableBuilder(
                                              valueListenable: _controller,
                                              builder: (context,
                                                  VideoPlayerValue value,
                                                  child) {
                                                return Text(
                                                  _videoDuration(
                                                      value.position),
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
                                              _controller,
                                              allowScrubbing: true,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              color: primeColor2,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            child: Text(
                                              _videoDuration(
                                                  _controller.value.duration),
                                              style: TextStyle(
                                                color: whiteColor,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    CourseLandscapeVideoScreen(
                                                  controller: _controller,
                                                  showControls: showControls,
                                                ),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                          //       _controller.value.playbackSpeed,
                                          //   tooltip: 'Playback speed',
                                          //   onSelected: (double speed) {
                                          //     _controller.setPlaybackSpeed(speed);
                                          //   },
                                          //   itemBuilder: (BuildContext context) {
                                          //     return <PopupMenuItem<double>>[
                                          //       for (final double speed
                                          //           in examplePlaybackRates)
                                          //         PopupMenuItem<double>(
                                          //           value: speed,
                                          //           child: Text('${speed}x'),
                                          //         )
                                          //     ];
                                          //   },
                                          //   child: Text(
                                          //     '${_controller.value.playbackSpeed}x',
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
                      ),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Lottie.asset('assets/json/buffering.json'),
                      ),
                    ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                child: Text(
                  widget.videoTitle,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.black.withOpacity(0.5),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.videoDescription,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
