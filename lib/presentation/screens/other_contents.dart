import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/responsive.dart';
import '../providers/template_provider.dart';

/// Templates content for MainShell
class TemplatesContent extends StatefulWidget {
  const TemplatesContent({super.key});

  @override
  State<TemplatesContent> createState() => _TemplatesContentState();
}

class _TemplatesContentState extends State<TemplatesContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TemplateProvider>().loadTemplates();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final r = context.responsive;

    return SafeArea(
      child: Column(
        children: [
          _buildHeader('Templates', isDark, r),
          Expanded(
            child: Consumer<TemplateProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  padding: EdgeInsets.all(r.horizontalPadding),
                  itemCount: provider.filteredTemplates.length,
                  itemBuilder: (context, index) {
                    final template = provider.filteredTemplates[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: r.h(12)),
                      child: ListTile(
                        leading: Icon(Icons.description, color: AppColors.primary),
                        title: Text(template.name),
                        subtitle: Text(template.description),
                        trailing: Text('${template.taskCount} tasks'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String title, bool isDark, Responsive r) {
    return Container(
      padding: EdgeInsets.all(r.horizontalPadding),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: r.sp(24),
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Create content for MainShell
class CreateContent extends StatelessWidget {
  const CreateContent({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final r = context.responsive;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(r.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: r.h(20)),
            Text(
              'Create Checklist',
              style: TextStyle(
                fontSize: r.sp(24),
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            SizedBox(height: r.h(24)),
            TextField(
              decoration: InputDecoration(
                labelText: 'Checklist Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(r.r(12)),
                ),
              ),
            ),
            SizedBox(height: r.h(16)),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(r.r(12)),
                ),
              ),
            ),
            SizedBox(height: r.h(24)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: r.h(16)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(r.r(12)),
                  ),
                ),
                child: Text(
                  'Create',
                  style: TextStyle(
                    fontSize: r.sp(16),
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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

/// Shared content for MainShell  
class SharedContent extends StatelessWidget {
  const SharedContent({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final r = context.responsive;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(r.horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: r.h(20)),
            Text(
              'Shared With Me',
              style: TextStyle(
                fontSize: r.sp(24),
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            SizedBox(height: r.h(24)),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.share_outlined,
                      size: r.w(64),
                      color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    ),
                    SizedBox(height: r.h(16)),
                    Text(
                      'No shared checklists yet',
                      style: TextStyle(
                        fontSize: r.sp(16),
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Profile content for MainShell
class ProfileContent extends StatelessWidget {
  const ProfileContent({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final r = context.responsive;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(r.horizontalPadding),
        child: Column(
          children: [
            SizedBox(height: r.h(20)),
            CircleAvatar(
              radius: r.w(50),
              backgroundColor: AppColors.primary,
              child: Icon(
                Icons.person,
                size: r.w(50),
                color: Colors.white,
              ),
            ),
            SizedBox(height: r.h(16)),
            Text(
              'User Name',
              style: TextStyle(
                fontSize: r.sp(24),
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
              ),
            ),
            Text(
              'user@email.com',
              style: TextStyle(
                fontSize: r.sp(14),
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
            SizedBox(height: r.h(32)),
            _buildMenuItem(Icons.settings, 'Settings', isDark, r),
            _buildMenuItem(Icons.help_outline, 'Help', isDark, r),
            _buildMenuItem(Icons.info_outline, 'About', isDark, r),
            _buildMenuItem(Icons.logout, 'Logout', isDark, r),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, bool isDark, Responsive r) {
    return Container(
      margin: EdgeInsets.only(bottom: r.h(8)),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(r.r(12)),
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(
          title,
          style: TextStyle(
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
        ),
      ),
    );
  }
}
