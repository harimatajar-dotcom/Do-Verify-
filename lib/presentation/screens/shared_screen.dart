import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../domain/entities/shared_checklist_entity.dart';
import '../widgets/common/bottom_nav_bar.dart';

class SharedScreen extends StatefulWidget {
  const SharedScreen({super.key});

  @override
  State<SharedScreen> createState() => _SharedScreenState();
}

class _SharedScreenState extends State<SharedScreen> {
  int _currentNavIndex = 3;
  String _selectedFilter = 'all';
  final List<SharedChecklistEntity> _sharedWithMe = SharedChecklistEntity.sampleSharedWithMe();
  final List<SharedChecklistEntity> _sharedByMe = SharedChecklistEntity.sampleSharedByMe();

  List<SharedChecklistEntity> get _filteredSharedWithMe {
    if (_selectedFilter == 'all') return _sharedWithMe;
    if (_selectedFilter == 'can-edit') return _sharedWithMe.where((s) => s.canEdit).toList();
    if (_selectedFilter == 'view-only') return _sharedWithMe.where((s) => !s.canEdit).toList();
    return _sharedWithMe;
  }

  void _onNavTap(int index) {
    if (index == _currentNavIndex) return;

    setState(() => _currentNavIndex = index);

    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/home');
        break;
      case 1:
        Navigator.of(context).pushReplacementNamed('/templates');
        break;
      case 2:
        Navigator.of(context).pushNamed('/create');
        break;
      case 4:
        Navigator.of(context).pushReplacementNamed('/profile');
        break;
    }
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppDimensions.screenPaddingH),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildHero(isDark),
                    const SizedBox(height: 16),
                    _buildFilterChips(isDark),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Recent', '${_filteredSharedWithMe.length} checklists', isDark),
                    const SizedBox(height: 16),
                    ..._filteredSharedWithMe.map((checklist) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildSharedCard(checklist, isDark),
                    )),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Shared By Me', '${_sharedByMe.length} checklists', isDark),
                    const SizedBox(height: 16),
                    ..._sharedByMe.map((checklist) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildSharedByMeCard(checklist, isDark),
                    )),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingH,
        vertical: 12,
      ),
      child: Row(
        children: [
          Row(
            children: [
              Icon(
                Icons.share,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 10),
              Text(
                'Shared',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.filter_list,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shared With Me',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Checklists shared by your team',
          style: TextStyle(
            fontSize: 15,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips(bool isDark) {
    final filters = [
      {'key': 'all', 'label': 'All'},
      {'key': 'can-edit', 'label': 'Can Edit'},
      {'key': 'view-only', 'label': 'View Only'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter['key'];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter['key']!),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
                  borderRadius: BorderRadius.circular(20),
                  border: isSelected
                      ? null
                      : Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                ),
                child: Text(
                  filter['label']!,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildSharedCard(SharedChecklistEntity checklist, bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed('/checklist'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          boxShadow: [
            BoxShadow(
              color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
              blurRadius: AppDimensions.shadowBlurSm,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildOwnerAvatar(checklist.ownerInitials, checklist.ownerColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        checklist.ownerName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        'Shared ${checklist.sharedTime}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildPermissionBadge(checklist.canEdit, isDark),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              checklist.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            if (checklist.description != null) ...[
              const SizedBox(height: 4),
              Text(
                checklist.description!,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            _buildProgressSection(checklist, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildSharedByMeCard(SharedChecklistEntity checklist, bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed('/checklist'),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          border: Border.all(
            color: AppColors.primary.withAlpha(51),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
              blurRadius: AppDimensions.shadowBlurSm,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildCollaboratorAvatars(checklist.collaboratorCount ?? 1),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        checklist.ownerName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      Text(
                        'You shared ${checklist.sharedTime}',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () => _showToast('Access management coming soon!'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Manage', style: TextStyle(fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              checklist.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            if (checklist.description != null) ...[
              const SizedBox(height: 4),
              Text(
                checklist.description!,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 12),
            _buildProgressSection(checklist, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildOwnerAvatar(String initials, String colorHex) {
    Color color;
    try {
      color = Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    } catch (_) {
      color = AppColors.primary;
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [color, color.withAlpha(200)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildCollaboratorAvatars(int count) {
    final colors = [AppColors.terracotta, AppColors.olive, AppColors.primary];

    return SizedBox(
      width: count > 1 ? 40 + (count - 1) * 12.0 : 40,
      height: 40,
      child: Stack(
        children: List.generate(count > 3 ? 3 : count, (index) {
          return Positioned(
            left: index * 12.0,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: colors[index % colors.length],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPermissionBadge(bool canEdit, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: canEdit
            ? AppColors.primary.withAlpha(26)
            : (isDark ? AppColors.darkSurface : AppColors.gray100),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            canEdit ? Icons.edit_outlined : Icons.visibility_outlined,
            size: 12,
            color: canEdit ? AppColors.primary : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
          ),
          const SizedBox(width: 4),
          Text(
            canEdit ? 'Can Edit' : 'View Only',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: canEdit ? AppColors.primary : (isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(SharedChecklistEntity checklist, bool isDark) {
    return Column(
      children: [
        Container(
          height: 6,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.gray200,
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: checklist.progress,
            child: Container(
              decoration: BoxDecoration(
                color: checklist.isCompleted ? AppColors.success : AppColors.primary,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${checklist.completedTasks} of ${checklist.totalTasks} tasks',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
            Text(
              '${checklist.progressPercent}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
