import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/soft_gradient_background.dart';
import '../../../clinics/domain/entities/clinic_entity.dart';
import '../../../clinics/presentation/pages/clinic_details_page.dart';

class FavouriteClinicsPage extends StatefulWidget {
  const FavouriteClinicsPage({super.key});

  @override
  State<FavouriteClinicsPage> createState() => _FavouriteClinicsPageState();
}

class _FavouriteClinicsPageState extends State<FavouriteClinicsPage> {
  final TextEditingController _searchController = TextEditingController();

  // TODO(favorites-data-layer): replace with a real FavouritesRepository once
  // one exists — these are the caregiver's currently-favourited clinics.
  List<ClinicEntity> _favouriteClinics = const [
    ClinicEntity(
      id: 'legacy-1',
      name: 'Legacy Clinic',
      location: 'Kigali, Rwa',
      imageAsset: 'assets/images/clinic-0.jpg',
      logoBackgroundColor: Color(0xFF2B2B2B),
      logoIcon: Icons.local_hospital,
    ),
    ClinicEntity(
      id: 'king-faisal-1',
      name: 'King Faisal',
      location: 'Kigali, Rwa',
      imageAsset: 'assets/images/clinic-1.jpg',
      logoBackgroundColor: AppColors.primary,
      logoIcon: Icons.local_hospital,
    ),
    ClinicEntity(
      id: 'legacy-2',
      name: 'Legacy Clinic',
      location: 'Kigali, Rwa',
      imageAsset: 'assets/images/clinic-0.jpg',
      logoBackgroundColor: Color(0xFF2B2B2B),
      logoIcon: Icons.local_hospital,
    ),
    ClinicEntity(
      id: 'king-faisal-2',
      name: 'King Faisal',
      location: 'Kigali, Rwa',
      imageAsset: 'assets/images/clinic-1.jpg',
      logoBackgroundColor: AppColors.primary,
      logoIcon: Icons.local_hospital,
    ),
    ClinicEntity(
      id: 'legacy-3',
      name: 'Legacy Clinic',
      location: 'Kigali, Rwa',
      imageAsset: 'assets/images/clinic-0.jpg',
      logoBackgroundColor: Color(0xFF2B2B2B),
      logoIcon: Icons.local_hospital,
    ),
    ClinicEntity(
      id: 'king-faisal-3',
      name: 'King Faisal',
      location: 'Kigali, Rwa',
      imageAsset: 'assets/images/clinic-1.jpg',
      logoBackgroundColor: AppColors.primary,
      logoIcon: Icons.local_hospital,
    ),
  ];

  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _unfavourite(String id) {
    setState(() {
      _favouriteClinics = _favouriteClinics
          .where((clinic) => clinic.id != id)
          .toList();
    });
  }

  void _openClinicDetails(ClinicEntity clinic) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ClinicDetailsPage(clinic: clinic)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasNoFavourites = _favouriteClinics.isEmpty;
    final visibleClinics = _favouriteClinics.where((clinic) {
      if (_query.isEmpty) return true;
      return clinic.name.toLowerCase().contains(_query.toLowerCase());
    }).toList();
    final hasNoSearchResults = !hasNoFavourites && visibleClinics.isEmpty;

    return Scaffold(
      body: Stack(
        children: [
          const SoftGradientBackground(),
          SafeArea(
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
                    child: hasNoFavourites
                        ? const _EmptyFavourites(
                            icon: Icons.favorite_border,
                            title: 'No favourite clinics yet',
                            message:
                                'Clinics you mark as favourite will show up here.',
                          )
                        : hasNoSearchResults
                        ? const _EmptyFavourites(
                            icon: Icons.search_off_rounded,
                            title: 'No matches found',
                            message: 'Try a different search term.',
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: visibleClinics.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
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
                                onUnfavourite: () => _unfavourite(clinic.id),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
        fillColor: const Color(0xFFF1F2F4),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(28),
          borderSide: BorderSide.none,
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
        padding: const EdgeInsets.fromLTRB(12, 20, 12, 16),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: ClipOval(
                        child: Image.asset(
                          clinic.imageAsset,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  clinic.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Located in ${clinic.location}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            Positioned(
              top: -8,
              right: -4,
              child: GestureDetector(
                onTap: onUnfavourite,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: AppColors.error,
                    size: 18,
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

class _EmptyFavourites extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _EmptyFavourites({
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
