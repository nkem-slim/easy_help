import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

class _VideoItem {
  final String title;
  final String imageAsset;

  const _VideoItem({required this.title, required this.imageAsset});
}

class HomeVideosSection extends StatelessWidget {
  const HomeVideosSection({super.key});

  static const _videos = [
    _VideoItem(
      title: 'Understanding Autism',
      imageAsset: 'assets/images/clinic-0.jpg',
    ),
    _VideoItem(
      title: 'Daily Routines',
      imageAsset: 'assets/images/clinic-1.jpg',
    ),
    _VideoItem(
      title: 'Communication Tips',
      imageAsset: 'assets/images/clinic-2.jpg',
    ),
    _VideoItem(
      title: 'Sensory Activities',
      imageAsset: 'assets/images/clinic-0.jpg',
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
    return ClipRRect(
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
                backgroundColor: Colors.white24,
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
    );
  }
}
