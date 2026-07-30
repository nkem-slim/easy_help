import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../constants/app_colors.dart';

/// Shared full-screen YouTube player, opened from any "Helpful Videos" card
/// across the app so playback UI stays in one place rather than forked per
/// feature.
class YoutubePlayerPage extends StatefulWidget {
  final String videoId;
  final String title;

  const YoutubePlayerPage({
    super.key,
    required this.videoId,
    this.title = 'Video',
  });

  @override
  State<YoutubePlayerPage> createState() => _YoutubePlayerPageState();
}

class _YoutubePlayerPageState extends State<YoutubePlayerPage> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: true,
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title: Text(widget.title),
      ),
      body: Center(child: YoutubePlayer(controller: _controller)),
    );
  }
}
