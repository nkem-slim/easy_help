import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../clinics/domain/entities/clinic_entity.dart';
import '../../../clinics/presentation/pages/clinic_details_page.dart';

class FavouriteClinicsPage extends StatefulWidget {
  const FavouriteClinicsPage({super.key});

  @override
  State<FavouriteClinicsPage> createState() => _FavouriteClinicsPageState();
}

class _FavouriteClinicsPageState extends State<FavouriteClinicsPage> {
  final TextEditingController _searchController = TextEditingController();

  static const List<ClinicEntity> _favouriteClinics = [
    ClinicEntity(
      id: 'legacy-1',
      name: 'Legacy Clinic',
      location: 'Kigali, Rwa',
      logoBackgroundColor: Color(0xFF2B2B2B),
      logoIcon: Icons.local_hospital,
    ),
    ClinicEntity(
      id: 'king-faisal-1',
      name: 'King Faisal',
      location: 'Kigali, Rwa',
      logoBackgroundColor: AppColors.primary,
      logoIcon: Icons.local_hospital,
    ),
    ClinicEntity(
      id: 'legacy-2',
      name: 'Legacy Clinic',
      location: 'Kigali, Rwa',
      logoBackgroundColor: Color(0xFF2B2B2B),
      logoIcon: Icons.local_hospital,
    ),
    ClinicEntity(
      id: 'king-faisal-2',
      name: 'King Faisal',
      location: 'Kigali, Rwa',
      logoBackgroundColor: AppColors.primary,
      logoIcon: Icons.local_hospital,
    ),
    ClinicEntity(
      id: 'legacy-3',
      name: 'Legacy Clinic',
      location: 'Kigali, Rwa',
      logoBackgroundColor: Color(0xFF2B2B2B),
      logoIcon: Icons.local_hospital,
    ),
    ClinicEntity(
      id: 'king-faisal-3',
      name: 'King Faisal',
      location: 'Kigali, Rwa',
      logoBackgroundColor: AppColors.primary,
      logoIcon: Icons.local_hospital,
    ),
  ];

  final Set<String> _removedIds = {};
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _removeFromFavourites(String id) {
    setState(() => _removedIds.add(id));
  }

  void _openClinicDetails(ClinicEntity clinic) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ClinicDetailsPage(clinic: clinic)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleClinics = _favouriteClinics.where((clinic) {
      if (_removedIds.contains(clinic.id)) return false;
      if (_query.isEmpty) return true;
      return clinic.name.toLowerCase().contains(_query.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const Text(
                'Favourite Clinic',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _SearchField(
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value),
                onClear: () => setState(() {
                  _searchController.clear();
                  _query = '';
                }),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: visibleClinics.isEmpty
                    ? const _EmptyFavourites()
                    : GridView.builder(
                        padding: const EdgeInsets.only(bottom: 20),
                        itemCount: visibleClinics.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.78,
                        ),
                        itemBuilder: (_, index) {
                          final clinic = visibleClinics[index];
                          return _ClinicCard(
                            clinic: clinic,
                            onTap: () => _openClinicDetails(clinic),
                            onUnfavourite: () => _removeFromFavourites(clinic.id),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: 'Search Favourite...',
        prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close, color: AppColors.textSecondary),
                onPressed: onClear,
              )
            : null,
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE3E6E5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE3E6E5)),
        ),
      ),
    );
  }
}

class _ClinicCard extends StatelessWidget {
  final ClinicEntity clinic;
  final VoidCallback onTap;
  final VoidCallback onUnfavourite;

  const _ClinicCard({
    required this.clinic,
    required this.onTap,
    required this.onUnfavourite,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 90,
                  decoration: BoxDecoration(
                    color: clinic.logoBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(clinic.logoIcon, color: Colors.white, size: 34),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: onUnfavourite,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite, color: AppColors.error, size: 18),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              clinic.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Located in ${clinic.location}',
              style: const TextStyle(color: AppColors.primary, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyFavourites extends StatelessWidget {
  const _EmptyFavourites();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite_border, size: 48, color: AppColors.textSecondary),
          SizedBox(height: 12),
          Text(
            'No favourite',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
