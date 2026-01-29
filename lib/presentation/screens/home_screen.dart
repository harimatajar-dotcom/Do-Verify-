import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/utils/responsive.dart';
import '../../domain/entities/checklist_entity.dart';
import '../widgets/common/bottom_nav_bar.dart';
import '../providers/checklist_provider.dart';

class HomeScreen extends StatefulWidget {
  final bool showBottomNav;
  
  const HomeScreen({super.key, this.showBottomNav = true});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;
  String _selectedFilter = 'all';
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load checklists from API
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChecklistProvider>().loadChecklists();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ChecklistEntity> get _filteredChecklists {
    final provider = context.watch<ChecklistProvider>();
    var filtered = provider.checklists;

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((c) => c.title.toLowerCase().contains(query)).toList();
    }

    // Apply status filter
    switch (_selectedFilter) {
      case 'in-progress':
        filtered = filtered.where((c) => c.status == ChecklistStatus.inProgress).toList();
        break;
      case 'completed':
        filtered = filtered.where((c) => c.status == ChecklistStatus.completed).toList();
        break;
      case 'shared':
        filtered = filtered.where((c) => c.status == ChecklistStatus.shared).toList();
        break;
    }

    return filtered;
  }

  void _onNavTap(int index) {
    if (index == _currentNavIndex) return;

    setState(() => _currentNavIndex = index);

    switch (index) {
      case 1:
        Navigator.of(context).pushNamed('/templates');
        break;
      case 2:
        Navigator.of(context).pushNamed('/create');
        break;
      case 3:
        Navigator.of(context).pushNamed('/shared');
        break;
      case 4:
        Navigator.of(context).pushNamed('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final r = context.responsive;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(isDark, r),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: r.horizontalPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: r.h(16)),
                    _buildHero(isDark, r),
                    SizedBox(height: r.h(24)),
                    _buildStatsGrid(isDark, r),
                    SizedBox(height: r.h(24)),
                    _buildSearchBar(isDark, r),
                    SizedBox(height: r.h(16)),
                    _buildFilterChips(isDark, r),
                    SizedBox(height: r.h(24)),
                    _buildSectionHeader(isDark, r),
                    SizedBox(height: r.h(16)),
                    ..._filteredChecklists.map((checklist) => Padding(
                      padding: EdgeInsets.only(bottom: r.h(12)),
                      child: _buildChecklistCard(checklist, isDark, r),
                    )),
                    SizedBox(height: r.h(100)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: widget.showBottomNav
          ? BottomNavBar(
              currentIndex: _currentNavIndex,
              onTap: _onNavTap,
            )
          : null,
    );
  }

  Widget _buildHeader(bool isDark, Responsive r) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.horizontalPadding,
        vertical: r.h(12),
      ),
      child: Row(
        children: [
          Row(
            children: [
              Container(
                width: r.w(32),
                height: r.w(32),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(r.r(8)),
                ),
                child: Icon(
                  Icons.check_box_outlined,
                  color: Colors.white,
                  size: r.w(20),
                ),
              ),
              SizedBox(width: r.w(10)),
              Text(
                'CheckFlow',
                style: TextStyle(
                  fontSize: r.sp(18),
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('/notifications'),
            child: Stack(
              children: [
                Container(
                  width: r.w(40),
                  height: r.w(40),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(r.r(12)),
                  ),
                  child: Icon(
                    Icons.notifications_outlined,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    size: r.w(22),
                  ),
                ),
                Positioned(
                  right: r.w(6),
                  top: r.h(6),
                  child: Container(
                    width: r.w(18),
                    height: r.w(18),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: r.sp(10),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero(bool isDark, Responsive r) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, User!',
          style: TextStyle(
            fontSize: r.sp(28),
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        SizedBox(height: r.h(4)),
        Text(
          "Let's get things done today",
          style: TextStyle(
            fontSize: r.sp(15),
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(bool isDark, Responsive r) {
    final stats = [
      {'icon': Icons.check_box_outlined, 'value': '3', 'label': 'Checklists', 'color': AppColors.primary},
      {'icon': Icons.check_circle_outline, 'value': '8', 'label': 'Completed', 'color': AppColors.success},
      {'icon': Icons.access_time, 'value': '2', 'label': 'In Progress', 'color': AppColors.warning},
      {'icon': Icons.star_outline, 'value': '15', 'label': 'Total Tasks', 'color': AppColors.terracotta},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: r.gridColumns > 2 ? 4 : 2,
        crossAxisSpacing: r.w(10),
        mainAxisSpacing: r.h(10),
        childAspectRatio: r.isSmallPhone ? 1.3 : 1.5,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return _buildStatCard(
          icon: stat['icon'] as IconData,
          value: stat['value'] as String,
          label: stat['label'] as String,
          color: stat['color'] as Color,
          isDark: isDark,
          r: r,
        );
      },
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required bool isDark,
    required Responsive r,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.w(12), vertical: r.h(10)),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(r.r(AppDimensions.radiusMd)),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
            blurRadius: AppDimensions.shadowBlurSm,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: r.w(28),
            height: r.w(28),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(r.r(8)),
            ),
            child: Icon(icon, color: color, size: r.w(16)),
          ),
          SizedBox(height: r.h(6)),
          Text(
            value,
            style: TextStyle(
              fontSize: r.sp(20),
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: r.sp(10),
              color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(bool isDark, Responsive r) {
    return Container(
      height: r.h(48),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(r.r(AppDimensions.radiusMd)),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.shadowDark : AppColors.shadowLight,
            blurRadius: AppDimensions.shadowBlurSm,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        style: TextStyle(
          fontSize: r.sp(14),
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        ),
        decoration: InputDecoration(
          hintText: 'Search checklists...',
          hintStyle: TextStyle(
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            fontSize: r.sp(14),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            size: r.w(20),
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: r.h(14)),
        ),
      ),
    );
  }

  Widget _buildFilterChips(bool isDark, Responsive r) {
    final filters = [
      {'key': 'all', 'label': 'All'},
      {'key': 'in-progress', 'label': 'In Progress'},
      {'key': 'completed', 'label': 'Completed'},
      {'key': 'shared', 'label': 'Shared'},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter['key'];
          return Padding(
            padding: EdgeInsets.only(right: r.w(8)),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = filter['key']!),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: r.w(16), vertical: r.h(8)),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
                  borderRadius: BorderRadius.circular(r.r(20)),
                  border: isSelected
                      ? null
                      : Border.all(
                          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                        ),
                ),
                child: Text(
                  filter['label']!,
                  style: TextStyle(
                    fontSize: r.sp(13),
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

  Widget _buildSectionHeader(bool isDark, Responsive r) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'My Checklists',
          style: TextStyle(
            fontSize: r.sp(18),
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).pushNamed('/templates'),
          child: Text(
            'Browse Templates',
            style: TextStyle(
              fontSize: r.sp(14),
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChecklistCard(ChecklistEntity checklist, bool isDark, Responsive r) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed('/checklist', arguments: checklist),
      child: Container(
        padding: EdgeInsets.all(r.w(16)),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(r.r(AppDimensions.radiusMd)),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        checklist.title,
                        style: TextStyle(
                          fontSize: r.sp(16),
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                      SizedBox(height: r.h(4)),
                      Text(
                        '${checklist.totalTasks} tasks · Created ${checklist.timeAgo}',
                        style: TextStyle(
                          fontSize: r.sp(12),
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusBadge(checklist, isDark, r),
              ],
            ),
            SizedBox(height: r.h(16)),
            // Progress bar
            Container(
              height: r.h(6),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.gray200,
                borderRadius: BorderRadius.circular(r.r(3)),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: checklist.progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: checklist.isCompleted ? AppColors.success : AppColors.primary,
                    borderRadius: BorderRadius.circular(r.r(3)),
                  ),
                ),
              ),
            ),
            SizedBox(height: r.h(8)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${checklist.completedTasks} of ${checklist.totalTasks} completed',
                  style: TextStyle(
                    fontSize: r.sp(12),
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
                Text(
                  '${checklist.progressPercent}%',
                  style: TextStyle(
                    fontSize: r.sp(12),
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ChecklistEntity checklist, bool isDark, Responsive r) {
    Color bgColor;
    Color textColor;
    String label;
    IconData? icon;

    switch (checklist.status) {
      case ChecklistStatus.completed:
        bgColor = AppColors.success.withOpacity(0.1);
        textColor = AppColors.success;
        label = 'Completed';
        break;
      case ChecklistStatus.shared:
        bgColor = AppColors.info.withOpacity(0.1);
        textColor = AppColors.info;
        label = 'Shared';
        icon = Icons.people_outline;
        break;
      case ChecklistStatus.inProgress:
        bgColor = AppColors.warning.withOpacity(0.1);
        textColor = AppColors.warning;
        label = 'In Progress';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: r.w(10), vertical: r.h(4)),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(r.r(12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: r.w(12), color: textColor),
            SizedBox(width: r.w(4)),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: r.sp(11),
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
