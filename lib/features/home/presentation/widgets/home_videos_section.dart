import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/video/youtube_player_page.dart';

class _VideoItem {
  final String title;
  final String imageAsset;
  final String videoId;

  const _VideoItem({
    required this.title,
    required this.imageAsset,
    required this.videoId,
  });
}

class HomeVideosSection extends StatelessWidget {
  const HomeVideosSection({super.key});

  // TODO: each card should link to its own video once real per-topic
  // recordings exist — all four point at the same placeholder for now.
  static final _placeholderVideoId = YoutubePlayerController.convertUrlToId(
    'https://youtu.be/p6Xd4cg40no?si=z3pGDhzgOBcjRN53',
  )!;

  static final _videos = [
    _VideoItem(
      title: 'Understanding Autism',
      imageAsset: 'assets/images/clinic-0.jpg',
      videoId: _placeholderVideoId,
    ),
    _VideoItem(
      title: 'Daily Routines',
      imageAsset: 'assets/images/clinic-1.jpg',
      videoId: _placeholderVideoId,
    ),
    _VideoItem(
      title: 'Communication Tips',
      imageAsset: 'assets/images/clinic-2.jpg',
      videoId: _placeholderVideoId,
    ),
    _VideoItem(
      title: 'Sensory Activities',
      imageAsset: 'assets/images/clinic-0.jpg',
      videoId: _placeholderVideoId,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Text(
            'HELPFUL VIDEOS',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _videos.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) => _VideoCard(item: _videos[index]),
          ),
        ),
      ],
    );
  }
}

class _VideoCard extends StatelessWidget {
  final _VideoItem item;

  const _VideoCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) =>
              YoutubePlayerPage(videoId: item.videoId, title: item.title),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 130,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(item.imageAsset, fit: BoxFit.cover),
              // Dark gradient overlay at the bottom for the title
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 50,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black54, Colors.transparent],
                    ),
                  ),
                ),
              ),
              // Play button
              const Center(
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.black45,
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
              // Title
              Positioned(
                left: 10,
                right: 10,
                bottom: 8,
                child: Text(
                  item.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
