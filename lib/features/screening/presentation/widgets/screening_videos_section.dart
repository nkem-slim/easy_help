import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/video/youtube_player_page.dart';

// TODO: each fallback card should link to its own video once real per-topic
// recordings exist — both point at the same placeholder for now.
final String _placeholderVideoId = YoutubePlayerController.convertUrlToId(
  'https://youtu.be/p6Xd4cg40no?si=z3pGDhzgOBcjRN53',
)!;

class _VideoResource {
  final String title;
  final String subtitle;
  final String imageAsset;
  final String videoId;

  const _VideoResource({
    required this.title,
    required this.subtitle,
    required this.imageAsset,
    required this.videoId,
  });
}

final List<_VideoResource> _placeholderVideos = [
  _VideoResource(
    title: 'Nurturing Growth At Home',
    subtitle: 'Milestones for 18-24 months',
    imageAsset: 'assets/images/boy-1.png',
    videoId: _placeholderVideoId,
  ),
  _VideoResource(
    title: 'Language Milestones',
    subtitle: 'Encouraging early communication',
    imageAsset: 'assets/images/human-image.jpg',
    videoId: _placeholderVideoId,
  ),
];

class ScreeningVideosSection extends StatelessWidget {
  const ScreeningVideosSection({super.key});

  // TODO(screening-data-layer): move this behind a ScreeningRepository /
  // GetHelpfulVideosUsecase once the screening data layer exists, instead of
  // querying Firestore straight from the widget.
  Future<List<_VideoResource>> _fetchVideos() async {
    final snapshot = await FirebaseFirestore.instance
        .collection(FirestoreCollections.resources)
        .where('category', isEqualTo: 'video')
        .limit(6)
        .get();

    if (snapshot.docs.isEmpty) return _placeholderVideos;

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return _VideoResource(
        title: data['title'] as String? ?? 'Untitled',
        subtitle: data['subtitle'] as String? ?? '',
        imageAsset: data['imageAsset'] as String? ?? 'assets/images/boy-1.png',
        videoId: data['videoId'] as String? ?? _placeholderVideoId,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Helpful Videos',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {}, // TODO: wire to learn feature's full video list
                child: const Text(
                  'View all',
                  style: TextStyle(fontSize: 12, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 140,
          child: FutureBuilder<List<_VideoResource>>(
            future: _fetchVideos(),
            builder: (context, snapshot) {
              final videos = snapshot.data ?? _placeholderVideos;
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: videos.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) => _VideoCard(item: videos[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _VideoCard extends StatelessWidget {
  final _VideoResource item;

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
          width: 150,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(item.imageAsset, fit: BoxFit.cover),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.black54, Colors.transparent],
                    ),
                  ),
                ),
              ),
              const Center(
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.black45,
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
              Positioned(
                left: 10,
                right: 10,
                bottom: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.subtitle.isNotEmpty)
                      Text(
                        item.subtitle,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 9,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
