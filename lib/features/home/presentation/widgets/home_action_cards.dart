import 'package:flutter/material.dart';

class _ActionItem {
  final String label;
  final String iconAsset;
  final Color color;
  final VoidCallback? onTap;

  const _ActionItem({
    required this.label,
    required this.iconAsset,
    required this.color,
    this.onTap,
  });
}

class HomeActionCards extends StatelessWidget {
  const HomeActionCards({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      _ActionItem(
        label: 'LEARN',
        iconAsset: 'assets/images/icon0.png',
        color: const Color(0xFF1F9D63),
        onTap: () {},
      ),
      _ActionItem(
        label: 'TAKE TEST',
        iconAsset: 'assets/images/take-test-icon.png',
        color: const Color(0xFF3B6FD4),
        onTap: () {},
      ),
      _ActionItem(
        label: 'ASK',
        iconAsset: 'assets/images/ask-icon.png',
        color: const Color(0xFF5BA4CF),
        onTap: () {},
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
    );
  }
}
