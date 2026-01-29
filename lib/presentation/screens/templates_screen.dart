import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/responsive.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/template_entity.dart';
import '../providers/template_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/common/app_header.dart';
import '../widgets/common/bottom_nav_bar.dart';
import '../widgets/common/custom_search_bar.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/common/filter_chips.dart';
import '../widgets/templates/featured_scroll.dart';
import '../widgets/templates/template_preview_modal.dart';
import '../widgets/templates/category_icon.dart';

/// Main templates screen
class TemplatesScreen extends StatefulWidget {
  final bool showBottomNav;
  
  const TemplatesScreen({super.key, this.showBottomNav = true});

  @override
  State<TemplatesScreen> createState() => _TemplatesScreenState();
}

class _TemplatesScreenState extends State<TemplatesScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _currentNavIndex = 1; // Templates tab selected

  @override
  void initState() {
    super.initState();
    // Load templates when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TemplateProvider>().loadTemplates();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String query) {
    context.read<TemplateProvider>().searchTemplates(query);
  }

  void _onCategorySelected(Category category) {
    context.read<TemplateProvider>().filterByCategory(category);
  }

  void _onTemplateTap(TemplateEntity template) {
    TemplatePreviewModal.show(
      context,
      template: template,
      onUseTemplate: () => _useTemplate(template),
    );
  }

  void _useTemplate(TemplateEntity template) {
    // TODO: Navigate to create checklist from template
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Creating checklist from "${template.name}"'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _onNavTap(int index) {
    if (index == _currentNavIndex) return;

    setState(() {
      _currentNavIndex = index;
    });

    // Handle navigation
    switch (index) {
      case 0:
        Navigator.of(context).pushReplacementNamed('/home');
        break;
      case 1:
        // Already on Templates
        break;
      case 2:
        Navigator.of(context).pushNamed('/create');
        break;
      case 3:
        Navigator.of(context).pushReplacementNamed('/shared');
        break;
      case 4:
        Navigator.of(context).pushReplacementNamed('/profile');
        break;
    }
  }

  void _toggleTheme() {
    context.read<ThemeProvider>().toggleTheme();
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
            // Header
            AppHeader(
              title: AppStrings.templatesTitle,
              onThemeToggle: _toggleTheme,
            ),

            // Content
            Expanded(
              child: Consumer<TemplateProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (provider.error != null) {
                    return EmptyState(
                      icon: Icons.error_outline,
                      title: AppStrings.errorTitle,
                      message: provider.error!,
                      actionLabel: AppStrings.retry,
                      onAction: () => provider.loadTemplates(),
                    );
                  }

                  return _buildContent(provider, isDark, r);
                },
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

  Widget _buildContent(TemplateProvider provider, bool isDark, Responsive r) {
    final featuredTemplates = provider.featuredTemplates;
    final filteredTemplates = provider.filteredTemplates;
    final selectedCategory = provider.selectedCategory;
    final searchQuery = provider.searchQuery;

    // Check if we're showing search results or filtered results
    final isSearching = searchQuery.isNotEmpty;
    final isFiltering = selectedCategory != Category.all;

    return CustomScrollView(
      slivers: [
        // Search bar
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.all(r.horizontalPadding),
            child: CustomSearchBar(
              controller: _searchController,
              onChanged: _onSearch,
              hintText: AppStrings.searchPlaceholder,
            ),
          ),
        ),

        // Filter chips
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(bottom: r.h(AppDimensions.spacingLg)),
            child: FilterChips(
              categories: Category.values,
              selectedCategory: selectedCategory,
              onCategorySelected: _onCategorySelected,
            ),
          ),
        ),

        // Featured section (only show if not searching/filtering)
        if (!isSearching && !isFiltering && featuredTemplates.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: _buildSectionTitle(AppStrings.featuredTemplates, isDark, r),
          ),
          SliverToBoxAdapter(
            child: FeaturedScroll(
              templates: featuredTemplates,
              onTemplateTap: _onTemplateTap,
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: r.h(AppDimensions.spacingXxl)),
          ),
        ],

        // All templates section title
        SliverToBoxAdapter(
          child: _buildSectionTitle(
            isSearching
                ? AppStrings.searchResults
                : isFiltering
                    ? selectedCategory.fullName
                    : AppStrings.allTemplates,
            isDark,
            r,
          ),
        ),

        // Template list or empty state
        if (filteredTemplates.isEmpty)
          SliverFillRemaining(
            hasScrollBody: false,
            child: EmptyState(
              icon: Icons.search_off,
              title: AppStrings.noTemplatesTitle,
              message: isSearching
                  ? AppStrings.noSearchResults
                  : AppStrings.noTemplatesMessage,
            ),
          )
        else
          SliverPadding(
            padding: EdgeInsets.symmetric(
              horizontal: r.horizontalPadding,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final template = filteredTemplates[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index < filteredTemplates.length - 1
                          ? r.h(AppDimensions.spacingMd)
                          : r.h(AppDimensions.spacingXxl),
                    ),
                    child: _TemplateCardItem(
                      template: template,
                      onTap: () => _onTemplateTap(template),
                    ),
                  );
                },
                childCount: filteredTemplates.length,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, bool isDark, Responsive r) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: r.horizontalPadding,
        vertical: r.h(AppDimensions.spacingMd),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: r.sp(AppDimensions.fontXl),
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
        ),
      ),
    );
  }
}

/// Template card item for the sliver list
class _TemplateCardItem extends StatelessWidget {
  final TemplateEntity template;
  final VoidCallback? onTap;

  const _TemplateCardItem({
    required this.template,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final r = context.responsive;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(r.w(AppDimensions.spacingLg)),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon container
            Container(
              width: r.w(AppDimensions.templateIconSize),
              height: r.w(AppDimensions.templateIconSize),
              decoration: BoxDecoration(
                color: CategoryIcon.getBackgroundColor(template.category, isDark),
                borderRadius: BorderRadius.circular(r.r(AppDimensions.radiusSm)),
              ),
              child: Center(
                child: CategoryIcon(
                  category: template.category,
                  size: r.w(AppDimensions.iconLg),
                  color: CategoryIcon.getForegroundColor(template.category),
                ),
              ),
            ),

            SizedBox(width: r.w(AppDimensions.templateCardGap)),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    template.name,
                    style: TextStyle(
                      fontSize: r.sp(AppDimensions.fontLg),
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),

                  SizedBox(height: r.h(AppDimensions.spacingXs)),

                  // Description
                  Text(
                    template.description,
                    style: TextStyle(
                      fontSize: r.sp(AppDimensions.fontMd),
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: r.h(AppDimensions.spacingSm)),

                  // Meta row
                  Row(
                    children: [
                      // Category badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: r.w(AppDimensions.spacingSm),
                          vertical: r.h(AppDimensions.spacingXxs),
                        ),
                        decoration: BoxDecoration(
                          color: CategoryIcon.getBackgroundColor(
                            template.category,
                            isDark,
                          ),
                          borderRadius: BorderRadius.circular(
                            r.r(AppDimensions.radiusXs),
                          ),
                        ),
                        child: Text(
                          template.category.name,
                          style: TextStyle(
                            fontSize: r.sp(AppDimensions.fontXs),
                            fontWeight: FontWeight.w500,
                            color: CategoryIcon.getForegroundColor(template.category),
                          ),
                        ),
                      ),

                      SizedBox(width: r.w(AppDimensions.spacingSm)),

                      // Task count
                      Text(
                        AppStrings.taskCount(template.taskCount),
                        style: TextStyle(
                          fontSize: r.sp(AppDimensions.fontSm),
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
