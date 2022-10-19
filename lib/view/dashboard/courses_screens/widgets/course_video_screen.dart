import 'package:flutter/material.dart';
import 'package:primewayskills_app/view/dashboard/courses_screens/widgets/course_discussion_screen.dart';
import 'package:primewayskills_app/view/helpers/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class CourseVideoScreen extends StatefulWidget {
  final String courseId;
  final String videoId;
  final String videoTitle;
  final String videoUrl;
  final String videoDescription;
  const CourseVideoScreen(
      {super.key,
      required this.courseId,
      required this.videoId,
      required this.videoTitle,
      required this.videoUrl,
      required this.videoDescription});

  @override
  State<CourseVideoScreen> createState() => _CourseVideoScreenState();
}

class _CourseVideoScreenState extends State<CourseVideoScreen> {
  final videoUrl = "https://www.youtube.com/watch?v=YMx8Bbev6T4";

  late YoutubePlayerController controller;

  @override
  void initState() {
    super.initState();
    final videoID = YoutubePlayer.convertUrlToId(videoUrl);
    controller = YoutubePlayerController(
      initialVideoId: videoID!,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        showLiveFullscreenButton: true,
        hideControls: false,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: controller,
        showVideoProgressIndicator: true,
        bottomActions: [
          CurrentPosition(),
          ProgressBar(
            isExpanded: true,
            colors: ProgressBarColors(
              handleColor: whiteColor.withOpacity(0.8),
              playedColor: whiteColor,
              bufferedColor: primeColor,
              backgroundColor: whiteColor,
            ),
          ),
          const PlaybackSpeedButton(),
          FullScreenButton(),
        ],
      ),
      builder: (context, player) => SafeArea(
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              player,
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
                child: Text(
                  widget.videoTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              DefaultTabController(
                length: 2,
                initialIndex: 0,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.6,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      TabBar(
                        indicatorColor: primeColor,
                        labelColor: Colors.black,
                        tabs: const [
                          Tab(
                            text: 'Discussions',
                          ),
                          Tab(
                            text: 'Description',
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            CourseDiscussionScreen(courseId: widget.courseId),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text(widget.videoDescription),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
