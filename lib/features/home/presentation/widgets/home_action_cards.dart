import 'package:flutter/material.dart';

import '../../../../core/constants/app_strings.dart';

class _ActionItem {
  final String label;
  final String iconAsset;
  final Color color;
  final VoidCallback? onTap;
  final bool isComingSoon;

  const _ActionItem({
    required this.label,
    required this.iconAsset,
    required this.color,
    this.onTap,
    this.isComingSoon = false,
  });
}

class HomeActionCards extends StatelessWidget {
  const HomeActionCards({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      const _ActionItem(
        label: 'LEARN',
        iconAsset: 'assets/images/icon0.png',
        color: Color(0xFF1F9D63),
        isComingSoon: true,
      ),
      _ActionItem(
        label: 'TAKE TEST',
        iconAsset: 'assets/images/take-test-icon.png',
        color: const Color(0xFF3B6FD4),
        onTap: () => Navigator.pushNamed(context, AppRoutes.screeningTakeTest),
      ),
      const _ActionItem(
        label: 'ASK',
        iconAsset: 'assets/images/ask-icon.png',
        color: Color(0xFF5BA4CF),
        isComingSoon: true,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Row(
        children: items
            .map(
              (item) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: item == items.last ? 0 : 10),
                  child: _ActionCard(item: item),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final _ActionItem item;

  const _ActionCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: item.color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(item.iconAsset, height: 44),
                  const SizedBox(height: 8),
                  Text(
                    item.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
            ),
            if (item.isComingSoon)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Soon',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
